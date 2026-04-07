import 'package:flutter/material.dart';
import 'route_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String sourceStation = 'Churchgate (WR)';
  String destinationStation = 'Borivali (WR)';
  String ticketClass = 'Second Class';
  String ticketType = 'Single';

  final List<String> stations = [
    // Western Line (Churchgate → Dahanu Road)
    'Churchgate (WR)',
    'Marine Lines (WR)',
    'Charni Road (WR)',
    'Grant Road (WR)',
    'Mumbai Central (WR)',
    'Mahalaxmi (WR)',
    'Lower Parel (WR)',
    'Prabhadevi (WR)',
    'Dadar (WR)',
    'Matunga Road (WR)',
    'Mahim (WR)',
    'Bandra (WR)',
    'Khar Road (WR)',
    'Santacruz (WR)',
    'Vile Parle (WR)',
    'Andheri (WR)',
    'Jogeshwari (WR)',
    'Ram Mandir (WR)',
    'Goregaon (WR)',
    'Malad (WR)',
    'Kandivali (WR)',
    'Borivali (WR)',
    'Dahisar (WR)',
    'Mira Road (WR)',
    'Bhayandar (WR)',
    'Naigaon (WR)',
    'Vasai Road (WR)',
    'Nalasopara (WR)',
    'Virar (WR)',
    'Vaitarna (WR)',
    'Saphale (WR)',
    'Kelve Road (WR)',
    'Palghar (WR)',
    'Umroli (WR)',
    'Boisar (WR)',
    'Vangaon (WR)',
    'Dahanu Road (WR)',

    // Central Line Main (CSMT → Kalyan)
    'CSMT (CR)',
    'Masjid (CR)',
    'Sandhurst Road (CR)',
    'Byculla (CR)',
    'Chinchpokli (CR)',
    'Currey Road (CR)',
    'Parel (CR)',
    'Dadar (CR)',
    'Matunga (CR)',
    'Sion (CR)',
    'Kurla (CR)',
    'Vidyavihar (CR)',
    'Ghatkopar (CR)',
    'Vikhroli (CR)',
    'Kanjurmarg (CR)',
    'Bhandup (CR)',
    'Nahur (CR)',
    'Mulund (CR)',
    'Thane (CR)',
    'Kalwa (CR)',
    'Mumbra (CR)',
    'Diva (CR)',
    'Kopar (CR)',
    'Dombivli (CR)',
    'Thakurli (CR)',
    'Kalyan (CR)',

    // Central Line Kasara Branch
    'Shahad (CR)',
    'Ambivli (CR)',
    'Titwala (CR)',
    'Khadavli (CR)',
    'Vasind (CR)',
    'Asangaon (CR)',
    'Kasara (CR)',

    // Central Line Karjat Branch
    'Vitthalwadi (CR)',
    'Ulhasnagar (CR)',
    'Ambernath (CR)',
    'Badlapur (CR)',
    'Vangani (CR)',
    'Shelu (CR)',
    'Neral (CR)',
    'Bhivpuri (CR)',
    'Karjat (CR)',

    // Harbour Line (CSMT → Panvel / Goregaon)
    'CSMT (HL)',
    'Masjid (HL)',
    'Sandhurst Road (HL)',
    'Dockyard Road (HL)',
    'Reay Road (HL)',
    'Cotton Green (HL)',
    'Sewri (HL)',
    'Wadala Road (HL)',
    'Guru Tegh Bahadur Nagar (HL)',
    'Chunabhatti (HL)',
    'Kurla (HL)',
    'Tilak Nagar (HL)',
    'Chembur (HL)',
    'Govandi (HL)',
    'Mankhurd (HL)',
    'Vashi (HL)',
    'Sanpada (HL)',
    'Juinagar (HL)',
    'Nerul (HL)',
    'Seawoods (HL)',
    'Belapur (HL)',
    'Kharghar (HL)',
    'Mansarovar (HL)',
    'Khandeshwar (HL)',
    'Panvel (HL)',

    // Harbour Line Goregaon Branch
    'Mahim (HL)',
    'Bandra (HL)',
    'Khar Road (HL)',
    'Santacruz (HL)',
    'Vile Parle (HL)',
    'Andheri (HL)',
    'Jogeshwari (HL)',
    'Goregaon (HL)',

    // Trans Harbour Line (Thane → Panvel / Vashi)
    'Thane (THL)',
    'Airoli (THL)',
    'Rabale (THL)',
    'Ghansoli (THL)',
    'Koparkhairane (THL)',
    'Turbhe (THL)',
    'Sanpada (THL)',
    'Vashi (THL)',
    'Juinagar (THL)',
    'Nerul (THL)',
    'Seawoods (THL)',
    'Belapur (THL)',
    'Kharghar (THL)',
    'Mansarovar (THL)',
    'Khandeshwar (THL)',
    'Panvel (THL)',
  ];

  void _swapStations() {
    setState(() {
      String temp = sourceStation;
      sourceStation = destinationStation;
      destinationStation = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      bottomNavigationBar: BottomNavigationBar(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.train, color: Color(0xFF1E88E5), size: 32),
                        SizedBox(width: 8),
                        Text(
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
                ),
                const SizedBox(height: 16),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _StepperItem(number: '1', label: 'Route', isActive: true),
                    _StepDivider(),
                    _StepperItem(number: '2', label: 'Select', isActive: false),
                    _StepDivider(),
                    _StepperItem(number: '3', label: 'Ticket', isActive: false),
                  ],
                ),
                const SizedBox(height: 24),
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
                        _StationSelector(
                          label: 'SOURCE STATION',
                          icon: Icons.location_on,
                          value: sourceStation,
                          onChanged: (val) =>
                              setState(() => sourceStation = val!),
                          items: stations,
                        ),
                        const SizedBox(height: 8),
                        Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            const Divider(),
                            GestureDetector(
                              onTap: _swapStations,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E88E5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.swap_vert,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _StationSelector(
                          label: 'DESTINATION STATION',
                          icon: Icons.my_location,
                          value: destinationStation,
                          onChanged: (val) =>
                              setState(() => destinationStation = val!),
                          items: stations,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _DropdownSelector(
                                label: 'CLASS',
                                icon: Icons.star_outline,
                                value: ticketClass,
                                items: const [
                                  'First Class',
                                  'Second Class',
                                  'AC Class',
                                ],
                                onChanged: (val) =>
                                    setState(() => ticketClass = val!),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _DropdownSelector(
                                label: 'TICKET TYPE',
                                icon: Icons.repeat,
                                value: ticketType,
                                items: const ['Single', 'Return'],
                                onChanged: (val) =>
                                    setState(() => ticketType = val!),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              if (sourceStation == destinationStation) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Source and Destination cannot be same',
                                    ),
                                  ),
                                );
                                return;
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RouteSelectionScreen(
                                    source: sourceStation,
                                    destination: destinationStation,
                                    ticketClass: ticketClass,
                                    ticketType: ticketType,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E88E5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  'Find Trains',
                                  style: TextStyle(
                                    fontSize: 18,
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
                const SizedBox(height: 24),
                const Text(
                  'Frequently Visited',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _RecentSearchCard(
                        from: 'CCG',
                        to: 'BVI',
                        route: 'Western Line',
                        onTap: () => setState(() {
                          sourceStation = 'Churchgate (WR)';
                          destinationStation = 'Borivali (WR)';
                        }),
                      ),
                      _RecentSearchCard(
                        from: 'CSMT',
                        to: 'THN',
                        route: 'Central Line',
                        onTap: () => setState(() {
                          sourceStation = 'CSMT (CR)';
                          destinationStation = 'Thane (CR)';
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StationSelector extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _StationSelector({
    required this.label,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
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
              value: value,
              isExpanded: true,
              icon: Icon(icon, color: const Color(0xFF1E88E5), size: 20),
              items: items.map((String val) {
                return DropdownMenuItem<String>(value: val, child: Text(val));
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class _DropdownSelector extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownSelector({
    required this.label,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F7FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: Icon(icon, color: const Color(0xFF1E88E5), size: 18),
              style: const TextStyle(fontSize: 13, color: Colors.black),
              items: items.map((String val) {
                return DropdownMenuItem<String>(value: val, child: Text(val));
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class _StepperItem extends StatelessWidget {
  final String number;
  final String label;
  final bool isActive;

  const _StepperItem({
    required this.number,
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF1E88E5) : Colors.grey[300],
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? const Color(0xFF1E88E5) : Colors.grey,
          ),
        ),
      ],
    );
  }
}

class _StepDivider extends StatelessWidget {
  const _StepDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 1,
      color: Colors.grey[300],
      margin: const EdgeInsets.only(bottom: 15),
    );
  }
}

class _RecentSearchCard extends StatelessWidget {
  final String from, to, route;
  final VoidCallback onTap;
  const _RecentSearchCard({
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
