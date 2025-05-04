import 'package:flutter/material.dart';
import 'package:cobabps/HomeScreen/home_screen.dart';
import 'package:cobabps/news/news_list_screen.dart';
import 'package:cobabps/publikasi/publikasi_screen.dart';
import 'package:cobabps/tabel/tabel.dart';
import 'package:cobabps/infographic/infographic_list_screen.dart';
import 'components/bottom_navigation_bar.dart';
import 'package:provider/provider.dart'; // <== Tambah ini
import '../providers/data_provider.dart'; // <== Pastikan import ini
import '../Search/search_page.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;

  const MainScreen({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _selectedIndex;

  Offset _fabPosition = Offset(300, 500); // Posisi awal tombol search

  final List<Widget> _screens = [
    HomeScreen(),
    InfographicListScreen(),
    StatisticTableScreen(),
    PublicationListScreen(),
    NewsListScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    Future.microtask(() {
      final dataProvider = Provider.of<DataProvider>(context, listen: false);
      dataProvider.loadAllData();
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: _screens,
          ),
          Positioned(
            left: _fabPosition.dx,
            top: _fabPosition.dy,
            child: Draggable(
              feedback: _buildFab(),
              childWhenDragging: Container(), // kosong pas dragging
              onDragEnd: (details) {
                setState(() {
                  double newX = details.offset.dx;
                  double newY = details.offset.dy;

                  // Batas kiri
                  if (newX < 0) newX = 0;
                  // Batas kanan
                  if (newX > screenSize.width - 56) newX = screenSize.width - 56; // 56 = diameter FloatingActionButton
                  // Batas atas
                  if (newY < 0) newY = 0;
                  // Batas bawah
                  if (newY > screenSize.height - 56 - 80) newY = screenSize.height - 56 - 80; // 80 kira-kira untuk padding + bottomNavigationBar

                  _fabPosition = Offset(newX, newY);
                });
              },
              child: _buildFab(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
      ),
    );
  }

  Widget _buildFab() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchPage()),
        );
      },
      backgroundColor: Color.fromARGB(255, 101, 149, 153),
      child: const Icon(Icons.search),
    );
  }
}
