import 'package:flutter/foundation.dart';
import '../models/station.dart';
import '../services/train_ticket_service.dart';

/// State management for train ticket booking
/// Manages the booking flow and state without external dependencies
class TicketBookingProvider extends ChangeNotifier {
  final TrainTicketService _service = TrainTicketService();

  BookingState _bookingState = BookingState();
  List<Station> _stations = [];
  final List<Ticket> _userTickets = [];

  // Getters
  BookingState get bookingState => _bookingState;
  List<Station> get stations => _stations;
  List<Ticket> get userTickets => _userTickets;
  TrainTicketService get service => _service;

  // Initialization
  void initialize() {
    _stations = _service.getAllStations();
    notifyListeners();
  }

  /// Set source station
  void setSourceStation(Station station) {
    _bookingState = _bookingState.copyWith(source: station);
    notifyListeners();
  }

  /// Set destination station
  void setDestinationStation(Station station) {
    _bookingState = _bookingState.copyWith(destination: station);
    notifyListeners();
  }

  /// Swap source and destination
  void swapStations() {
    if (_bookingState.source != null && _bookingState.destination != null) {
      _bookingState = _bookingState.copyWith(
        source: _bookingState.destination,
        destination: _bookingState.source,
      );
      notifyListeners();
    }
  }

  /// Set ticket type (Single or Return)
  void setTicketType(String type) {
    _bookingState = _bookingState.copyWith(ticketType: type);
    _recalculateFare();
    notifyListeners();
  }

  /// Set ticket class
  void setTicketClass(String ticketClass) {
    _bookingState = _bookingState.copyWith(ticketClass: ticketClass);
    _recalculateFare();
    notifyListeners();
  }

  /// Set passenger name
  void setPassengerName(String name) {
    _bookingState = _bookingState.copyWith(passengerName: name);
    notifyListeners();
  }

  /// Set seat number
  void setSeatNumber(String seat) {
    _bookingState = _bookingState.copyWith(seatNumber: seat);
    notifyListeners();
  }

  /// Calculate and update fare based on current booking state
  void _recalculateFare() {
    if (_bookingState.isValid) {
      final fare = _service.calculateFare(
        source: _bookingState.source!,
        destination: _bookingState.destination!,
        ticketClass: _bookingState.ticketClass,
        ticketType: _bookingState.ticketType,
      );
      _bookingState = _bookingState.copyWith(calculatedFare: fare);
    }
  }

  /// Get current fare
  double? getFare() => _bookingState.calculatedFare;

  /// Confirm booking and create ticket
  Ticket? confirmBooking() {
    if (!_bookingState.isValid) return null;

    final ticket = _service.createTicket(
      source: _bookingState.source!,
      destination: _bookingState.destination!,
      ticketType: _bookingState.ticketType,
      ticketClass: _bookingState.ticketClass,
      fare: _bookingState.calculatedFare ?? 0,
    );

    _userTickets.add(ticket);
    _resetBooking();
    notifyListeners();

    return ticket;
  }

  /// Reset booking to start new booking
  void resetBooking() {
    _resetBooking();
    notifyListeners();
  }

  /// Internal reset function
  void _resetBooking() {
    _bookingState = BookingState();
  }

  /// Get routes for current source and destination
  List<Route> getAvailableRoutes() {
    if (!_bookingState.isValid) return [];
    return _service.getRoutes(
      source: _bookingState.source!,
      destination: _bookingState.destination!,
    );
  }

  /// Get available seats
  List<String> getAvailableSeats() => _service.getAvailableSeats();
}
