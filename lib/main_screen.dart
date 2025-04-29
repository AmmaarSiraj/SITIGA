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
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
        floatingActionButton: Padding(
  padding: const EdgeInsets.only(bottom: 70.0), // naikkan 50 pixel dari bawah
  child: FloatingActionButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SearchPage()),
      );
    },
    backgroundColor: Color.fromARGB(255, 101, 149, 153),
    child: const Icon(Icons.search),
  ),
),
floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
