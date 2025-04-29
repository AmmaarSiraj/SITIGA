import 'package:flutter/material.dart';

class NextPage extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;
  final ScrollController scrollController;

  const NextPage({
    Key? key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    required this.scrollController,
  }) : super(key: key);

  void _changePage(int page) {
    onPageChanged(page);
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Prev Page di kiri (tetap kosong kalau halaman 1)
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: currentPage > 1
                  ? ElevatedButton(
                      onPressed: () => _changePage(currentPage - 1),
                      child: const Text('Prev Page'),
                    )
                  : const SizedBox(), // Tetap jaga posisi kosong
            ),
          ),
          // Nomor halaman di tengah
          Expanded(
            child: Center(
              child: Text(
                '$currentPage',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // Next Page di kanan (tetap kosong kalau halaman terakhir)
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: currentPage < totalPages
                  ? ElevatedButton(
                      onPressed: () => _changePage(currentPage + 1),
                      child: const Text('Next Page'),
                    )
                  : const SizedBox(), // Tetap jaga posisi kosong
            ),
          ),
        ],
      ),
    );
  }
}