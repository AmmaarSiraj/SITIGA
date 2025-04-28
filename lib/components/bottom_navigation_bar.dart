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
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 65,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background Bar
          Positioned.fill(
            bottom: 0,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Color.fromARGB(20, 218, 217, 217),
              ),
            ),
          ),

          // Semua tombol dengan posisi manual
          _buildNavItem(Icons.table_view_sharp, "Tabel", 2, screenWidth * 0.1),
          _buildNavItem(Icons.bar_chart, "Infografis", 1, screenWidth * 0.28),
          _buildNavItem(Icons.home, "Beranda", 0, screenWidth * 0.5,
              isCenter: true),
          _buildNavItem(Icons.article, "Publikasi", 3, screenWidth * 0.72),
          _buildNavItem(Icons.newspaper, "Berita", 4, screenWidth * 0.9),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, double left,
      {bool isCenter = false}) {
    final bool isActive = currentIndex == index;

    return AnimatedPositioned(
      duration: Duration(milliseconds: 300),
      bottom: isActive ? 20 : 10,
      left: left - 30, // center align each 60px button
      child: GestureDetector(
        onTap: () => onTap(index),
        child: SizedBox(
          width: 60,
          child: Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isActive
                      ? Color.fromARGB(255, 101, 149, 153)
                      : const Color.fromARGB(0, 255, 255, 255),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: isActive ? Colors.white : Color.fromARGB(255, 45, 67, 69),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: isActive
                      ? Color.fromARGB(255, 45, 67, 69)
                      : const Color.fromARGB(255, 40, 40, 40),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
