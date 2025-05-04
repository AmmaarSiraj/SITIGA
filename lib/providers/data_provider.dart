import 'package:flutter/material.dart';
import '../publikasi/publikasi_service.dart';  
import '../news/news_service.dart';      
import '../infographic/infographic_service.dart';
import '../net/network.dart';

class DataProvider with ChangeNotifier {
<<<<<<< HEAD
=======
  
>>>>>>> 6848fdb5d042b3187a6ab30d123ccc3dbf5f0965
  List<Map<String, dynamic>> allInfographics = [];
  List<Map<String, dynamic>> allSubjects = [];
  List<Map<String, dynamic>> allInfographicData = [];
  bool isLoading = false;

  Future<void> preloadMinimalData() async {
  try {
    isLoading = true;
    notifyListeners();

<<<<<<< HEAD
    final fetchInfographicsFuture = fetchAllInfographics(totalPages: 2);
      final fetchSubjectsFuture = fetchSubjects();
      final fetchInfographicDataFuture = fetchInfographicData();
    

 final results = await Future.wait([
        fetchInfographicsFuture,
        fetchSubjectsFuture,
        fetchInfographicDataFuture,
      ]);
      
=======
    
    final fetchInfographics = fetchAllInfographics(totalPages: 2);
    final fetchSubjectsFuture = fetchSubjects();
    

    final results = await Future.wait([ fetchInfographics, fetchSubjectsFuture, ]);

    
>>>>>>> 6848fdb5d042b3187a6ab30d123ccc3dbf5f0965
    allInfographics = results[0];
    allSubjects = results[1];
    allInfographicData = results[2];
    

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

<<<<<<< HEAD
    
=======
   
>>>>>>> 6848fdb5d042b3187a6ab30d123ccc3dbf5f0965
    allInfographics = results[2];

    notifyListeners();
  } catch (e) {
    print("Error loading full data: $e");
  }
}
}