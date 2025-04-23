import 'package:flutter/material.dart';

class FiturTabel extends StatefulWidget {
  final Function(String, String) onFilterChanged;

  FiturTabel({required this.onFilterChanged});

  @override
  _FiturTabelState createState() => _FiturTabelState();
}

class _FiturTabelState extends State<FiturTabel> {
  String searchQuery = "";
  String selectedCategory = "Semua";

  Map<String, List<String>> categoryFilterMapping = {
    "Populasi & Demografi": ["Statistik Demografi dan Sosial"],
    "Ekonomi & Keuangan": ["Statistik Ekonomi"],
    "Pendidikan & Kesehatan": ["Statistik Demografi dan Sosial"],
    "Lingkungan & Sumber Daya Alam": ["Statistik Lingkungan Hidup dan Multi-domain"],
    "Transportasi & Infrastruktur": ["Statistik Lingkungan Hidup dan Multi-domain"],
    "Industri & Perdagangan": ["Statistik Ekonomi"],
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: "Cari...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value.toLowerCase();
              });
              widget.onFilterChanged(searchQuery, selectedCategory);
            },
          ),
          SizedBox(height: 10),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: "Kategori",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            value: selectedCategory,
            items: ["Semua", ...categoryFilterMapping.keys]
                .map((category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedCategory = value ?? "Semua";
              });
              widget.onFilterChanged(searchQuery, selectedCategory);
            },
          ),
        ],
      ),
    );
  }
}
