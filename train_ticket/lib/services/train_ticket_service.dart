import '../models/station.dart';

/// Service layer for managing train stations, routes, and ticket calculations
/// Replaces news API calls with mock data (similar to how news apps fetch articles)
class TrainTicketService {
  // Singleton pattern
  static final TrainTicketService _instance = TrainTicketService._internal();

  factory TrainTicketService() {
    return _instance;
  }

  TrainTicketService._internal();

  /// Mock list of stations - Replaces news categories/sources
  /// Real app would fetch from API
  final List<Station> _stations = [
    // Western Railway (WR) stations
    Station(
      id: '1',
      name: 'Churchgate',
      code: 'CHG',
      line: 'WR',
      distance: 0.0,
      description: 'Starting point of Western Railway suburban line',
    ),
    Station(
      id: '2',
      name: 'Marine Lines',
      code: 'MAR',
      line: 'WR',
      distance: 2.0,
      description: 'Central Mumbai station on Western Railway',
    ),
    Station(
      id: '3',
      name: 'Charni Road',
      code: 'CHR',
      line: 'WR',
      distance: 5.0,
      description: 'Major junction on Western Railway',
    ),
    Station(
      id: '4',
      name: 'Grant Road',
      code: 'GRT',
      line: 'WR',
      distance: 8.0,
      description: 'Local hub on Western Railway',
    ),
    Station(
      id: '5',
      name: 'Mumbai Central',
      code: 'MCL',
      line: 'WR',
      distance: 10.0,
      description: 'Major railway terminal on Western Railway',
    ),
    Station(
      id: '6',
      name: 'Dadar',
      code: 'DDR',
      line: 'WR',
      distance: 15.0,
      description: 'Junction connecting WR and CR lines',
    ),
    Station(
      id: '7',
      name: 'Bandra',
      code: 'BND',
      line: 'WR',
      distance: 22.0,
      description: 'Busy station in Bandra suburb',
    ),
    Station(
      id: '8',
      name: 'Andheri',
      code: 'ADH',
      line: 'WR',
      distance: 28.0,
      description: 'Major suburban station on Western Railway',
    ),
    Station(
      id: '9',
      name: 'Borivali',
      code: 'BOR',
      line: 'WR',
      distance: 38.0,
      description: 'Last major station on WR fast line',
    ),

    // Central Railway (CR) stations
    Station(
      id: '10',
      name: 'CSMT',
      code: 'CST',
      line: 'CR',
      distance: 0.0,
      description: 'Central Station starting point of Central Railway',
    ),
    Station(
      id: '11',
      name: 'Byculla',
      code: 'BYC',
      line: 'CR',
      distance: 2.5,
      description: 'Important station on Central Railway',
    ),
    Station(
      id: '12',
      name: 'Dadar',
      code: 'DDR',
      line: 'CR',
      distance: 8.0,
      description: 'Junction connecting CR and WR lines',
    ),
    Station(
      id: '13',
      name: 'Kurla',
      code: 'KRL',
      line: 'CR',
      distance: 12.0,
      description: 'Commercial hub on Central Railway',
    ),
    Station(
      id: '14',
      name: 'Ghatkopar',
      code: 'GTK',
      line: 'CR',
      distance: 15.0,
      description: 'Residential suburb on Central Railway',
    ),
    Station(
      id: '15',
      name: 'Thane',
      code: 'THN',
      line: 'CR',
      distance: 20.0,
      description: 'Major station serving Thane city',
    ),
    Station(
      id: '16',
      name: 'Dombivali',
      code: 'DOM',
      line: 'CR',
      distance: 25.0,
      description: 'Industrial suburb on Central Railway',
    ),
    Station(
      id: '17',
      name: 'Kalyan',
      code: 'KYN',
      line: 'CR',
      distance: 30.0,
      description: 'Last major station on CR line',
    ),
  ];

  /// Get all available stations
  List<Station> getAllStations() => List.from(_stations);

  /// Get stations by railway line
  List<Station> getStationsByLine(String line) {
    return _stations.where((station) => station.line == line).toList();
  }

  /// Get station by ID
  Station? getStationById(String id) {
    try {
      return _stations.firstWhere((station) => station.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Calculate fare based on distance and ticket class
  /// Replaces news article scoring with fare calculation logic
  double calculateFare({
    required Station source,
    required Station destination,
    required String ticketClass,
    required String ticketType,
  }) {
    // Calculate distance between stations
    double distance = (destination.distance - source.distance).abs();

    // Base fare: ₹5 for every 5km or part thereof
    double baseFare = (distance / 5).ceil() * 5.0;

    // Class multiplier
    double classMultiplier = switch (ticketClass) {
      'First Class' => 2.0,
      'AC Class' => 3.0,
      _ => 1.0, // Second Class
    };

    double fare = baseFare * classMultiplier;

    // Return ticket multiplier
    if (ticketType == 'Return') {
      fare *= 1.8; // Return tickets are 1.8x single fare
    }

    return double.parse(fare.toStringAsFixed(2));
  }

  /// Get mock routes between two stations
  List<Route> getRoutes({
    required Station source,
    required Station destination,
  }) {
    // In real app, this would search a database
    // For mock, return a sample route
    return [
      Route(
        id: '1',
        source: source,
        destination: destination,
        intermediateStations: [],
        baseFare: calculateFare(
          source: source,
          destination: destination,
          ticketClass: 'Second Class',
          ticketType: 'Single',
        ),
        distance: (destination.distance - source.distance).abs(),
        trainName: 'Mumbai Local Fast',
        trainNumber: 'ML-001',
      ),
      Route(
        id: '2',
        source: source,
        destination: destination,
        intermediateStations: [],
        baseFare:
            calculateFare(
              source: source,
              destination: destination,
              ticketClass: 'Second Class',
              ticketType: 'Single',
            ) +
            5,
        distance: (destination.distance - source.distance).abs(),
        trainName: 'Mumbai Local Slow',
        trainNumber: 'ML-002',
      ),
    ];
  }

  /// Generate a mock ticket ID (booking confirmation number)
  String generateBookingId() {
    DateTime now = DateTime.now();
    return 'ML${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}';
  }

  /// Generate a mock QR code string
  String generateQRCode(String bookingId) {
    return 'TICKET|$bookingId|${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Create a ticket after booking confirmation
  Ticket createTicket({
    required Station source,
    required Station destination,
    required String ticketType,
    required String ticketClass,
    required double fare,
    String? passengerName,
    String? seatNumber,
  }) {
    final bookingId = generateBookingId();
    return Ticket(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      bookingId: bookingId,
      source: source,
      destination: destination,
      ticketType: ticketType,
      ticketClass: ticketClass,
      fare: fare,
      bookingDateTime: DateTime.now(),
      qrCode: generateQRCode(bookingId),
      passengerName: passengerName,
      seatNumber: seatNumber,
    );
  }

  /// Get available seats (mock data)
  List<String> getAvailableSeats() {
    return [
      'A1',
      'A2',
      'A3',
      'A4',
      'A5',
      'B1',
      'B2',
      'B3',
      'B4',
      'B5',
      'C1',
      'C2',
      'C3',
      'C4',
      'C5',
      'D1',
      'D2',
      'D3',
      'D4',
      'D5',
    ];
  }

  /// Get recent bookings (for history)
  List<Ticket> getRecentBookings() {
    // Mock data - would come from local storage or API
    return [];
  }
}
