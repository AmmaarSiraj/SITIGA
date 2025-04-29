import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/appbar.dart';
import '../HomeScreen/carousel_section.dart';
import '../HomeScreen/statistic_section.dart';
import '../HomeScreen/part_infografis.dart';
import '../HomeScreen/part_news.dart';
import '../HomeScreen/part_publikasi.dart';
import '../HomeScreen/part_tabel.dart';
import '../providers/data_provider.dart'; // Import provider!
import '../Search/search_page.dart'; // Tambahkan ini

class HomeScreen extends StatelessWidget {
  final List<String> carouselImages = [
    'assets/images/grup1.png',
    'assets/images/grup4.png',
    'assets/images/grup3.png',
  ];

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);

    if (dataProvider.isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()), // Saat loading, tunjukkan spinner
      );
    }

    return Scaffold(
      appBar: buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSection(carouselImages: carouselImages),
            
            CategoryGrid(),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 4,
                    height: 24,
                    child: ColoredBox(color: Colors.blue),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Statistik Saat ini",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            StatisticSection(), // Pastikan dia ambil dari Provider juga
            PartInfografis(),    // Pastikan ambil dari Provider juga
            PartNews(),          // Pastikan ambil dari Provider juga
            PartPublikasi(),     // Pastikan ambil dari Provider juga
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SearchPage()),
          );
        },
        backgroundColor: Color.fromARGB(255, 101, 149, 153),
        child: const Icon(Icons.search),
      ),
    );
  }
}
