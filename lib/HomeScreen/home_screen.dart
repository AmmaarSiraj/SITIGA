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


class HomeScreen extends StatelessWidget {
  final List<String> carouselImages = [
    'assets/images/1.png',
    'assets/images/2.png',
    'assets/images/3.png',
    'assets/images/4.png',
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
            StatisticSection(), 
            PartInfografis(),    
            PartNews(),                     
            PartPublikasi(),     
          ],
        ),
      ),
    );
  }
}
