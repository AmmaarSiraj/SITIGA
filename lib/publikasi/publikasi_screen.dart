import 'package:flutter/material.dart';
import '../../components/appbar.dart';
import '../publikasi/publikasi_grid.dart';
import '../components/SectionHeader.dart';
import 'publikasi_filter.dart';
import '../components/next_page.dart';
import '../publikasi/publikasi_service.dart';
import '../publikasi/publikasi_pencarian.dart'; // Tambahan penting

class PublicationListScreen extends StatefulWidget {
  @override
  _PublicationListScreenState createState() => _PublicationListScreenState();
}

class _PublicationListScreenState extends State<PublicationListScreen> {
  static const int TOTAL_SERVER_PAGES = 24;
  final ScrollController _scrollController = ScrollController();

  Map<int, List<Map<String, dynamic>>> cachedPublications = {};
  List<Map<String, dynamic>> allPublications = [];
  List<Map<String, dynamic>> filteredAllData = [];
  List<Map<String, dynamic>> pagedPublications = [];

  bool isLoading = true;
  int currentPage = 1;
  int totalPages = TOTAL_SERVER_PAGES;
  final int itemsPerPage = 12;

  String selectedFilter = '(Semua)';

  @override
  void initState() {
    super.initState();
    _loadPage(1);
  }

  Future<void> _loadPage(int page) async {
    setState(() => isLoading = true);

    if (selectedFilter != '(Semua)') {
      await _fetchAllPages();
      _applyGlobalFilterAndPaginate(page);
    } else {
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

  void _applyLocalFilterAndPaginate(int page) {
    final pageData = cachedPublications[page]!;
    filteredAllData = _applyFilter(pageData);

    totalPages = TOTAL_SERVER_PAGES;
    currentPage = page;
    pagedPublications = filteredAllData;
  }

  void _applyGlobalFilterAndPaginate(int page) {
    filteredAllData = _applyFilter(allPublications);

    totalPages = (filteredAllData.length / itemsPerPage).ceil();
    currentPage = page;

    final start = (page - 1) * itemsPerPage;
    pagedPublications = filteredAllData.skip(start).take(itemsPerPage).toList();
  }

  List<Map<String, dynamic>> _applyFilter(List<Map<String, dynamic>> data) {
    return data.where((pub) {
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
      } else if (selectedFilter == '(Semua)') {
        filterMatch = true;
      } else {
        final filterYear = int.tryParse(selectedFilter) ?? -1;
        filterMatch = year != null && year == filterYear;
      }
      return filterMatch;
    }).toList();
  }

  void changePage(int page) {
    _loadPage(page).then((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut);
        }
      });
    });
  }

  void applyFilters(String newFilter) {
    setState(() {
      selectedFilter = newFilter;
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
                SectionHeader(title: "Publikasi"),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Kolom Pencarian
                      Expanded(
                        flex: 6,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PencarianPublikasiScreen(query: ''),
                              ),
                            );
                          },
                          child: AbsorbPointer(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Pencarian Publikasi...',
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 14),
                              ),
                              style: TextStyle(fontSize: 16, height: 1.2),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Filter + Halaman
                      PublikasiPencarianFilter(
                        selectedFilter: selectedFilter,
                        currentPage: currentPage,
                        totalPages: totalPages,
                        onFilterChanged: (value) => applyFilters(value),
                        onPageChanged: changePage,
                      ),
                    ],
                  ),
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
    );
  }
}
