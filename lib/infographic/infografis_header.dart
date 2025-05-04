import 'package:flutter/material.dart';

class InfografisHeader extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  const InfografisHeader({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(width: 5, height: 40, color: Colors.blue),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Infografis",
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
          if (totalPages > 1)
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
