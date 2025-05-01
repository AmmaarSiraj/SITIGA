import 'package:flutter/material.dart';
import 'lainnya_nav.dart'; // Import untuk menu lainnya

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
          // Background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(20, 218, 217, 217),
              ),
            ),
          ),
          _buildNavItem(context, Icons.table_view_sharp, "Tabel", 2, screenWidth * 0.1),
          _buildNavItem(context, Icons.image, "Infografis", 1, screenWidth * 0.28),
          _buildNavItem(context, Icons.home, "Beranda", 0, screenWidth * 0.5, isCenter: true),
          _buildNavItem(context, Icons.article, "Publikasi", 3, screenWidth * 0.72),
          _buildNavItem(context, Icons.menu, "Lainnya", 5, screenWidth * 0.9, isMoreMenu: true),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String label,
    int index,
    double left, {
    bool isCenter = false,
    bool isMoreMenu = false,
  }) {
    final bool isActive = currentIndex == index;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      bottom: isActive ? 20 : 10, // Efek pop up
      left: left - 30, // Pusatkan tiap item (lebar item 60)
      child: GestureDetector(
        onTap: () {
          if (isMoreMenu) {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) => MoreMenu(
                currentIndex: currentIndex,
                onTap: onTap,
              ),
            );
          } else {
            onTap(index);
          }
        },
        child: SizedBox(
          width: 60,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color.fromARGB(255, 101, 149, 153)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: isActive
                      ? Colors.white
                      : const Color.fromARGB(255, 45, 67, 69),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: isActive
                      ? const Color.fromARGB(255, 45, 67, 69)
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
