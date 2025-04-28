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

  void _changePage(BuildContext context, int page) {
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: currentPage > 1
                ? () => _changePage(context, currentPage - 1)
                : null,
          ),
          const SizedBox(width: 8),
          Text("Halaman $currentPage dari $totalPages"),
          const SizedBox(width: 8),
          DropdownButton<int>(
            value: currentPage,
            onChanged: (value) {
              if (value != null) {
                _changePage(context, value);
              }
            },
            items: List.generate(
              totalPages,
              (index) => DropdownMenuItem(
                value: index + 1,
                child: Text("Ke ${index + 1}"),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: currentPage < totalPages
                ? () => _changePage(context, currentPage + 1)
                : null,
          ),
        ],
      ),
    );
  }
}
