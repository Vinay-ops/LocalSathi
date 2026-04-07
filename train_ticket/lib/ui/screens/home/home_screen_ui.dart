import 'package:flutter/material.dart';

/// Home Screen UI
/// All UI components and layout - no business logic
class HomeScreenUI extends StatelessWidget {
  final String sourceStation;
  final String destinationStation;
  final String ticketClass;
  final String ticketType;
  final int ticketQuantity;
  final List<String> stations;
  final VoidCallback onSwapStations;
  final ValueChanged<String?> onSourceChanged;
  final ValueChanged<String?> onDestinationChanged;
  final ValueChanged<String?> onClassChanged;
  final ValueChanged<String?> onTypeChanged;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onFindTrains;
  final Function(String, String) onRecentSearchTap;
  final int currentBottomNavIndex;
  final ValueChanged<int> onBottomNavChanged;

  const HomeScreenUI({
    super.key,
    required this.sourceStation,
    required this.destinationStation,
    required this.ticketClass,
    required this.ticketType,
    required this.ticketQuantity,
    required this.stations,
    required this.onSwapStations,
    required this.onSourceChanged,
    required this.onDestinationChanged,
    required this.onClassChanged,
    required this.onTypeChanged,
    required this.onQuantityChanged,
    required this.onFindTrains,
    required this.onRecentSearchTap,
    required this.currentBottomNavIndex,
    required this.onBottomNavChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentBottomNavIndex,
        onTap: onBottomNavChanged,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.train), label: 'Local'),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Quick QR',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        selectedItemColor: const Color(0xFF1E88E5),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildSearchCard(),
                const SizedBox(height: 24),
                _buildFrequentlyVisited(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset('assets/logos/LogoTrain.png', width: 40, height: 40),
            const SizedBox(width: 8),
            const Text(
              'MumbaiLocal',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E),
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none),
        ),
      ],
    );
  }

  Widget _buildSearchCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchableStationSelector(
              label: 'SOURCE STATION',
              icon: Icons.location_on,
              value: sourceStation,
              onChanged: onSourceChanged,
              items: stations,
            ),
            const SizedBox(height: 8),
            Stack(
              alignment: Alignment.centerRight,
              children: [
                const Divider(),
                GestureDetector(
                  onTap: onSwapStations,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E88E5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.swap_vert, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SearchableStationSelector(
              label: 'DESTINATION STATION',
              icon: Icons.my_location,
              value: destinationStation,
              onChanged: onDestinationChanged,
              items: stations,
            ),
            const SizedBox(height: 20),
            // Class and Type selection row
            Row(
              children: [
                Expanded(child: _buildClassSelector()),
                const SizedBox(width: 12),
                Expanded(child: _buildTypeSelector()),
              ],
            ),
            const SizedBox(height: 20),
            // Ticket quantity selector
            _buildQuantitySelector(),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: onFindTrains,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E88E5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_forward, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Select Route',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CLASS',
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F7FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: ticketClass,
              isExpanded: true,
              icon: const Icon(
                Icons.star_outline,
                color: Color(0xFF1E88E5),
                size: 18,
              ),
              items: const ['Second Class', 'First Class', 'AC Local']
                  .map(
                    (val) => DropdownMenuItem<String>(
                      value: val,
                      child: Text(val, style: const TextStyle(fontSize: 13)),
                    ),
                  )
                  .toList(),
              onChanged: onClassChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'TYPE',
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F7FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: ticketType,
              isExpanded: true,
              icon: const Icon(
                Icons.repeat,
                color: Color(0xFF1E88E5),
                size: 18,
              ),
              items: const ['Single', 'Return']
                  .map(
                    (val) => DropdownMenuItem<String>(
                      value: val,
                      child: Text(val, style: const TextStyle(fontSize: 13)),
                    ),
                  )
                  .toList(),
              onChanged: onTypeChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuantitySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(
              Icons.confirmation_number_outlined,
              color: Color(0xFF1E88E5),
              size: 18,
            ),
            SizedBox(width: 8),
            Text(
              'NUMBER OF TICKETS',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F7FA),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...List.generate(4, (index) {
                final quantity = index + 1;
                return GestureDetector(
                  onTap: () => onQuantityChanged(quantity),
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: ticketQuantity == quantity
                          ? const Color(0xFF1E88E5)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: ticketQuantity == quantity
                            ? const Color(0xFF1E88E5)
                            : Colors.grey[300]!,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '$quantity',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ticketQuantity == quantity
                              ? Colors.white
                              : const Color(0xFF1E88E5),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFrequentlyVisited() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Frequently Visited',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              RecentSearchCard(
                from: 'CCG',
                to: 'BVI',
                route: 'Western Line',
                onTap: () =>
                    onRecentSearchTap('Churchgate (WR)', 'Borivali (WR)'),
              ),
              RecentSearchCard(
                from: 'CSMT',
                to: 'THN',
                route: 'Central Line',
                onTap: () => onRecentSearchTap('CSMT (CR)', 'Thane (CR)'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Searchable Station Selector
class SearchableStationSelector extends StatefulWidget {
  final String label;
  final IconData icon;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const SearchableStationSelector({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  State<SearchableStationSelector> createState() =>
      _SearchableStationSelectorState();
}

class _SearchableStationSelectorState extends State<SearchableStationSelector> {
  late List<String> filteredItems;
  late TextEditingController searchController;
  bool showDropdown = false;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController(text: widget.value);
    filteredItems = widget.items;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredItems = widget.items;
      } else {
        filteredItems = widget.items
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F7FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: searchController,
            onChanged: (value) {
              _filterItems(value);
              setState(() => showDropdown = true);
            },
            onTap: () => setState(() => showDropdown = true),
            decoration: InputDecoration(
              hintText: 'Search stations...',
              border: InputBorder.none,
              prefixIcon: Icon(widget.icon, color: const Color(0xFF1E88E5)),
              suffixIcon: searchController.text.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        searchController.clear();
                        _filterItems('');
                      },
                      child: const Icon(Icons.clear),
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
        ),
        if (showDropdown && filteredItems.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      searchController.text = filteredItems[index];
                      widget.onChanged(filteredItems[index]);
                      setState(() => showDropdown = false);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: index < filteredItems.length - 1
                            ? Border(
                                bottom: BorderSide(
                                  color: Colors.grey[200]!,
                                  width: 1,
                                ),
                              )
                            : null,
                      ),
                      child: Text(
                        filteredItems[index],
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}

class RecentSearchCard extends StatelessWidget {
  final String from, to, route;
  final VoidCallback onTap;

  const RecentSearchCard({
    super.key,
    required this.from,
    required this.to,
    required this.route,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(right: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 180,
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    from,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E88E5),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 14),
                  const SizedBox(width: 8),
                  Text(
                    to,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E88E5),
                    ),
                  ),
                ],
              ),
              Text(
                '$from to $to',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                route,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
