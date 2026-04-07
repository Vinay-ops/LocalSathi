import '../data/train_lines_data.dart';

/// Fare Calculation Engine for Mumbai Local Trains
///
/// Rules:
/// - Second Class: ₹5 per slab/km
/// - First Class: 4x Second Class
/// - AC Class: ₹35 base + ₹5 per slab/km

class FareCalculator {
  /// Calculate total journey distance in slabs by traversing stations
  static int _calculateJourneyDistance(String source, String destination, {String? via}) {
    // 1. Identify which lines each station belongs to
    List<String> sourceLines = [];
    List<String> destLines = [];

    lineDistances.forEach((line, stations) {
      if (stations.containsKey(source)) sourceLines.add(line);
      if (stations.containsKey(destination)) destLines.add(line);
    });

    // 2. If a specific interchange (via) is provided, calculate through it
    if (via != null) {
      int minViaDistance = 1000;
      bool viaRouteFound = false;

      for (String sLine in sourceLines) {
        for (String dLine in destLines) {
          if (lineDistances[sLine]!.containsKey(via) && lineDistances[dLine]!.containsKey(via)) {
            int dist1 = (lineDistances[sLine]![source]! - lineDistances[sLine]![via]!).abs();
            int dist2 = (lineDistances[dLine]![via]! - lineDistances[dLine]![destination]!).abs();
            int totalDist = dist1 + dist2;

            if (totalDist < minViaDistance) {
              minViaDistance = totalDist;
              viaRouteFound = true;
            }
          }
        }
      }
      if (viaRouteFound) return minViaDistance;
    }

    // 3. If they share a line and no specific interchange is requested, calculate direct distance
    for (String line in sourceLines) {
      if (destLines.contains(line)) {
        return (lineDistances[line]![source]! - lineDistances[line]![destination]!)
            .abs();
      }
    }

    // 4. Otherwise, find all possible interchange routes and pick the shortest
    int minDistance = 1000; // Large initial value
    bool routeFound = false;

    for (String sLine in sourceLines) {
      for (String dLine in destLines) {
        // Try to find common interchange stations for this line pair
        List<String> commonInterchanges = [];

        if ((sLine == 'WR' && dLine == 'CR') || (sLine == 'CR' && dLine == 'WR')) {
          commonInterchanges = ['Dadar'];
        } else if ((sLine == 'CR' && dLine == 'HL') || (sLine == 'HL' && dLine == 'CR')) {
          commonInterchanges = ['Kurla'];
        } else if ((sLine == 'WR' && dLine == 'HL') || (sLine == 'HL' && dLine == 'WR')) {
          if (lineDistances[sLine]!.containsKey('Bandra') && lineDistances[dLine]!.containsKey('Bandra')) {
            commonInterchanges.add('Bandra');
          }
          if (lineDistances[sLine]!.containsKey('Andheri') && lineDistances[dLine]!.containsKey('Andheri')) {
            commonInterchanges.add('Andheri');
          }
        } else if ((sLine == 'CR' && dLine == 'THL') || (sLine == 'THL' && dLine == 'CR')) {
          commonInterchanges = ['Thane'];
        } else if ((sLine == 'HL' && dLine == 'THL') || (sLine == 'THL' && dLine == 'HL')) {
          commonInterchanges = ['Vashi', 'Panvel'];
        }

        for (String interchange in commonInterchanges) {
          if (lineDistances[sLine]!.containsKey(interchange) && lineDistances[dLine]!.containsKey(interchange)) {
            int dist1 = (lineDistances[sLine]![source]! - lineDistances[sLine]![interchange]!).abs();
            int dist2 = (lineDistances[dLine]![interchange]! - lineDistances[dLine]![destination]!).abs();
            int totalDist = dist1 + dist2;
            
            if (totalDist < minDistance) {
              minDistance = totalDist;
              routeFound = true;
            }
          }
        }
      }
    }

    if (routeFound) return minDistance;

    // Default distance if no path found
    return 10;
  }

  /// Calculate distance slabs (each slab = 1 km or distance unit)
  /// Returns number of slabs for fare calculation
  static int calculateDistanceSlabs(
    String sourceStation,
    String destinationStation, {
    String? via,
  }) {
    // Extract station names (remove line codes like "(CR)", "(WR)", "(HL)", etc.)
    final source = sourceStation.split('(')[0].trim();
    final dest = destinationStation.split('(')[0].trim();
    final viaStation = via?.split('(')[0].trim();

    // Use comprehensive distance database
    return _calculateJourneyDistance(source, dest, via: viaStation);
  }

  /// Calculate fare for a single ticket
  ///
  /// Rules (Slab-based):
  /// - 0–10 km: II=₹5, I=₹20, AC=₹35
  /// - 11–30 km: II=₹10, I=₹40, AC=₹60
  /// - 31–50 km: II=₹15, I=₹60, AC=₹85
  /// - 51+ km: II=₹20, I=₹80, AC=₹110
  static double calculateSingleTicketFare(
    String sourceStation,
    String destinationStation,
    String ticketClass, {
    String ticketType = 'Single',
    String? via,
  }) {
    final km = calculateDistanceSlabs(sourceStation, destinationStation, via: via);
    final normalizedClass = ticketClass.toLowerCase().trim();
    double fare = 5.0;

    if (normalizedClass == 'second class') {
      if (km <= 10) {
        fare = 5.0;
      } else if (km <= 30) {
        fare = 10.0;
      } else if (km <= 50) {
        fare = 15.0;
      } else {
        fare = 20.0;
      }
    } else if (normalizedClass == 'first class') {
      if (km <= 10) {
        fare = 20.0;
      } else if (km <= 30) {
        fare = 40.0;
      } else if (km <= 50) {
        fare = 60.0;
      } else {
        fare = 80.0;
      }
    } else if (normalizedClass == 'ac class' || normalizedClass == 'ac local') {
      if (km <= 10) {
        fare = 35.0;
      } else if (km <= 30) {
        fare = 60.0;
      } else if (km <= 50) {
        fare = 85.0;
      } else {
        fare = 110.0;
      }
    }

    // Apply Return ticket multiplier (2x)
    if (ticketType.toLowerCase().trim() == 'return') {
      fare *= 2;
    }

    return fare;
  }

  /// Calculate total fare for multiple tickets
  static double calculateTotalFare(
    String sourceStation,
    String destinationStation,
    String ticketClass,
    int ticketQuantity, {
    String ticketType = 'Single',
    String? via,
  }) {
    final singleFare = calculateSingleTicketFare(
      sourceStation,
      destinationStation,
      ticketClass,
      ticketType: ticketType,
      via: via,
    );
    return singleFare * ticketQuantity;
  }

  /// Get fare breakdown for display
  static Map<String, dynamic> getFareBreakdown(
    String sourceStation,
    String destinationStation,
    String ticketClass,
    int ticketQuantity, {
    String ticketType = 'Single',
    String? via,
  }) {
    final slabs = calculateDistanceSlabs(sourceStation, destinationStation, via: via);
    final singleFare = calculateSingleTicketFare(
      sourceStation,
      destinationStation,
      ticketClass,
      ticketType: ticketType,
      via: via,
    );
    final totalFare = singleFare * ticketQuantity;

    return {
      'slabs': slabs,
      'singleFare': singleFare,
      'quantity': ticketQuantity,
      'totalFare': totalFare,
      'fare_per_slab': '₹$singleFare',
      'ticketType': ticketType,
      'via': via,
    };
  }
}
