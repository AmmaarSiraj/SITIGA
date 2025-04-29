import 'package:flutter/material.dart';
import '../publikasi/publikasi_service.dart';  // Import service publikasi
import '../news/news_service.dart';      // Import service berita
import '../infographic/infographic_service.dart';
import '../net/network.dart';

class DataProvider with ChangeNotifier {
  // List<Map<String, dynamic>> allPublications = [];
  // List<Map<String, dynamic>> allNews = [];
  List<Map<String, dynamic>> allInfographics = [];
  List<Map<String, dynamic>> allSubjects = [];
  bool isLoading = false;

  Future<void> preloadMinimalData() async {
  try {
    isLoading = true;
    notifyListeners();

    // final fetchNews = NewsService.fetchNews(1);
    // final fetchPublications = PublikasiService.fetchPublications(1); // <= Tambahkan ini
    final fetchInfographics = fetchAllInfographics(totalPages: 2);
    final fetchSubjectsFuture = fetchSubjects();
    

    final results = await Future.wait([ fetchInfographics, fetchSubjectsFuture, ]);

    // allNews = results[0];
    // allPublications = results[2];
    allInfographics = results[0];
    allSubjects = results[1];
    

    isLoading = false;
    notifyListeners();
  } catch (e) {
    isLoading = false;
    notifyListeners();
    print("Error preloading minimal data: $e");
  }
}


// Load lengkap (background load)
Future<void> loadAllData() async {
  try {
    final fetchPublications = PublikasiService.fetchPublications(10);
    final fetchNews = NewsService.fetchNews(1); // nanti buat ambil semua halaman
    final fetchInfographics = fetchAllInfographics(totalPages: 29);

    final results = await Future.wait([fetchPublications, fetchNews, fetchInfographics]);

    // allPublications = results[0];
    // allNews = results[1];
    allInfographics = results[2];

    notifyListeners();
  } catch (e) {
    print("Error loading full data: $e");
  }
}
}