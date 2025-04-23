import 'package:flutter/material.dart';
import '../publikasi/publikasi_service.dart';  // Import service publikasi
import '../news/news_service.dart';      // Import service berita
import '../infographic/infographic_service.dart';

class DataProvider with ChangeNotifier {
  List<Map<String, dynamic>> allPublications = [];
  List<Map<String, dynamic>> allNews = [];
  List<Map<String, dynamic>> allInfographics = [];
  bool isLoading = false;

  Future<void> loadData() async {
    try {
      isLoading = true;
      notifyListeners();
      
      // Fetch data secara bersamaan
      final fetchPublications = PublikasiService.fetchAllPublications();
      final fetchNews = NewsService.fetchNews(1);  // buat service news yang sesuai
      final fetchInfographics = fetchAllInfographics(totalPages: 29);


      final results = await Future.wait([fetchPublications, fetchNews, fetchInfographics]);

      allPublications = results[0];
      allNews = results[1];
      allInfographics = results[2];
      
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print("Error loading data: $e");
    }
  }
}
