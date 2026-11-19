import 'package:flutter/material.dart';
import 'package:transport_app/feature/payment/screens/payment.dart';

class SelectCarPage extends StatefulWidget {
  const SelectCarPage({super.key});

  @override
  State<SelectCarPage> createState() => _SelectCarPageState();
}

class _SelectCarPageState extends State<SelectCarPage> {
  // រក្សាទុកលេខកៅអីដែលបានជ្រើសរើស (ឧទាហរណ៍៖ លេខ 10 ដូចក្នុងរូបភាព)
  int? selectedSeat = 10;

  // បញ្ជីកៅអីដែលមិនទំនេរ (ពណ៌ក្រហម) តាមរូបភាព[cite: 7, 8]
  final Map<int, String> bookedSeats = {
    3: '3(M)',
    5: '5(M)',
    6: '6(M)',
    7: '7(F)',
    8: '8(M)',
    12: '12(M)',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // ១. ផ្នែក Header ពណ៌ខៀវងងឹតខាងលើ[cite: 7, 8]
          Container(
            padding: const EdgeInsets.only(
              top: 50,
              left: 16,
              right: 16,
              bottom: 20,
            ),
            color: const Color(0xFF0F172A),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => Navigator.maybePop(context),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'ភ្នំពេញ → សៀមរាប',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '06-08-2026',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ២. កាតព័ត៌មានរថយន្ត (Hyundai Universe VIP)[cite: 7, 8]
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?w=400&auto=format&fit=crop&q=60',
                                width: 68,
                                height: 68,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 4,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.75),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 10,
                                    ),
                                    SizedBox(width: 2),
                                    Text(
                                      '4.8',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Hyundai Universe VIP',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: const [
                                  Icon(
                                    Icons.access_time,
                                    size: 13,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    '11:00 PM • 6h 00m',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 6,
                                runSpacing: 4,
                                children: [
                                  _buildAmenityBadge(
                                    Icons.wifi,
                                    'Wi-Fi ឥតគិតថ្លៃ',
                                    Colors.grey.shade100,
                                    Colors.grey.shade700,
                                  ),
                                  _buildAmenityBadge(
                                    Icons.usb,
                                    'សាកថ្ម USB',
                                    Colors.grey.shade100,
                                    Colors.grey.shade700,
                                  ),
                                  _buildAmenityBadge(
                                    Icons.wc,
                                    'បន្ទប់ទឹក',
                                    const Color(0xFFFFF7ED),
                                    const Color(0xFFEA580C),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Text(
                              '\$12.00',
                              style: TextStyle(
                                color: Color(0xFFEA580C),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              '49,200 ៛',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ៣. ចំណងជើង និង ការពន្យល់ពណ៌កៅអី (Legend)[cite: 7, 8]
                  const Text(
                    'ជ្រើសរើសកៅអី',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLegendItem(Colors.white, 'ទំនេរ', hasBorder: true),
                      _buildLegendItem(const Color(0xFF1E2978), 'បានជ្រើសរើស'),
                      _buildLegendItem(const Color(0xFFEF2323), 'មិនទំនេរ'),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // ៤. ប្លង់កៅអីក្នុងរថយន្ត (Seat Layout Grid)[cite: 7, 8]
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        // ជួរទី ១៖ ចង្កូតឡាន + កៅអី ១ និង ២[cite: 7, 8]
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(
                              width: 56,
                              height: 56,
                              child: Center(
                                child: Icon(
                                  Icons.donut_small_outlined,
                                  size: 36,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                            ),
                            const SizedBox(width: 56),
                            _buildSeatWidget(1),
                            _buildSeatWidget(2),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // ជួរទី ២៖ កៅអី 3, 4, 5[cite: 7, 8]
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildSeatWidget(3),
                            _buildSeatWidget(4),
                            _buildSeatWidget(5),
                            const SizedBox(width: 56),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // ជួរទី ៣៖ កៅអី 6, 7, 8[cite: 7, 8]
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildSeatWidget(6),
                            _buildSeatWidget(7),
                            const SizedBox(width: 56),
                            _buildSeatWidget(8),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // ជួរទី ៤៖ កៅអី 9, 10, 11, 12[cite: 7, 8]
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildSeatWidget(9),
                            _buildSeatWidget(10),
                            _buildSeatWidget(11),
                            _buildSeatWidget(12),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ៥. ប៊ូតុង "បន្ត" នៅខាងក្រោម (បង្ហាញនៅពេលមានការជ្រើសរើសកៅអី)[cite: 8]
          if (selectedSeat != null)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEA580C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    if (selectedSeat == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('សូមជ្រើសរើសកៅអី')),
                      );
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaymentPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'បន្ត',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAmenityBadge(IconData icon, String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: fg),
          const SizedBox(width: 3),
          Text(text, style: TextStyle(fontSize: 10, color: fg)),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label, {bool hasBorder = false}) {
    return Row(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
            border: hasBorder ? Border.all(color: Colors.grey.shade300) : null,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
        ),
      ],
    );
  }

  Widget _buildSeatWidget(int seatId) {
    final bool isBooked = bookedSeats.containsKey(seatId);
    final bool isSelected = selectedSeat == seatId;
    final String label = isBooked ? bookedSeats[seatId]! : seatId.toString();

    Color seatColor = Colors.white;
    Color borderColor = Colors.grey.shade300;
    if (isBooked) {
      seatColor = const Color(0xFFEF2323); // ពណ៌ក្រហម (មិនទំនេរ)[cite: 7, 8]
      borderColor = const Color(0xFFDC2626);
    } else if (isSelected) {
      seatColor = const Color(0xFF1E2978); // ពណ៌ខៀវចាស់ (បានជ្រើសរើស)[cite: 8]
      borderColor = const Color(0xFF1E2978);
    }

    return GestureDetector(
      onTap: isBooked
          ? null
          : () {
              setState(() {
                selectedSeat = (selectedSeat == seatId) ? null : seatId;
              });
            },
      child: SizedBox(
        width: 56,
        child: Column(
          children: [
            SizedBox(
              width: 44,
              height: 44,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 34,
                    height: 38,
                    decoration: BoxDecoration(
                      color: seatColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: borderColor, width: 1.5),
                    ),
                  ),
                  Positioned(
                    left: 2,
                    bottom: 4,
                    child: Container(
                      width: 5,
                      height: 22,
                      decoration: BoxDecoration(
                        color: seatColor,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: borderColor, width: 1.2),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 2,
                    bottom: 4,
                    child: Container(
                      width: 5,
                      height: 22,
                      decoration: BoxDecoration(
                        color: seatColor,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: borderColor, width: 1.2),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 2,
                    child: Container(
                      width: 30,
                      height: 8,
                      decoration: BoxDecoration(
                        color: seatColor,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: borderColor, width: 1.2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? const Color(0xFF1E2978)
                    : const Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
