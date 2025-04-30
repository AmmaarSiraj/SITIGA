import 'package:flutter/material.dart';

class PublikasiHeader extends StatelessWidget {
  const PublikasiHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 255, 255, 255),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: [
          Container(width: 5, height: 40, color: Colors.blue),
          const SizedBox(width: 10),
         Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    const Text(
      "Publikasi",
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 4), // Jarak antara "Publikasi" dan lokasi
    Row(
      children: [
        Icon(Icons.location_on, size: 18, color: Colors.grey[700]),
        const SizedBox(width: 4),
        const Text(
          "BPS Kota Salatiga",
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    ),
  ],
)
        ],
      ),
    );
  }
}
