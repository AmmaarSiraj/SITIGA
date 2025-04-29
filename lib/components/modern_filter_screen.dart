import 'package:flutter/material.dart';

class ModernFilterScreen extends StatefulWidget {
  final Function(String, String) onFilterChanged; // Callback untuk filter

  ModernFilterScreen({required this.onFilterChanged}); // Tambahkan parameter wajib

  @override
  _ModernFilterScreenState createState() => _ModernFilterScreenState();
}

class _ModernFilterScreenState extends State<ModernFilterScreen> {
  String searchQuery = "";
  String selectedCategory = "Semua";

  List<String> categoryOptions = [
    "Semua",
    "Populasi & Demografi",
    "Ekonomi & Keuangan",
    "Pendidikan & Kesehatan",
    "Lingkungan & Sumber Daya Alam",
    "Transportasi & Infrastruktur",
    "Industri & Perdagangan"
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
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
      "Tabel Data Statistik",
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
        ),
      
        // --- SEARCH BAR ---
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Cari Tabel...",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value.toLowerCase();
              });
              widget.onFilterChanged(searchQuery, selectedCategory); // Callback perubahan filter
            },
          ),
        ),

        // --- CATEGORY FILTER ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(
              spacing: 8,
              children: categoryOptions.map((category) {
                bool isSelected = selectedCategory == category;
                return ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  selectedColor: Colors.indigo.shade100,
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.indigo : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.indigo),
                  ),
                  onSelected: (selected) {
                    setState(() {
                      selectedCategory = category;
                    });
                    widget.onFilterChanged(searchQuery, selectedCategory); // Callback perubahan filter
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
