import 'package:flutter/material.dart';
import '../../components/appbar.dart';
import '../publikasi/publikasi_grid.dart';
import 'publikasi_header.dart';
import 'publikasi_pencarian_filter.dart';
import '../publikasi/next_page.dart';
import '../publikasi/publikasi_service.dart';

class PublicationListScreen extends StatefulWidget {
  @override
  _PublicationListScreenState createState() => _PublicationListScreenState();
}

class _PublicationListScreenState extends State<PublicationListScreen> {
  final ScrollController _scrollController = ScrollController();
  Map<int, List<Map<String, dynamic>>> cachedPublications = {}; // Cache berdasarkan halaman
  List<Map<String, dynamic>> filteredPublications = [];

  bool isLoading = true;
  int currentPage = 1;
  int totalPages = 1;
  final int itemsPerPage = 12;
  String searchQuery = "";
  String selectedFilter = "Semua";

  @override
  void initState() {
    super.initState();
    fetchPublications(currentPage);
  }

<<<<<<< HEAD
  Future<void> fetchAndCachePublications(String category) async {
    final allData =
        Provider.of<DataProvider>(context, listen: false).allPublications;
=======
  Future<void> fetchPublications(int page) async {
    if (cachedPublications.containsKey(page)) {
      setState(() {
        filteredPublications = applySearch(cachedPublications[page]!);
        currentPage = page;
        isLoading = false;
      });
      return;
    }
>>>>>>> f1680d6ce69745b7f39b4191619cb49e214dd591

    try {
      final fetchedList = await PublikasiService.fetchPublications(page);
      cachedPublications[page] = fetchedList;

      setState(() {
        filteredPublications = applySearch(fetchedList);
        totalPages = 10; // Atau ambil dari server
        currentPage = page;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching publications: $e");
    }
  }

  List<Map<String, dynamic>> applySearch(List<Map<String, dynamic>> data) {
    return data.where((pub) {
      return pub['title']
          .toString()
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
    }).toList();
  }

  void changePage(int page) {
  setState(() {
    isLoading = true;
  });

  fetchPublications(page).then((_) {
    // Pastikan animateTo hanya dipanggil setelah widget selesai di-render
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  });
}


  void applyFilters() {
    setState(() {
      isLoading = true;
    });
    cachedPublications.remove(selectedFilter); // Clear cache biar fetch ulang
    fetchPublications(1);
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> pagedPublications = filteredPublications;

    return Scaffold(
      appBar: buildAppBar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const PublikasiHeader(),
                PublikasiPencarianFilter(
                  searchQuery: searchQuery,
                  selectedFilter: selectedFilter,
                  currentPage: currentPage,
                  totalPages: totalPages,
                  onSearchChanged: (value) {
<<<<<<< HEAD
                    setState(() {
                      searchQuery = value;
                      filteredPublications =
                          applySearch(cachedPublications[selectedFilter] ?? []);
                      totalPages =
                          (filteredPublications.length / itemsPerPage).ceil();
                      currentPage = 1;
                    });
                  },
=======
  setState(() {
    searchQuery = value;
    final originalData = cachedPublications[currentPage] ?? [];
    filteredPublications = applySearch(originalData);
    totalPages = (filteredPublications.length / itemsPerPage).ceil();
    currentPage = 1;
  });
},

>>>>>>> f1680d6ce69745b7f39b4191619cb49e214dd591
                  onFilterChanged: (value) {
                    selectedFilter = value;
                    applyFilters();
                  },
                  onPageChanged: (page) {
                    changePage(page);
                  },
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        PublikasiGrid(
                          publications: pagedPublications,
                          scrollController: _scrollController,
                        ),
                        NextPage(
                          currentPage: currentPage,
                          totalPages: totalPages,
                          onPageChanged: (page) {
                            changePage(page);
                          },
                          scrollController: _scrollController,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
