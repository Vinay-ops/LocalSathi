/// Station model representing a train station
/// Replaces news articles with train stations for the UI card components
class Station {
  final String id;
  final String name;
  final String code; // 3-letter station code (e.g., "CST" for CSMT)
  final String line; // Railway line (WR - Western, CR - Central, etc.)
  final double distance; // Distance from starting point in km
  final String description;

  Station({
    required this.id,
    required this.name,
    required this.code,
    required this.line,
    required this.distance,
    required this.description,
  });

  @override
  String toString() => '$name ($line)';
}

/// Route model representing a train route between two stations
class Route {
  final String id;
  final Station source;
  final Station destination;
  final List<String> intermediateStations;
  final double baseFare; // Base fare for this route
  final double distance; // Total distance
  final String trainName;
  final String trainNumber;

  Route({
    required this.id,
    required this.source,
    required this.destination,
    required this.intermediateStations,
    required this.baseFare,
    required this.distance,
    required this.trainName,
    required this.trainNumber,
  });

  @override
  String toString() => '$trainName ($trainNumber)';
}

/// Ticket model representing a booked ticket
class Ticket {
  final String id;
  final String bookingId;
  final Station source;
  final Station destination;
  final String ticketType; // 'Single' or 'Return'
  final String ticketClass; // 'First Class', 'Second Class', 'AC Class'
  final double fare;
  final DateTime bookingDateTime;
  final String qrCode; // Mock QR code string
  final String? passengerName; // Optional - not required in simplified flow
  final String? seatNumber; // Optional - not required in simplified flow

  Ticket({
    required this.id,
    required this.bookingId,
    required this.source,
    required this.destination,
    required this.ticketType,
    required this.ticketClass,
    required this.fare,
    required this.bookingDateTime,
    required this.qrCode,
    this.passengerName,
    this.seatNumber,
  });

  /// Format booking time for display
  String get formattedBookingTime {
    return '${bookingDateTime.day}/${bookingDateTime.month}/${bookingDateTime.year} ${bookingDateTime.hour}:${bookingDateTime.minute.toString().padLeft(2, '0')}';
  }
}

/// Booking state model for tracking current booking
class BookingState {
  final Station? source;
  final Station? destination;
  final String ticketType;
  final String ticketClass;
  final String? passengerName;
  final String? seatNumber;
  final double? calculatedFare;

  BookingState({
    this.source,
    this.destination,
    this.ticketType = 'Single',
    this.ticketClass = 'Second Class',
    this.passengerName,
    this.seatNumber,
    this.calculatedFare,
  });

  /// Create a copy with modifications
  BookingState copyWith({
    Station? source,
    Station? destination,
    String? ticketType,
    String? ticketClass,
    String? passengerName,
    String? seatNumber,
    double? calculatedFare,
  }) {
    return BookingState(
      source: source ?? this.source,
      destination: destination ?? this.destination,
      ticketType: ticketType ?? this.ticketType,
      ticketClass: ticketClass ?? this.ticketClass,
      passengerName: passengerName ?? this.passengerName,
      seatNumber: seatNumber ?? this.seatNumber,
      calculatedFare: calculatedFare ?? this.calculatedFare,
    );
  }

  /// Check if booking is valid (source and destination selected)
  bool get isValid => source != null && destination != null;

  /// Check if booking is complete (ready for confirmation)
  /// Simplified: only needs source and destination selected
  bool get isComplete => isValid;
}
