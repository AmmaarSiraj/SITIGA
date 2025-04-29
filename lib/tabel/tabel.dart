import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tabellist.dart';
import '../components/loading_progres.dart';
import '../components/modern_filter_screen.dart';
import '../../components/appbar.dart';
import '../tabel/tabel_service.dart'; // <- Import service baru
import '../Search/search_page.dart';

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

  String searchQuery = "";
  String selectedCategory = "Semua";
  int minTables = 1;

  Map<String, String> categoryMapping = {
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

  @override
  void initState() {
    super.initState();
    TabelService(
      totalRequests: totalRequests,
      onDataFetched: (fetchedData) {
        if (mounted) {
          setState(() {
            groupedCategories = fetchedData;
            isDataLoading = false;
          });
        }
      },
      onProgress: (progress) {
        if (mounted) {
          setState(() {
            completedRequests = progress;
          });
        }
      },
      categoryMapping: categoryMapping,
    ).fetchPublications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Column(
        children: [
          ModernFilterScreen(
            onFilterChanged: (String query, String category) {
              setState(() {
                searchQuery = query.toLowerCase();
                selectedCategory = category;
              });
            },
          ),
          Expanded(
            child: isDataLoading
                ? Center(
                    child: LoadingProgress(
                      completed: completedRequests,
                      total: totalRequests,
                      message: "Memuat data statistik...",
                    ),
                  )
                : ListView(
                    padding: EdgeInsets.all(12),
                    children: groupedCategories.keys.where((mainCategory) {
                      if (selectedCategory == "Semua") return true;
                      return categoryFilterMapping[selectedCategory]
                              ?.contains(mainCategory) ??
                          false;
                    }).expand((mainCategory) {
                      if (selectedCategory == "Semua" &&
                          searchQuery.isEmpty) {
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
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
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
