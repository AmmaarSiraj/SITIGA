import 'package:flutter/material.dart';

/// Widget untuk filter berdasarkan tahun dan pemilihan halaman
class PublikasiPencarianFilter extends StatelessWidget {
  final String selectedFilter;
  final int currentPage;
  final int totalPages;
  final ValueChanged<String> onFilterChanged;
  final ValueChanged<int> onPageChanged;

  const PublikasiPencarianFilter({
    Key? key,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
  height: 50,
  child: Row(
    children: [
      // Tombol Filter
      ElevatedButton(
        onPressed: () => _showFilterDialog(context),
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
      // Dropdown halaman
      SizedBox(
        width: 60,
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
            if (value != null) onPageChanged(value);
          },
          items: List.generate(
            totalPages,
            (index) => DropdownMenuItem(
              value: index + 1,
              child: Center(child: Text("${index + 1}")),
            ),
          ),
          menuMaxHeight: 200,
        ),
      ),
    ],
  ),
);

  }

  void _showFilterDialog(BuildContext context) {
    final List<String> filters = ['(Semua)', '2025', '2024', '2023', '2022', '2021', '<2020'];
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Pilih Tahun'),
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
      ),
    );
  }
}