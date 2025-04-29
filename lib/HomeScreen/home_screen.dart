import 'package:flutter/material.dart';
import '../components/appbar.dart';
import '../HomeScreen/carousel_section.dart';
import '../HomeScreen/statistic_section.dart';
import '../HomeScreen/part_infografis.dart';
import '../HomeScreen/part_news.dart';
import '../HomeScreen/part_tabel.dart';
import '../HomeScreen/part_publikasi.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> carouselImages = [
    'assets/images/grup1.png',
    'assets/images/grup4.png',
    'assets/images/grup3.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSection(carouselImages: carouselImages),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Tabel Data Statistik",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            CategoryGrid(),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                      width: 4,
                      height: 24,
                      child: ColoredBox(color: Colors.blue)),
                  SizedBox(width: 8),
                  Text(
                    "Statistik Saat ini",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const StatisticSection(),
            const PartInfografis(),
            const PartNews(),
            const PartPublikasi(),
          ],
        ),
      ),
    );
  }
}