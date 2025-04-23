import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'tabellist.dart';
import '../components/loading_progres.dart';
import '../components/modern_filter_screen.dart';
import '../../components/appbar.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: StatisticTableScreen(),
    );
  }
}

class StatisticTableScreen extends StatefulWidget {
  @override
  _StatisticTableScreenState createState() => _StatisticTableScreenState();
}

class _StatisticTableScreenState extends State<StatisticTableScreen> {
  Map<String, Map<String, List<Map<String, dynamic>>>> groupedCategories = {
    "Statistik Demografi dan Sosial": {},
    "Statistik Ekonomi": {},
    "Statistik Lingkungan Hidup dan Multi-domain": {}
  };

  bool isDataLoading = true;
  int completedRequests = 0;
  final int totalRequests = 137;

  Map<String, String> categoryMapping = {
    // mapping tetap sama
    "Kependudukan dan Migrasi": "Statistik Demografi dan Sosial",
    "Tenaga Kerja": "Statistik Demografi dan Sosial",
    "Pendidikan": "Statistik Demografi dan Sosial",
    "Kesehatan": "Statistik Demografi dan Sosial",
    "Konsumsi dan Pendapatan": "Statistik Demografi dan Sosial",
    "Perlindungan Sosial": "Statistik Demografi dan Sosial",
    "Permukiman dan Perumahan": "Statistik Demografi dan Sosial",
    "Hukum dan Kriminal": "Statistik Demografi dan Sosial",
    "Budaya": "Statistik Demografi dan Sosial",
    "Waktu": "Statistik Demografi dan Sosial",
    "Aktivitas Politik dan Komunitas": "Statistik Demografi dan Sosial",
    "Ekonomi": "Statistik Ekonomi",
    "Industri": "Statistik Ekonomi",
    "Perdagangan": "Statistik Ekonomi",
    "Keuangan": "Statistik Ekonomi",
    "Energi": "Statistik Ekonomi",
    "Pariwisata": "Statistik Ekonomi",
    "Lingkungan Hidup": "Statistik Lingkungan Hidup dan Multi-domain",
    "Pertanian": "Statistik Lingkungan Hidup dan Multi-domain",
    "Kehutanan": "Statistik Lingkungan Hidup dan Multi-domain",
    "Perikanan": "Statistik Lingkungan Hidup dan Multi-domain",
    "Transportasi": "Statistik Lingkungan Hidup dan Multi-domain",
    "Hortikultura": "Statistik Lingkungan Hidup dan Multi-domain",
    "Produk Domestik Regional Bruto (Lapangan Usaha)": "Statistik Ekonomi",
    "Produk Domestik Regional Bruto (Pengeluaran)": "Statistik Ekonomi",
    "Keadaan Geografi": "Statistik Lingkungan Hidup dan Multi-domain",
    "Pemerintahan": "Statistik Demografi dan Sosial",
    "Iklim": "Statistik Lingkungan Hidup dan Multi-domain",
    "Tanaman Pangan": "Statistik Lingkungan Hidup dan Multi-domain",
    "Sosial Budaya": "Statistik Demografi dan Sosial",
    "Kependudukan": "Statistik Demografi dan Sosial",
    "Kemiskinan dan Ketimpangan": "Statistik Demografi dan Sosial",
    "Keluarga Berencana": "Statistik Demografi dan Sosial",
    "Peternakan": "Statistik Lingkungan Hidup dan Multi-domain",
    "Komunikasi": "Statistik Ekonomi",
    "Energi dan Air Minum": "Statistik Ekonomi",
    "Gender": "Statistik Demografi dan Sosial",
    "Indeks Pembangunan Manusia": "Statistik Demografi dan Sosial",
    "Inflasi": "Statistik Ekonomi",
    "Keadaan geografi": "Statistik Lingkungan Hidup dan Multi-domain",
  };

  @override
  String searchQuery = "";
  String selectedCategory = "Semua";
  int minTables = 1; // Atur nilai default sesuai kebutuhan
  // Mapping kategori filter ke kategori utama
  Map<String, List<String>> categoryFilterMapping = {
    "Populasi & Demografi": ["Statistik Demografi dan Sosial"],
    "Ekonomi & Keuangan": ["Statistik Ekonomi"],
    "Pendidikan & Kesehatan": ["Statistik Demografi dan Sosial"],
    "Lingkungan & Sumber Daya Alam": [
      "Statistik Lingkungan Hidup dan Multi-domain"
    ],
    "Transportasi & Infrastruktur": [
      "Statistik Lingkungan Hidup dan Multi-domain"
    ],
    "Industri & Perdagangan": ["Statistik Ekonomi"],
  };

  void initState() {
    super.initState();
    fetchPublications();
  }

  Future<void> fetchPage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] is List && data['data'].length > 1) {
          final List<dynamic> rawList = data['data'][1];
          setState(() {
            for (var table in rawList) {
              String subj = table['subj']?.toString() ?? "Uncategorized";
              String? mainCategory = categoryMapping[subj] ?? "Uncategorized";

              if (!groupedCategories.containsKey(mainCategory)) {
                groupedCategories[mainCategory] = {};
              }

              groupedCategories[mainCategory]!
                  .putIfAbsent(subj, () => [])
                  .add(table);
            }
            completedRequests++;
          });
        }
      } else {
        throw Exception("Failed to load page: $url");
      }
    } catch (e) {
      print("Error fetching data from $url: $e");
      setState(() {
        completedRequests++;
      });
    }
  }

  Future<void> fetchPublications() async {
    final baseUrl =
        "https://webapi.bps.go.id/v1/api/list/model/statictable/lang/ind/domain/3373/page/";
    final key = "/key/91e4d5e9c5a13e1b6214a14f037956de/";

    for (int i = 0; i < totalRequests; i += 10) {
      // Memproses 10 request sekaligus
      List<Future<void>> batchRequests = [];
      for (int j = i; j < i + 10 && j <= totalRequests; j++) {
        batchRequests.add(fetchPage("$baseUrl$j$key"));
      }
      await Future.wait(batchRequests);
    }

    if (mounted) {
      setState(() {
        isDataLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Column(
        children: [
          // --- GANTI FILTER DENGAN WIDGET MODERN ---
          ModernFilterScreen(
            onFilterChanged: (String query, String category) {
              setState(() {
                searchQuery = query.toLowerCase();
                selectedCategory = category;
              });
            },
          ),

          // --- LIST KATEGORI ---

          // Masih menampilkan kategori utama sebelum subkategori dengan ExpansionTile
          Expanded(
            child: isDataLoading
                ? Center(
                    child: LoadingProgress(
                      completed: completedRequests,
                      total: totalRequests,
                      message: "Memuat data statistik...",
                    ),
                  ) // Menggunakan LoadingProgress sebagai indikator loading
                : ListView(
                    padding: EdgeInsets.all(12),
                    children: groupedCategories.keys.where((mainCategory) {
                      if (selectedCategory == "Semua") {
                        return true; // Tampilkan kategori utama & subkategori
                      }
                      return categoryFilterMapping[selectedCategory]
                              ?.contains(mainCategory) ??
                          false;
                    }).expand((mainCategory) {
                      if (selectedCategory == "Semua" && searchQuery.isEmpty) {
                        // Jika kategori "Semua" dipilih & tidak ada pencarian, tampilkan kategori utama & subkategori
                        return [
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            elevation: 3,
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: ExpansionTile(
                              leading: Icon(Icons.folder_special,
                                  color: Colors.indigo),
                              title: Text(
                                mainCategory,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              children: groupedCategories[mainCategory]!
                                  .keys
                                  .map((subCategory) {
                                int tableCount = groupedCategories[
                                        mainCategory]![subCategory]!
                                    .length;
                                return ListTile(
                                  leading: Icon(Icons.insert_chart,
                                      color: Colors.indigoAccent),
                                  title: Text(subCategory),
                                  subtitle: Text("Jumlah tabel: $tableCount"),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SubCategoryTableScreen(
                                          subCategoryName: subCategory,
                                          tables: groupedCategories[
                                              mainCategory]![subCategory]!,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        ];
                      } else {
                        // Jika kategori selain "Semua" dipilih atau pencarian dilakukan, tampilkan hanya subkategori
                        return groupedCategories[mainCategory]!
                            .keys
                            .where((subCategory) =>
                                searchQuery.isEmpty ||
                                subCategory
                                    .toLowerCase()
                                    .startsWith(searchQuery))
                            .map((subCategory) {
                          int tableCount =
                              groupedCategories[mainCategory]![subCategory]!
                                  .length;
                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            elevation: 3,
                            margin: EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              leading: Icon(Icons.insert_chart,
                                  color: Colors.indigoAccent),
                              title: Text(subCategory),
                              subtitle: Text("Jumlah tabel: $tableCount"),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SubCategoryTableScreen(
                                      subCategoryName: subCategory,
                                      tables: groupedCategories[mainCategory]![
                                          subCategory]!,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }).toList();
                      }
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

class SubCategoryTableScreen extends StatelessWidget {
  final String subCategoryName;
  final List<Map<String, dynamic>> tables;

  SubCategoryTableScreen({required this.subCategoryName, required this.tables});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text(subCategoryName, style: GoogleFonts.poppins()),
      ),
      body: TableList(tables: tables),
    );
  }
}
