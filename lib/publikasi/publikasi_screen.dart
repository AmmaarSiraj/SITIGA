import 'package:flutter/material.dart';
import '../../components/appbar.dart';
import '../publikasi/publikasi_grid.dart';
import 'publikasi_header.dart';
import 'publikasi_pencarian_filter.dart';
import '../components/next_page.dart';
import '../publikasi/publikasi_service.dart';
import '../Search/search_page.dart';

class PublicationListScreen extends StatefulWidget {
  @override
  _PublicationListScreenState createState() => _PublicationListScreenState();
}

class _PublicationListScreenState extends State<PublicationListScreen> {
  static const int TOTAL_SERVER_PAGES = 24; // Jumlah page di API
  final ScrollController _scrollController = ScrollController();

  // Cache per-page
  Map<int, List<Map<String, dynamic>>> cachedPublications = {};
  // Semua data beserta hasil filter global
  List<Map<String, dynamic>> allPublications = [];
  List<Map<String, dynamic>> filteredAllData = [];

  List<Map<String, dynamic>> pagedPublications = [];


  bool isLoading = true;
  int currentPage = 1;
  int totalPages = TOTAL_SERVER_PAGES;
  final int itemsPerPage = 12;

  String searchQuery = "";
  String selectedFilter = '(Semua)';

  @override
  void initState() {
    super.initState();
    _loadPage(1);
  }

  /// Load satu page saja jika filter = Semua,
  /// atau load semua pages + filter jika filter aktif
  Future<void> _loadPage(int page) async {
  setState(() => isLoading = true);

  // Kalau ada searchQuery atau filter != Semua, fetch semua pages dan apply global
  if (searchQuery.isNotEmpty || selectedFilter != '(Semua)') {
    await _fetchAllPages();
    _applyGlobalFilterAndPaginate(page);
  }
  else {
    // normal: fetch & filter satu page
    await _fetchAndCachePage(page);
    _applyLocalFilterAndPaginate(page);
  }

  setState(() => isLoading = false);
}


  Future<void> _fetchAndCachePage(int page) async {
    if (!cachedPublications.containsKey(page)) {
      final data = await PublikasiService.fetchPublications(page);
      cachedPublications[page] = data;
    }
  }

  Future<void> _fetchAllPages() async {
    allPublications.clear();
    for (var p = 1; p <= TOTAL_SERVER_PAGES; p++) {
      if (!cachedPublications.containsKey(p)) {
        final data = await PublikasiService.fetchPublications(p);
        cachedPublications[p] = data;
      }
      allPublications.addAll(cachedPublications[p]!);
    }
  }

  // Hanya filter & paginate dari satu page saja (tanpa fetch ulang)
  void _applyLocalFilterAndPaginate(int page) {
    final pageData = cachedPublications[page]!;
    filteredAllData = _applySearchAndFilter(pageData);

    totalPages = TOTAL_SERVER_PAGES;
    currentPage = page;
    pagedPublications = filteredAllData;
  }

  // Filter global & buat pagination slice
  void _applyGlobalFilterAndPaginate(int page) {
    filteredAllData = _applySearchAndFilter(allPublications);

    totalPages = (filteredAllData.length / itemsPerPage).ceil();
    currentPage = page;

    final start = (page - 1) * itemsPerPage;
    pagedPublications = filteredAllData
        .skip(start)
        .take(itemsPerPage)
        .toList();
  }

  List<Map<String, dynamic>> _applySearchAndFilter(List<Map<String, dynamic>> data) {
    return data.where((pub) {
      final titleMatch = pub['title']
          .toString()
          .toLowerCase()
          .contains(searchQuery.toLowerCase());

      if (selectedFilter.toLowerCase() == 'semua' || selectedFilter == '(Semua)') {
        return titleMatch;
      }

      final rlDate = pub['rl_date']?.toString() ?? '';
      int? year;
      try {
        year = DateTime.parse(rlDate).year;
      } catch (_) {
        year = null;
      }

      bool filterMatch;
      if (selectedFilter == '<2020') {
        filterMatch = year != null && year < 2020;
      } else {
        final filterYear = int.tryParse(selectedFilter) ?? -1;
        filterMatch = year != null && year == filterYear;
      }

      return titleMatch && filterMatch;
    }).toList();
  }

  void changePage(int page) {
    _loadPage(page).then((_) {
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

  void applyFilters(String newFilter) {

    setState(() {
      selectedFilter = newFilter;
      searchQuery = "";       // kalau mau reset search juga
    });
    _loadPage(1);
  }

  @override
  Widget build(BuildContext context) {
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
  setState(() => searchQuery = value);
  _loadPage(1);
},

                  onFilterChanged: (value) {
                    applyFilters(value);
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
                          onPageChanged: changePage,
                          scrollController: _scrollController,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
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