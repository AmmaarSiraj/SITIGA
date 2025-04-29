import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _searchByTitle = true;

  String selectedYear = 'Semua Tahun';
  String selectedSort = 'Relevansi';
  String selectedContentType = 'Semua Konten';

  final List<String> years = ['Semua Tahun', '2025', '2024', '2023'];
  final List<String> sortOptions = ['Relevansi', 'Terbaru', 'Terlama'];
  final List<String> contentTypes = ['Semua Konten', 'Tabel', 'Publikasi', 'Infografis', 'Berita'];

  void _openFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Filter Pencarian', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: selectedYear,
                      decoration: const InputDecoration(labelText: 'Tahun Rilis'),
                      items: years.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => selectedYear = value!),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Cari berdasarkan Judul"),
                        Switch(
                          value: _searchByTitle,
                          onChanged: (value) => setState(() => _searchByTitle = value),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedSort,
                      decoration: const InputDecoration(labelText: 'Urut Berdasarkan'),
                      items: sortOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => selectedSort = value!),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedContentType,
                      decoration: const InputDecoration(labelText: 'Jenis Konten'),
                      items: contentTypes.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => selectedContentType = value!),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 101, 149, 153)),
                        onPressed: () {
                          Navigator.pop(context);
                          // Terapkan filter di sini
                        },
                        child: const Text('Terapkan'),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pencarian'),
        backgroundColor: Color.fromARGB(255, 101, 149, 153),
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 18),
                const SizedBox(width: 4),
                const Text('BPS Kota Salatiga'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Masukkan kata kunci',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _openFilterModal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 101, 149, 153),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  child: const Icon(Icons.tune),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
