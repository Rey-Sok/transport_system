import 'package:flutter/material.dart';
import 'package:transport_app/feature/booking/screens/booking.dart';

class TripListPage extends StatefulWidget {
  const TripListPage({super.key});

  @override
  State<TripListPage> createState() => _TripListPageState();
}

class _TripListPageState extends State<TripListPage> {
  int selectedFilterIndex = 0; // 0: All Trips, 1: VIP, 2: Normal

  // ទិន្នន័យគំរូតាមរូបភាព[cite: 1]
  final List<Map<String, dynamic>> trips = [
    {
      'type': 'VIP',
      'busName': 'Hyundai Sleeper',
      'badge': 'VIP',
      'priceUSD': 12.00,
      'priceKHR': '49,200 ៛',
      'rating': 4.8,
      'reviews': 510,
      'amenities': 'Wi-Fi ឥតគិតថ្លៃ • សាកថ្ម USB • បន្ទប់ទឹក',
      'departureTime': '11:00 PM',
      'duration': '6h 00m',
      'arrivalTime': '05:00 AM',
      'from': 'ភ្នំពេញ',
      'to': 'សៀមរាប',
      'stops': 'ឈប់សម្រាក ២ ដង',
      'status': '6/10 កៅអី',
      'isAvailable': true,
      'image': 'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?w=500&auto=format&fit=crop&q=60',
    },
    {
      'type': 'VIP',
      'busName': 'Hyundai Sleeper',
      'badge': 'VIP',
      'priceUSD': 12.00,
      'priceKHR': '49,200 ៛',
      'rating': 4.8,
      'reviews': 510,
      'amenities': 'Wi-Fi ឥតគិតថ្លៃ • សាកថ្ម USB • បន្ទប់ទឹក',
      'departureTime': '11:00 PM',
      'duration': '6h 00m',
      'arrivalTime': '05:00 AM',
      'from': 'ភ្នំពេញ',
      'to': 'សៀមរាប',
      'stops': 'ឈប់សម្រាក ២ ដង',
      'status': '6/10 កៅអី',
      'isAvailable': true,
      'image': 'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?w=500&auto=format&fit=crop&q=60',
    },
    {
      'type': 'Normal',
      'busName': 'Toyota HiAce',
      'badge': 'normal',
      'priceUSD': 11.00,
      'priceKHR': '45,100 ៛',
      'rating': 4.6,
      'reviews': 180,
      'amenities': 'Wi-Fi ឥតគិតថ្លៃ • សាកថ្ម USB',
      'departureTime': '09:00 AM',
      'duration': '5h 45m',
      'arrivalTime': '02:45 PM',
      'from': 'ភ្នំពេញ',
      'to': 'សៀមរាប',
      'stops': 'មិនឈប់សម្រាក',
      'status': 'ពេញ',
      'isAvailable': false,
      'image': 'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?w=500&auto=format&fit=crop&q=60',
    },
    {
      'type': 'Normal',
      'busName': 'Toyota HiAce',
      'badge': 'normal',
      'priceUSD': 11.00,
      'priceKHR': '45,100 ៛',
      'rating': 4.6,
      'reviews': 180,
      'amenities': 'Wi-Fi ឥតគិតថ្លៃ • សាកថ្ម USB',
      'departureTime': '09:00 AM',
      'duration': '5h 45m',
      'arrivalTime': '02:45 PM',
      'from': 'ភ្នំពេញ',
      'to': 'សៀមរាប',
      'stops': 'មិនឈប់សម្រាក',
      'status': 'ពេញ',
      'isAvailable': false,
      'image': 'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?w=500&auto=format&fit=crop&q=60',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // ត្រងទិន្នន័យតាម Tab ដែលបានជ្រើសរើស
    List<Map<String, dynamic>> filteredTrips = trips;
    if (selectedFilterIndex == 1) {
      filteredTrips = trips.where((t) => t['type'] == 'VIP').toList();
    } else if (selectedFilterIndex == 2) {
      filteredTrips = trips.where((t) => t['type'] == 'Normal').toList();
    }

    return Scaffold(
      body: Column(
        children: [
          // ផ្នែកខាងលើ (Custom App Bar with Dark Background)[cite: 1]
          Container(
            padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 20),
            decoration: const BoxDecoration(
              color: Color(0xFF0F172A), // ពណ៌ខៀវងងឹតខ្លាំង
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                      onPressed: () => Navigator.maybePop(context),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'ភ្នំពេញ → សៀមរាប',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 40),
                  child: Text(
                    '06-08-2026',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ),
                const SizedBox(height: 16),
                // Filter Chips (All Trips, VIP, Normal)[cite: 1]
                Row(
                  children: [
                    _buildFilterChip('All Trips', 0, isRed: true),
                    const SizedBox(width: 10),
                    _buildFilterChip('VIP', 1),
                    const SizedBox(width: 10),
                    _buildFilterChip('Normal', 2),
                  ],
                ),
              ],
            ),
          ),

          // ចំនួនជើងានាដែលមាន (14 trips available)[cite: 1]
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${filteredTrips.length} trips available',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // បញ្ជីកាតរថយន្ត (Trip Cards List)[cite: 1]
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredTrips.length,
              itemBuilder: (context, index) {
                final trip = filteredTrips[index];
                return _buildTripCard(trip);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget សម្រាប់ Filter Chip ខាងលើ
  Widget _buildFilterChip(String label, int index, {bool isRed = false}) {
    bool isSelected = selectedFilterIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilterIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isRed ? const Color(0xFFEF4444) : const Color(0xFFE2E8F0))
              : const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? (isRed ? Colors.white : Colors.black87)
                : Colors.white70,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  // Widget សម្រាប់កាតជើងានានីមួយៗ[cite: 1]
  Widget _buildTripCard(Map<String, dynamic> trip) {
    bool isAvailable = trip['isAvailable'];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ផ្នែកទី១៖ រូបភាព រថយន្ត តម្លៃ និង Rating[cite: 1]
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  trip['image'],
                  width: 55,
                  height: 55,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 55,
                      height: 55,
                      color: const Color(0xFFE2E8F0),
                      child: const Icon(
                        Icons.directions_bus,
                        color: Color(0xFF64748B),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            trip['busName'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: trip['badge'] == 'VIP'
                                ? const Color(0xFFDBEAFE)
                                : const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            trip['badge'],
                            style: TextStyle(
                              color: trip['badge'] == 'VIP'
                                  ? const Color(0xFF1D4ED8)
                                  : const Color(0xFF475569),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '${trip['rating']} (${trip['reviews']})',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        const Text(' • ', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Expanded(
                          child: Text(
                            trip['amenities'],
                            style: const TextStyle(color: Colors.grey, fontSize: 11),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // តម្លៃ[cite: 1]
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${trip['priceUSD'].toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Color(0xFFEA580C),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    trip['priceKHR'],
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: Color(0xFFF1F5F9)),
          ),

          // ផ្នែកទី២៖ ម៉ោងចេញដំណើរ រយៈពេល និងម៉ោងដល់[cite: 1]
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: LayoutBuilder(
              builder: (context, _) {
                return Row(
                  children: [
                    Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${trip['departureTime'].split(' ')[0]} ',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: trip['departureTime'].split(' ')[1],
                            style: const TextStyle(fontSize: 10, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(trip['from'], style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
                    const Spacer(),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Text(
                            trip['duration'],
                            style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle)),
                              Expanded(child: Container(height: 1, color: Colors.grey.shade400)),
                              const Icon(Icons.directions_bus, size: 14, color: Colors.grey),
                              Expanded(child: Container(height: 1, color: Colors.grey.shade400)),
                              Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            trip['stops'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 10, color: Color(0xFFD97706), fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${trip['arrivalTime'].split(' ')[0]} ',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: trip['arrivalTime'].split(' ')[1],
                            style: const TextStyle(fontSize: 10, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(trip['to'], style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // ផ្នែកទី៣៖ ស្ថានភាពកៅអី និងប៊ូតុងកក់[cite: 1]
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isAvailable ? Colors.orange : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    trip['status'],
                    style: TextStyle(
                      color: isAvailable ? Colors.orange[800] : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              isAvailable
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEA580C), // ពណ៌ទឹកក្រូចសម្រាប់កក់ឥឡូវ[cite: 1]
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SelectCarPage(),
                          ),
                        );
                      },
                      child: const Text('កក់ឥឡូវ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    )
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F172A), // ពណ៌ខៀវងងឹតពេលពេញ[cite: 1]
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                      ),
                      onPressed: null, // បិទការចុច
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text('ពេញ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward, size: 14),
                        ],
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}