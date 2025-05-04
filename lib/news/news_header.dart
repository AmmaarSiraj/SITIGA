import 'package:flutter/material.dart';

class NewsHeader extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 255, 255, 255),
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
    const SizedBox(height: 4), // Jarak antara "Berita" dan lokasi
    Row(
      mainAxisSize: MainAxisSize.min,
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
          
        ],
      ),
    );
  }
}
