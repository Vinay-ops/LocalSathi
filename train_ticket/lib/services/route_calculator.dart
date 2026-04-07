import 'fare_calculator.dart';
import '../data/train_lines_data.dart';

/// Represents a route with possible interchanges
class RouteOption {
  final String from;
  final String to;
  final List<String> stations;
  final List<String> lines; // Lines used in this route
  final List<String>? interchangeStations; // Stations where you change lines
  final double estimatedFare;
  final int estimatedTime; // in minutes
  final bool hasInterchange;

  RouteOption({
    required this.from,
    required this.to,
    required this.stations,
    required this.lines,
    this.interchangeStations,
    required this.estimatedFare,
    required this.estimatedTime,
    this.hasInterchange = false,
  });

  String get description {
    if (!hasInterchange ||
        interchangeStations == null ||
        interchangeStations!.isEmpty) {
      return 'Direct route via ${lines.first}';
    }

    final interchange = interchangeStations!.first;
    final line1 = lines.first;
    final line2 = lines.length > 1 ? lines[1] : line1;

    return '$line1 → Change at $interchange → $line2';
  }
}

/// Calculates routes between two stations considering line changes
class RouteCalculator {
  static const double baseFarePerStation = 5.0; // Base fare multiplier

  /// Extract line code from station name (e.g., 'Thane (CR)' -> 'CR')
  static String? getLineFromStation(String station) {
    final regex = RegExp(r'\(([A-Z]+)\)$');
    final match = regex.firstMatch(station);
    return match?.group(1);
  }

  /// Check if two stations are on the same line
  static bool isSameLine(String station1, String station2) {
    final line1 = getLineFromStation(station1);
    final line2 = getLineFromStation(station2);
    return line1 != null && line1 == line2;
  }

  /// Get all possible routes between two stations
  static List<RouteOption> calculateRoutes(
    String sourceStation,
    String destinationStation, {
    String ticketClass = 'Second Class',
    String ticketType = 'Single',
  }) {
    final sourceName = sourceStation.split('(')[0].trim();
    final destName = destinationStation.split('(')[0].trim();

    // Identify all lines for source and destination
    List<String> sourceLines = [];
    List<String> destLines = [];

    lineDistances.forEach((line, stations) {
      if (stations.containsKey(sourceName)) sourceLines.add(line);
      if (stations.containsKey(destName)) destLines.add(line);
    });

    if (sourceLines.isEmpty || destLines.isEmpty) {
      return [];
    }

    final routes = <RouteOption>[];

    // 1. Check for direct routes (on the same line)
    for (String sLine in sourceLines) {
      if (destLines.contains(sLine)) {
        routes.add(_createDirectRoute(
          sourceStation,
          destinationStation,
          sLine,
          ticketClass,
          ticketType,
        ));
      }
    }

    // 2. Check for interchange routes
    for (String sLine in sourceLines) {
      for (String dLine in destLines) {
        if (sLine == dLine) continue;

        final interchangeRoutes = _findInterchangeRoutes(
          sourceStation,
          destinationStation,
          sLine,
          dLine,
          ticketClass,
          ticketType,
        );
        routes.addAll(interchangeRoutes);
      }
    }

    // Remove duplicates (based on interchange station)
    final uniqueRoutes = <String, RouteOption>{};
    for (var route in routes) {
      final key = route.hasInterchange
          ? route.interchangeStations!.join(',')
          : 'direct-${route.lines.first}';
      if (!uniqueRoutes.containsKey(key)) {
        uniqueRoutes[key] = route;
      }
    }

    return uniqueRoutes.values.toList();
  }

  /// Create a direct route (no interchange)
  static RouteOption _createDirectRoute(
    String from,
    String to,
    String line,
    String ticketClass,
    String ticketType,
  ) {
    // Use new fare calculator
    const timePerStation = 3; // minutes per station
    const stationsCount = 5; // average stations

    // Calculate fare using FareCalculator
    final fare = FareCalculator.calculateSingleTicketFare(
      from,
      to,
      ticketClass,
      ticketType: ticketType,
      via: null, // No interchange
    );

    return RouteOption(
      from: from,
      to: to,
      stations: [from, '...', to],
      lines: [line],
      estimatedFare: fare,
      estimatedTime: stationsCount * timePerStation,
      hasInterchange: false,
    );
  }

  /// Find all possible interchange routes between two stations on different lines
  static List<RouteOption> _findInterchangeRoutes(
    String sourceStation,
    String destinationStation,
    String sourceLine,
    String destLine,
    String ticketClass,
    String ticketType,
  ) {
    final routes = <RouteOption>[];

    // Find common interchange stations
    final commonStations = _findCommonStations(sourceLine, destLine);

    for (final interchange in commonStations) {
      final interchangeName = interchange.keys.first;
      final sourceClean = sourceStation.split('(')[0].trim();
      final destClean = destinationStation.split('(')[0].trim();

      routes.add(
        RouteOption(
          from: sourceStation,
          to: destinationStation,
          stations: [sourceStation, interchangeName, destinationStation],
          lines: [sourceLine, destLine],
          interchangeStations: [interchangeName],
          estimatedFare: _calculateFare(
            sourceClean,
            interchangeName,
            destClean,
            ticketClass,
            ticketType,
          ),
          estimatedTime: _calculateTime(
            sourceClean,
            interchangeName,
            destClean,
          ),
          hasInterchange: true,
        ),
      );
    }

    return routes.isEmpty ? [] : routes;
  }

  /// Find common stations between two lines
  static List<Map<String, List<String>>> _findCommonStations(
    String line1,
    String line2,
  ) {
    // Comprehensive interchange station connections based on actual Mumbai local train routes
    final Map<String, Map<String, List<String>>> lineConnections = {
      // ==================== WR-CR (Western ↔ Central) ====================
      'WR-CR': {
        'Dadar': ['WR', 'CR'], // PRIMARY - Main interchange
        'Parel': ['WR', 'CR'], // SECONDARY - Walking interchange via Prabhadevi
        'Prabhadevi': [
          'WR',
          'CR',
        ], // SECONDARY - Walking interchange with Parel
      },
      'CR-WR': {
        'Dadar': ['CR', 'WR'],
        'Parel': ['CR', 'WR'],
        'Prabhadevi': ['CR', 'WR'],
      },

      // ==================== CR-HL (Central ↔ Harbour) ====================
      'CR-HL': {
        'Kurla': ['CR', 'HL'], // PRIMARY - Main interchange
      },
      'HL-CR': {
        'Kurla': ['HL', 'CR'],
      },

      // ==================== WR-HL (Western ↔ Harbour) ====================
      'WR-HL': {
        'Bandra': ['WR', 'HL'], // PRIMARY - Bandra interchange
        'Andheri': ['WR', 'HL'], // SECONDARY - Andheri interchange
      },
      'HL-WR': {
        'Bandra': ['HL', 'WR'],
        'Andheri': ['HL', 'WR'],
      },

      // ==================== CR-THL (Central ↔ Trans-Harbour) ====================
      'CR-THL': {
        'Thane': ['CR', 'THL'], // PRIMARY - Main interchange for Navi Mumbai
      },
      'THL-CR': {
        'Thane': ['THL', 'CR'],
      },

      // ==================== HL-THL (Harbour ↔ Trans-Harbour) ====================
      'HL-THL': {
        'Vashi': ['HL', 'THL'], // PRIMARY - Main Navi Mumbai hub
        'Panvel': ['HL', 'THL'],
      },
      'THL-HL': {
        'Vashi': ['THL', 'HL'],
        'Panvel': ['THL', 'HL'],
      },

      // ==================== WR-THL (Western ↔ Trans-Harbour) ====================
      'WR-THL': {
        'Dadar': ['WR', 'CR'], // Two-step: WR→CR at Dadar
        'Thane': ['CR', 'THL'], // Then CR→THL at Thane
      },
      'THL-WR': {
        'Thane': ['THL', 'CR'], // THL to CR
        'Dadar': ['CR', 'WR'], // CR to WR
      },

      // ==================== CR-HL via THL (for routing optimization) ====================
      'CR-HL-THL': {
        'Kurla': ['CR', 'HL'], // Direct via Kurla
        'Vashi': ['HL', 'THL'], // Via Vashi if needed
      },
    };

    final key1 = '$line1-$line2';
    final key2 = '$line2-$line1';

    return (lineConnections[key1] ?? lineConnections[key2] ?? {}).entries
        .map((e) => {e.key: e.value})
        .toList();
  }

  /// Calculate fare estimate based on stations and interchange
  /// Uses FareCalculator for proper class-based pricing
  static double _calculateFare(
    String from,
    String via,
    String to,
    String ticketClass,
    String ticketType,
  ) {
    // Total journey distance is handled by FareCalculator which understands interchanges
    return FareCalculator.calculateSingleTicketFare(
      from,
      to,
      ticketClass,
      ticketType: ticketType,
      via: via, // Pass the specific interchange
    );
  }

  /// Calculate time estimate in minutes based on route
  static int _calculateTime(String from, String via, String to) {
    // Time calculations
    const timePerSegment = 8; // minutes per station
    const averageStations = 5; // average stations per segment
    const interchangeTime = 5; // time to change train
    const waitingTime = 3; // average wait time for next train

    final segment1Time = averageStations * timePerSegment;
    final segment2Time = averageStations * timePerSegment;
    final totalTime =
        segment1Time + segment2Time + interchangeTime + waitingTime;

    return totalTime;
  }
}
