import 'package:flutter/material.dart';
import 'ticket_detail.dart';

class TicketPage extends StatefulWidget {
  const TicketPage({super.key});

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  int _currentIndex = 1; // 1 គឺផ្ទាំង សំបុត្រ (Trips)

  // ទិន្នន័យគំរូប្រវត្តិសំបុត្រតាមរូបភាព[cite: 14]
  final List<Map<String, String>> tickets = [
    {
      'route': 'សៀមរាប ➔ ភ្នំពេញ',
      'bus': 'Hyundai Universe Sleeper',
      'date': 'Oct 12, 2026',
      'time': '08:30 AM',
      'seats': 'A1 - 4',
      'price': '\$24.00',
      'total': '\$24.90',
    },
    {
      'route': 'ភ្នំពេញ ➔ មណ្ឌលគិរី',
      'bus': 'Hyundai Universe Sleeper',
      'date': 'Oct 12, 2026',
      'time': '08:30 AM',
      'seats': 'A1 - L02',
      'price': '\$18.50',
      'total': '\$24.90',
    },
    {
      'route': 'ភ្នំពេញ ➔ សៀមរាប',
      'bus': 'Hyundai Universe Sks Sleeper',
      'date': 'Oct 12, 2026',
      'time': '08:30 AM',
      'seats': 'A1 - U2',
      'price': '\$12.80',
      'total': '\$19.90',
    },
    {
      'route': 'ភ្នំពេញ ➔ សៀមរាប',
      'bus': 'Hyundai Universe Sks Sleeper',
      'date': 'Oct 12, 2026',
      'time': '08:30 AM',
      'seats': 'A1 - U2',
      'price': '\$12.80',
      'total': '\$19.90',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // ពណ៌ខៀវងងឹតខាងលើ[cite: 14]
      body: SafeArea(
        child: Column(
          children: [
            // ផ្នែក Header ខាងលើ[cite: 14]
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'ប្រវត្តិសំបុត្រធ្វើដំណើរ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // បញ្ជីសំបុត្រ[cite: 14]
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: const BoxDecoration(color: Color(0xFF0F172A)),
                child: ListView.builder(
                  itemCount: tickets.length,
                  itemBuilder: (context, index) {
                    final ticket = tickets[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ticket['route'] ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    ticket['bus'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              // រូបតំណាងរថយន្ត
                              const Icon(
                                Icons.directions_bus,
                                color: Color(0xFF334155),
                                size: 28,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                size: 12,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${ticket['date']}  -  ',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                              const Icon(
                                Icons.access_time,
                                size: 12,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                ticket['time'] ?? '',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(children: [_buildBadge(ticket['seats'] ?? '')]),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Divider(height: 1, color: Color(0xFFF1F5F9)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Total: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    ticket['total'] ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Color(0xFFEA580C),
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const TicketDetailPage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'មើលព័ត៌មានលម្អិត',
                                  style: TextStyle(
                                    color: Color(0xFFEA580C),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar ដូចក្នុងរូបភាព[cite: 14]
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_outlined, 'ទំព័រដើម', 0),
            _buildNavItem(Icons.calendar_month, 'សំបុត្រ', 1),
            _buildNavItem(Icons.person_outline, 'គណនី', 2),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Color(0xFF475569),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFFEA580C) : Colors.grey,
            size: 22,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isSelected ? const Color(0xFFEA580C) : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
