import 'package:flutter/material.dart';

class PublikasiPencarianFilter extends StatelessWidget {
  final String searchQuery;
  final String selectedFilter;
  final int currentPage;
  final int totalPages;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onFilterChanged;
  final ValueChanged<int> onPageChanged;

  const PublikasiPencarianFilter({
    Key? key,
    required this.searchQuery,
    required this.selectedFilter,
    required this.onSearchChanged,
    required this.onFilterChanged,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFF6F6),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 50,
              child: TextField(
                onChanged: onSearchChanged,
                decoration: InputDecoration(
                  hintText: "Cari Publikasi di sini",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Tombol filter hanya icon
          ElevatedButton(
            onPressed: () {
              _showFilterDialog(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              minimumSize: const Size(50, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.zero,
            ),
            child: const Icon(Icons.filter_list),
          ),
          const SizedBox(width: 10),
          // Dropdown untuk lompat halaman
          
            SizedBox(
  width: 60, // <<< Lebar kecil, kayak angka 2 digit
  height: 50, // <<< Tinggi sama kayak tombol search
  child: DropdownButtonFormField<int>(
    value: currentPage,
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      filled: true,
      fillColor: Colors.white,
    ),
    onChanged: totalPages == 1 ? null : (value) {
      if (value != null) {
        onPageChanged(value);
      }
    },
    items: List.generate(
      totalPages,
      (index) => DropdownMenuItem(
        value: index + 1,
        child: Text(
          "${index + 1}",
          style: const TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    ),
    menuMaxHeight: 200, // <<< Ini supaya dropdown tidak terlalu panjang, scroll kalau banyak item
  ),
),

        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final List<String> filters = ['Semua', 'Sosial', 'Ekonomi', 'Pertanian'];
        return AlertDialog(
          title: const Text("Pilih Kategori"),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filters.length,
              itemBuilder: (context, index) {
                return RadioListTile<String>(
                  title: Text(filters[index]),
                  value: filters[index],
                  groupValue: selectedFilter,
                  onChanged: (value) {
                    if (value != null) {
                      onFilterChanged(value);
                      Navigator.of(context).pop();
                    }
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
