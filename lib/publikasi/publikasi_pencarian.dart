import 'package:flutter/material.dart';
import '../publikasi/detail/publikasi_detail.dart';
import './publikasi_service.dart';

class PencarianPublikasiScreen extends StatefulWidget {
  final String query;

  const PencarianPublikasiScreen({Key? key, required this.query}) : super(key: key);

  @override
  _PencarianPublikasiScreenState createState() => _PencarianPublikasiScreenState();
}

class _PencarianPublikasiScreenState extends State<PencarianPublikasiScreen> {
  List<Map<String, dynamic>> allPublications = [];
  List<Map<String, dynamic>> filteredPublications = [];
  bool isLoading = false;
  bool isSearchComplete = false;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.query;
    if (widget.query.isNotEmpty) {
      _fetchAllPublications(widget.query);
    }

    _searchController.addListener(() {
      if (_searchController.text.isEmpty) {
        setState(() => isSearchComplete = false);
      }
    });
  }

  Future<void> _fetchAllPublications(String query) async {
    setState(() {
      allPublications.clear();
      filteredPublications.clear();
      isLoading = true;
      isSearchComplete = false;
    });

    int page = 1;
    bool hasMore = true;

    while (hasMore && mounted) {
      try {
        final fetched = await PublikasiService.fetchPublications(page);
        if (fetched.isEmpty) {
          hasMore = false;
        } else {
          allPublications.addAll(fetched);
          final matched = fetched
              .where((item) => item['title']?.toLowerCase().contains(query.toLowerCase()) ?? false)
              .toList();

          setState(() => filteredPublications.addAll(matched));
          page++;
        }
      } catch (e) {
        print("Fetch error: $e");
        hasMore = false;
      }
    }

    if (mounted) {
      setState(() {
        isLoading = false;
        isSearchComplete = true;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          color: Colors.black,
        ),
        title: Row(
          children: [
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Pencarian publikasi...',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  ),
                  onSubmitted: (query) {
                    final trimmedQuery = query.trim();
                    if (trimmedQuery.isNotEmpty) {
                      _fetchAllPublications(trimmedQuery);
                    } else {
                      setState(() {
                        allPublications.clear();
                        filteredPublications.clear();
                        isSearchComplete = false;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: isLoading
                  ? const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    )
                  : isSearchComplete
                      ? const Icon(Icons.check, color: Colors.green)
                      : const Icon(Icons.send, color: Colors.black),
              onPressed: () {
                final query = _searchController.text.trim();
                if (query.isNotEmpty) {
                  _fetchAllPublications(query);
                } else {
                  setState(() {
                    allPublications.clear();
                    filteredPublications.clear();
                    isSearchComplete = false;
                  });
                }
              },
            ),
          ],
        ),
      ),
      body: isLoading && filteredPublications.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : filteredPublications.isEmpty
              ? const Center(child: Text(''))
              : GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  itemCount: filteredPublications.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.90,
                  ),
                  itemBuilder: (context, index) {
                    final item = filteredPublications[index];
                    return GestureDetector(
                      onTap: () => showPublicationDetailPopup(context, item),
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: item['cover'] != null
                                  ? Image.network(
                                      item['cover'],
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (ctx, err, st) => Container(color: Colors.grey[300]),
                                    )
                                  : Container(color: Colors.grey[300]),
                            ),
                            const SizedBox(height: 4),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                item['rl_date']?.toString() ?? "Unknown Date",
                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                item['title']?.toString() ?? "No Title",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
