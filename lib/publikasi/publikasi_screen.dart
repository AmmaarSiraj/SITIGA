import 'package:flutter/material.dart';
import '../../components/appbar.dart';
// import 'publikasi_service.dart';
import '../publikasi/publikasi_grid.dart';
import 'publikasi_header.dart';
import 'publikasi_pencarian_filter.dart';
import 'tombol_sebelum_sesudah.dart';
import 'package:provider/provider.dart';
import '../providers/data_provider.dart';


class PublicationListScreen extends StatefulWidget {
  @override
  _PublicationListScreenState createState() => _PublicationListScreenState();
}

class _PublicationListScreenState extends State<PublicationListScreen> {
  final ScrollController _scrollController = ScrollController();
  Map<String, List<Map<String, dynamic>>> cachedPublications = {};
  List<Map<String, dynamic>> filteredPublications = [];

  bool isLoading = true;
  int currentPage = 1;
  final int itemsPerPage = 12;
  String searchQuery = "";
  String selectedFilter = "Semua";

  @override
  void initState() {
    super.initState();
    fetchAndCachePublications("Semua");
  }

  Future<void> fetchAndCachePublications(String category) async {
  final allData = Provider.of<DataProvider>(context, listen: false).allPublications;

  final filtered = category == "Semua"
      ? allData
      : allData.where((item) => item['category'] == category).toList();

  cachedPublications[category] = filtered;

  setState(() {
    filteredPublications = applySearch(filtered);
    isLoading = false;
  });
}


  List<Map<String, dynamic>> applySearch(List<Map<String, dynamic>> data) {
    return data.where((pub) {
      return pub['title']
          .toString()
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
    }).toList();
  }

  void applyFilters() {
    setState(() {
      isLoading = true;
    });
    fetchAndCachePublications(selectedFilter);
    currentPage = 1;
  }

  @override
  Widget build(BuildContext context) {
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;
    List<Map<String, dynamic>> pagedPublications = filteredPublications.sublist(
      startIndex,
      endIndex > filteredPublications.length
          ? filteredPublications.length
          : endIndex,
    );

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
                  onSearchChanged: (value) {
                    setState(() {
                      searchQuery = value;
                      filteredPublications = applySearch(
                          cachedPublications[selectedFilter] ?? []);
                      currentPage = 1;
                    });
                  },
                  onFilterChanged: (value) {
                    selectedFilter = value;
                    applyFilters();
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
                        TombolSebelumSesudah(
                          currentPage: currentPage,
                          maxPage: (filteredPublications.length / itemsPerPage)
                              .ceil(),
                          onPageChanged: (newPage) {
                            setState(() {
                              currentPage = newPage;
                            });
                            _scrollController.animateTo(
                              0,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          },
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
