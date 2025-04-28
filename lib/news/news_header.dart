import 'package:flutter/material.dart';

class NewsHeader extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  const NewsHeader({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFF6F6),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Supaya header & dropdown berjauhan
        children: [
          Row(
            children: [
              Container(width: 5, height: 40, color: Colors.blue),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Berita",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "📍 BPS Kota Salatiga",
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
            ],
          ),
          if (totalPages > 1) // Tampilkan dropdown kalau totalPages lebih dari 1
            Row(
              children: [
              
                const SizedBox(width: 8),
                DropdownButton<int>(
                  value: currentPage,
                  onChanged: (value) {
                    if (value != null) {
                      onPageChanged(value);
                    }
                  },
                  items: List.generate(
                    totalPages,
                    (index) => DropdownMenuItem(
                      value: index + 1,
                      child: Text("Halaman ${index + 1}"),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
