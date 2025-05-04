import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../news/news_service.dart';
import '../publikasi/publikasi_service.dart';
import '../infographic/infographic_service.dart';
import '../news/detail/news_detail.dart';
import '../infographic/detail/infographic_detail.dart';
import '../publikasi/detail/publikasi_detail.dart';

class ResultItem {
  final String title;
  final String serviceType;
  final String? imageUrl;
  final String? date;
  final Map<String, dynamic>? rawData;

  ResultItem({
    required this.title,
    required this.serviceType,
    this.imageUrl,
    this.date,
    this.rawData,
  });
}

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _searchByTitle = true;

  String selectedYear = 'Semua Tahun';
  String selectedSort = 'Relevansi';
  String selectedContentType = 'Semua Konten';

  final List<String> years = ['Semua Tahun', '2025', '2024', '2023'];
  final List<String> sortOptions = ['Relevansi', 'Terbaru', 'Terlama'];
  final List<String> contentTypes = ['Semua Konten', 'Tabel', 'Publikasi', 'Infografis', 'Berita'];

  List<ResultItem> _results = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      if (_hasSearched || _isLoading) {
        setState(() {
          _hasSearched = false;
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // 🟩 Fungsi pencarian utama dengan filter diterapkan
Future<void> _performSearch() async {
  final keyword = _searchController.text.toLowerCase();
  setState(() {
    _results.clear();
    _isLoading = true;
    _hasSearched = false;
  });

  void addResults(List<ResultItem> newItems) {
    setState(() {
      _results.addAll(newItems);
    });
  }

  // 🟦 Pencarian berita dengan filter jenis konten, tahun, dan judul
  Future<void> searchNews() async {
    if (selectedContentType != 'Semua Konten' && selectedContentType != 'Berita') return;
    int page = 1;
    while (true) {
      try {
        final items = await NewsService.fetchNews(page);
        if (items.isEmpty) break;
        final filtered = items.where((item) {
          final title = (item['title'] ?? '').toString().toLowerCase();
          final date = (item['rl_date'] ?? '').toString();
          final matchKeyword = !_searchByTitle || title.contains(keyword);
          final matchYear = selectedYear == 'Semua Tahun' || date.contains(selectedYear);
          return matchKeyword && matchYear;
        }).map((item) => ResultItem(
              title: item['title'].toString(),
              serviceType: 'Berita',
              imageUrl: item['picture'],
              date: item['rl_date'],
              rawData: item,
            )).toList();
        if (filtered.isNotEmpty) addResults(filtered);
        page++;
      } catch (_) {
        break;
      }
    }
  }

  // 🟦 Pencarian publikasi dengan filter
  Future<void> searchPublikasi() async {
    if (selectedContentType != 'Semua Konten' && selectedContentType != 'Publikasi') return;
    int page = 1;
    while (true) {
      try {
        final items = await PublikasiService.fetchPublications(page);
        if (items.isEmpty) break;
        final filtered = items.where((item) {
          final title = (item['title'] ?? '').toString().toLowerCase();
          final date = (item['rl_date'] ?? '').toString();
          final matchKeyword = !_searchByTitle || title.contains(keyword);
          final matchYear = selectedYear == 'Semua Tahun' || date.contains(selectedYear);
          return matchKeyword && matchYear;
        }).map((item) => ResultItem(
              title: item['title'].toString(),
              serviceType: 'Publikasi',
              imageUrl: item['cover'],
              date: item['rl_date'],
              rawData: item,
            )).toList();
        if (filtered.isNotEmpty) addResults(filtered);
        page++;
      } catch (_) {
        break;
      }
    }
  }

  // 🟦 Pencarian infografis dengan filter
  Future<void> searchInfografis() async {
    if (selectedContentType != 'Semua Konten' && selectedContentType != 'Infografis') return;
    try {
      final items = await fetchAllInfographics();
      final filtered = items.where((item) {
        final title = (item['title'] ?? '').toString().toLowerCase();
        final date = (item['rl_date'] ?? '').toString();
        final matchKeyword = !_searchByTitle || title.contains(keyword);
        final matchYear = selectedYear == 'Semua Tahun' || date.contains(selectedYear);
        return matchKeyword && matchYear;
      }).map((item) => ResultItem(
            title: item['title'].toString(),
            serviceType: 'Infografis',
            imageUrl: item['img'],
            date: item['rl_date'],
            rawData: item,
          )).toList();
      if (filtered.isNotEmpty) addResults(filtered);
    } catch (_) {}
  }

  await Future.wait([
    searchNews(),
    searchPublikasi(),
    searchInfografis(),
  ]);

  // 🟨 Sorting hasil pencarian jika dipilih
  if (selectedSort == 'Terbaru') {
    _results.sort((a, b) => (b.date ?? '').compareTo(a.date ?? ''));
  } else if (selectedSort == 'Terlama') {
    _results.sort((a, b) => (a.date ?? '').compareTo(b.date ?? ''));
  }

  setState(() {
    _isLoading = false;
    _hasSearched = true;
  });
}

  void _openFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Filter Pencarian', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: selectedYear,
                      decoration: const InputDecoration(labelText: 'Tahun Rilis'),
                      items: years.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) => setModalState(() => selectedYear = value!),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Cari berdasarkan Judul"),
                        Switch(
                          value: _searchByTitle,
                          onChanged: (value) => setModalState(() => _searchByTitle = value),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedSort,
                      decoration: const InputDecoration(labelText: 'Urut Berdasarkan'),
                      items: sortOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) => setModalState(() => selectedSort = value!),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedContentType,
                      decoration: const InputDecoration(labelText: 'Jenis Konten'),
                      items: contentTypes.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) => setModalState(() => selectedContentType = value!),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 101, 149, 153)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Terapkan'),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pencarian'),
        backgroundColor: const Color.fromARGB(255, 101, 149, 153),
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
<<<<<<< HEAD
            Align(
              alignment: Alignment.topLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on, size: 18, color: Colors.grey[700]),
                  const SizedBox(width: 4),
                  Text("BPS Kota Salatiga", style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                ],
              ),
            ),
=======
          Align(
  alignment: Alignment.topLeft,
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.location_on, size: 18, color: Colors.grey[700]),
      SizedBox(width: 4),
      Text(
        "BPS Kota Salatiga",
        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
      ),
    ],
  ),
),

>>>>>>> 6848fdb5d042b3187a6ab30d123ccc3dbf5f0965
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Masukkan kata kunci',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
                        child: _isLoading
                            ? Padding(
                                key: const ValueKey('loading'),
                                padding: const EdgeInsets.all(10),
                                child: const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              )
                            : (_hasSearched
                                ? const Icon(Icons.check, color: Colors.green, key: ValueKey('done'))
                                : const SizedBox.shrink(key: ValueKey('empty'))),
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _openFilterModal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 101, 149, 153),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Icon(Icons.tune),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _performSearch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 101, 149, 153),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Cari'),
              ),
            ),
            const SizedBox(height: 16),
            // 🟩 Menampilkan filter yang sedang diterapkan
if (_hasSearched &&
    (
      selectedContentType != 'Semua Konten' ||
      selectedYear != 'Semua Tahun' ||
      selectedSort != 'Relevansi' ||
      (_searchByTitle && (
        selectedContentType != 'Semua Konten' ||
        selectedYear != 'Semua Tahun' ||
        selectedSort != 'Relevansi'
      ))
    )
) ...[

  Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      if (selectedContentType != 'Semua Konten')
        Chip(label: Text('Konten: $selectedContentType')),
      if (selectedYear != 'Semua Tahun')
        Chip(label: Text('Tahun: $selectedYear')),
      if (selectedSort != 'Relevansi')
        Chip(label: Text('Urutan: $selectedSort')),
      if (_searchByTitle)
        const Chip(label: Text('Cari berdasarkan Judul')),
    ],
  ),
  const SizedBox(height: 12),
],

            Expanded(
              child: (_isLoading && _results.isEmpty)
                  ? const Center(child: CircularProgressIndicator())
                  : (!_isLoading && _results.isEmpty && _hasSearched)
                      ? const Center(child: Text('Tidak ada hasil.'))
                      : ListView.builder(
                          itemCount: _results.length,
                          itemBuilder: (context, index) {
                            final item = _results[index];
                            return InkWell(
                              onTap: () {
                                if (item.serviceType == 'Berita') {
                                  final id = item.rawData?['news_id']?.toString() ?? '';
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NewsDetailScreen(newsId: id),
                                    ),
                                  );
                                } else if (item.serviceType == 'Publikasi') {
                                  showPublicationDetailPopup(context, item.rawData ?? {});
                                } else if (item.serviceType == 'Infografis') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => InfografisDetail(
                                        img: item.imageUrl ?? '',
                                        title: item.title,
                                        description: '',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Card(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      if (item.imageUrl != null)
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.network(
                                            item.imageUrl!,
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => Container(
                                              width: 80,
                                              height: 80,
                                              color: Colors.grey[300],
                                              child: const Icon(Icons.broken_image),
                                            ),
                                          ),
                                        )
                                      else
                                        Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Icon(Icons.image, size: 40, color: Colors.grey),
                                        ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(item.title,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold, fontSize: 16)),
                                            const SizedBox(height: 4),
                                            if (item.date != null)
                                              Text(item.date!,
                                                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                            const SizedBox(height: 4),
                                            Chip(label: Text(item.serviceType)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}