import 'package:flutter/material.dart';

class TombolSebelumSesudah extends StatelessWidget {
  final int currentPage;
  final int maxPage;
  final ValueChanged<int> onPageChanged;

  const TombolSebelumSesudah({
    Key? key,
    required this.currentPage,
    required this.maxPage,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: currentPage > 1
                ? () => onPageChanged(currentPage - 1)
                : null,
            child: const Text("Previous"),
          ),
          Text("Page $currentPage dari $maxPage"),
          TextButton(
            onPressed: currentPage < maxPage
                ? () => onPageChanged(currentPage + 1)
                : null,
            child: const Text("Next"),
          ),
        ],
      ),
    );
  }
}
