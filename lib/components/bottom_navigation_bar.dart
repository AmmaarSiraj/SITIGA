import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.home, "Home", 0),
          _buildNavItem(Icons.bar_chart, "Infografis", 1),
          _buildNavItem(Icons.table_chart, "Tabel", 2),
          _buildNavItem(Icons.article, "Publikasi", 3),
          _buildNavItem(Icons.newspaper, "News", 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            icon,
            color: currentIndex == index ? Color(0xFF128C7E) : Colors.blueGrey,
          ),
          onPressed: () {
            if (currentIndex != index) {
              onTap(index);
            }
          },
        ),
        Text(
          label,
          style: TextStyle(
            color: currentIndex == index ? Color(0xFF128C7E): Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}