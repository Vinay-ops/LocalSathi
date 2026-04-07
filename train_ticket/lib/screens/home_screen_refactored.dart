import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/station.dart' as station_models;
import '../providers/ticket_booking_provider.dart';
import '../widgets/ticket_widgets.dart';
import 'qr_ticket_screen.dart';
import 'profile_screen.dart';

/// Home screen container with navigation
/// Manages Booking and Profile screens
class HomeScreenRefactored extends StatefulWidget {
  const HomeScreenRefactored({super.key});

  @override
  State<HomeScreenRefactored> createState() => _HomeScreenRefactoredState();
}

class _HomeScreenRefactoredState extends State<HomeScreenRefactored> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.train, color: Color(0xFF1E88E5), size: 28),
            SizedBox(width: 8),
            Text(
              'RailJet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.train), label: 'Booking'),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Tickets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF1E88E5),
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
      body: _buildScreen(_selectedIndex),
    );
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return const _BookingScreen();
      case 1:
        return const _TicketsScreen();
      case 2:
        return const ProfileScreen();
      default:
        return const _BookingScreen();
    }
  }
}

/// Booking screen
class _BookingScreen extends StatelessWidget {
  const _BookingScreen();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<TicketBookingProvider>(
          builder: (context, provider, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress indicator
                BookingProgressStepper(
                  currentStep: 0,
                  steps: const [
                    'Route',
                    'Select',
                    'Details',
                    'Payment',
                    'Confirm',
                  ],
                ),
                const SizedBox(height: 24),

                // Source and destination selection card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Select Route',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Source station selector
                        Text(
                          'FROM',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        _StationSelectorDropdown(
                          stations: provider.stations,
                          selectedStation: provider.bookingState.source,
                          onStationSelected: (station) {
                            provider.setSourceStation(station);
                          },
                          placeholder: 'Select source station',
                        ),
                        const SizedBox(height: 16),

                        // Swap button
                        Center(
                          child: GestureDetector(
                            onTap: () => provider.swapStations(),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E88E5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.swap_vert,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Destination station selector
                        Text(
                          'TO',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        _StationSelectorDropdown(
                          stations: provider.stations,
                          selectedStation: provider.bookingState.destination,
                          onStationSelected: (station) {
                            provider.setDestinationStation(station);
                          },
                          placeholder: 'Select destination station',
                        ),
                        const SizedBox(height: 20),

                        // Ticket preferences
                        Row(
                          children: [
                            Expanded(
                              child: DropdownSelector(
                                label: 'CLASS',
                                value: provider.bookingState.ticketClass,
                                items: const [
                                  'First Class',
                                  'Second Class',
                                  'AC Class',
                                ],
                                onChanged: (value) {
                                  provider.setTicketClass(value);
                                },
                                icon: Icons.star_outline,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: DropdownSelector(
                                label: 'TYPE',
                                value: provider.bookingState.ticketType,
                                items: const ['Single', 'Return'],
                                onChanged: (value) {
                                  provider.setTicketType(value);
                                },
                                icon: Icons.repeat,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Book now button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: provider.bookingState.isValid
                                ? () {
                                    // Create ticket and navigate to QR screen
                                    final ticket = provider.service
                                        .createTicket(
                                          source: provider.bookingState.source!,
                                          destination: provider
                                              .bookingState
                                              .destination!,
                                          ticketType:
                                              provider.bookingState.ticketType,
                                          ticketClass:
                                              provider.bookingState.ticketClass,
                                          fare:
                                              provider
                                                  .bookingState
                                                  .calculatedFare ??
                                              0.0,
                                        );

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            QRTicketScreen(ticket: ticket),
                                      ),
                                    );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E88E5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              disabledBackgroundColor: Colors.grey[300],
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  'Book Now',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Popular routes section
                const Text(
                  'Popular Routes',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _PopularRoutesGrid(provider: provider),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Tickets screen - View all booked tickets
class _TicketsScreen extends StatelessWidget {
  const _TicketsScreen();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Tickets',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Consumer<TicketBookingProvider>(
              builder: (context, provider, _) {
                final tickets = provider.userTickets;

                if (tickets.isEmpty) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(48),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.confirmation_number,
                              size: 64,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No Tickets Yet',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Book your first ticket to get started',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: tickets.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final ticket = tickets[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF1E88E5), Color(0xFF1565C0)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${ticket.source.code} → ${ticket.destination.code}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${ticket.source.name} to ${ticket.destination.name}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white.withAlpha(200),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(200),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    ticket.ticketClass,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E88E5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '₹${ticket.fare.toInt()}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  ticket.bookingId,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white.withAlpha(150),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Station selector dropdown widget
class _StationSelectorDropdown extends StatefulWidget {
  final List<station_models.Station> stations;
  final station_models.Station? selectedStation;
  final Function(station_models.Station) onStationSelected;
  final String placeholder;

  const _StationSelectorDropdown({
    required this.stations,
    required this.selectedStation,
    required this.onStationSelected,
    required this.placeholder,
  });

  @override
  State<_StationSelectorDropdown> createState() =>
      _StationSelectorDropdownState();
}

class _StationSelectorDropdownState extends State<_StationSelectorDropdown> {
  late TextEditingController _searchController;
  late List<station_models.Station> _filteredStations;
  bool _showDropdown = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredStations = widget.stations;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterStations(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredStations = widget.stations;
      } else {
        _filteredStations = widget.stations
            .where(
              (station) =>
                  station.name.toLowerCase().contains(query.toLowerCase()) ||
                  station.code.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF1E88E5)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: _filterStations,
            onTap: () {
              setState(() => _showDropdown = true);
            },
            decoration: InputDecoration(
              hintText: widget.selectedStation?.name ?? widget.placeholder,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              prefixIcon: const Icon(
                Icons.location_on,
                color: Color(0xFF1E88E5),
                size: 20,
              ),
              suffixIcon: Icon(
                _showDropdown ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: const Color(0xFF1E88E5),
              ),
            ),
          ),
        ),
        if (_showDropdown)
          Container(
            margin: const EdgeInsets.only(top: 4),
            constraints: const BoxConstraints(maxHeight: 300),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF1E88E5)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredStations.length,
              itemBuilder: (context, index) {
                final station = _filteredStations[index];
                return ListTile(
                  title: Text(station.name),
                  subtitle: Text(station.code),
                  onTap: () {
                    widget.onStationSelected(station);
                    _searchController.clear();
                    setState(() => _showDropdown = false);
                  },
                  trailing: Text(
                    station.line,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF1E88E5),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

/// Popular routes grid widget
class _PopularRoutesGrid extends StatelessWidget {
  final TicketBookingProvider provider;

  const _PopularRoutesGrid({required this.provider});

  @override
  Widget build(BuildContext context) {
    final popularRoutes = [
      {'from': 'Churchgate', 'to': 'CSMT', 'code': 'CHG → CST'},
      {'from': 'Borivali', 'to': 'Kalyan', 'code': 'BOR → KYN'},
      {'from': 'Andheri', 'to': 'Ghatkopar', 'code': 'ADH → GTK'},
      {'from': 'Bandra', 'to': 'Thane', 'code': 'BND → THN'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: popularRoutes.length,
      itemBuilder: (context, index) {
        final route = popularRoutes[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              final sourceStation = provider.stations.firstWhere(
                (s) =>
                    s.name.toLowerCase().contains(route['from']!.toLowerCase()),
                orElse: () => provider.stations.first,
              );
              final destStation = provider.stations.firstWhere(
                (s) =>
                    s.name.toLowerCase().contains(route['to']!.toLowerCase()),
                orElse: () => provider.stations.last,
              );

              provider.setSourceStation(sourceStation);
              provider.setDestinationStation(destStation);
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    route['code']!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E88E5),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Icon(Icons.train, color: Color(0xFF1E88E5), size: 32),
                  const SizedBox(height: 8),
                  Flexible(
                    child: Text(
                      '${route['from']} → ${route['to']}',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
