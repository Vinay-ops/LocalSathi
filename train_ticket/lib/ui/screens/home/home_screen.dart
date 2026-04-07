import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen_ui.dart';
import '../route_selection/route_selection_screen.dart';
import '../profile/profile_screen.dart';
import '../qr_ticket/qr_ticket_screen.dart';
import '../../../domain/usecases/home_screen_usecase.dart';

/// Home Screen - Main Container
/// Manages state and delegates UI rendering to HomeScreenUI
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeScreenUsecase _homeUsecase = HomeScreenUsecase();

  // Selected values
  String sourceStation = 'Churchgate (WR)';
  String destinationStation = 'Borivali (WR)';
  String ticketClass = 'Second Class';
  String ticketType = 'Single';
  int ticketQuantity = 1;
  int currentBottomNavIndex = 0;

  late List<String> stations;

  @override
  void initState() {
    super.initState();
    // Initialize data
    stations = _homeUsecase.getAllStations();
    // Load saved preferences
    _loadSavedStations();
  }

  /// Load saved stations from SharedPreferences
  Future<void> _loadSavedStations() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      sourceStation = prefs.getString('sourceStation') ?? 'Churchgate (WR)';
      destinationStation =
          prefs.getString('destinationStation') ?? 'Borivali (WR)';
      ticketClass = prefs.getString('ticketClass') ?? 'Second Class';
      ticketType = prefs.getString('ticketType') ?? 'Single';
      ticketQuantity = prefs.getInt('ticketQuantity') ?? 1;
    });
  }

  /// Save preferences to SharedPreferences
  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sourceStation', sourceStation);
    await prefs.setString('destinationStation', destinationStation);
    await prefs.setString('ticketClass', ticketClass);
    await prefs.setString('ticketType', ticketType);
    await prefs.setInt('ticketQuantity', ticketQuantity);
  }

  /// Swap source and destination stations
  void _handleSwapStations() {
    setState(() {
      String temp = sourceStation;
      sourceStation = destinationStation;
      destinationStation = temp;
    });
    _savePreferences();
  }

  /// Handle source station change
  void _handleSourceStationChange(String? value) {
    if (value != null) {
      setState(() => sourceStation = value);
      _savePreferences();
    }
  }

  /// Handle destination station change
  void _handleDestinationStationChange(String? value) {
    if (value != null) {
      setState(() => destinationStation = value);
      _savePreferences();
    }
  }

  /// Handle class change
  void _handleClassChange(String? value) {
    if (value != null) {
      setState(() => ticketClass = value);
      _savePreferences();
    }
  }

  /// Handle ticket type change
  void _handleTypeChange(String? value) {
    if (value != null) {
      setState(() => ticketType = value);
      _savePreferences();
    }
  }

  /// Handle ticket quantity change
  void _handleQuantityChange(int value) {
    setState(() => ticketQuantity = value);
    _savePreferences();
  }

  /// Handle find trains action
  void _handleFindTrains() {
    // Validate stations
    if (!_homeUsecase.validateStations(sourceStation, destinationStation)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Source and Destination cannot be same')),
      );
      return;
    }

    // Navigate to route selection screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RouteSelectionScreen(
          source: sourceStation,
          destination: destinationStation,
          ticketClass: ticketClass,
          ticketType: ticketType,
          ticketQuantity: ticketQuantity,
        ),
      ),
    );
  }

  /// Handle recent search tap
  void _handleRecentSearchTap(String source, String destination) {
    setState(() {
      sourceStation = source;
      destinationStation = destination;
    });
  }

  /// Handle bottom navigation changes
  void _handleBottomNavChange(int index) {
    setState(() => currentBottomNavIndex = index);

    if (index == 0) {
      // Local trains tab - stay on home
      return;
    } else if (index == 1) {
      // Quick QR tab - navigate to QR ticket screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QRTicketScreen(
            source: sourceStation,
            destination: destinationStation,
            ticketClass: 'Second Class',
            ticketType: 'Single',
            fare: 25.0,
            bookingReference:
                'TKT${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
            selectedRoute: 'Direct route via WR',
          ),
        ),
      );
    } else if (index == 2) {
      // Profile tab - navigate to profile screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return HomeScreenUI(
      sourceStation: sourceStation,
      destinationStation: destinationStation,
      ticketClass: ticketClass,
      ticketType: ticketType,
      ticketQuantity: ticketQuantity,
      stations: stations,
      onSwapStations: _handleSwapStations,
      onSourceChanged: _handleSourceStationChange,
      onDestinationChanged: _handleDestinationStationChange,
      onClassChanged: _handleClassChange,
      onTypeChanged: _handleTypeChange,
      onQuantityChanged: _handleQuantityChange,
      onFindTrains: _handleFindTrains,
      onRecentSearchTap: _handleRecentSearchTap,
      currentBottomNavIndex: currentBottomNavIndex,
      onBottomNavChanged: _handleBottomNavChange,
    );
  }
}
