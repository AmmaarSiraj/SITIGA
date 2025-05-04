import 'package:flutter/material.dart';
import 'detail/news_detail.dart';
import './news_service.dart';

class FilterNewsScreen extends StatefulWidget {
  final String query;

  const FilterNewsScreen({Key? key, required this.query}) : super(key: key);

  @override
  _FilterNewsScreenState createState() => _FilterNewsScreenState();
}

class _FilterNewsScreenState extends State<FilterNewsScreen> {
  List<Map<String, dynamic>> allNews = [];
  List<Map<String, dynamic>> filteredNews = [];
  bool isLoading = false;
  bool isSearchComplete = false; // Track if search is completed
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.query;
    if (widget.query.isNotEmpty) {
      _fetchAllNewsGlobal(widget.query);
    }

    // Listen to changes in the search input
    _searchController.addListener(() {
      if (_searchController.text.isEmpty) {
        setState(() {
          isSearchComplete = false; // Reset icon to search when query is cleared
        });
      }
    });
  }

  Future<void> _fetchAllNewsGlobal(String query) async {
    setState(() {
      allNews.clear();
      filteredNews.clear();
      isLoading = true;
      isSearchComplete = false; // Reset icon to search while fetching
    });

    int page = 1;
    bool hasMore = true;

    while (hasMore && mounted) {
      try {
        final fetched = await NewsService.fetchNews(page);
        if (fetched.isEmpty) {
          hasMore = false;
        } else {
          allNews.addAll(fetched);
          final newlyFiltered = fetched
              .where((item) => item['title']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
              .toList();
          setState(() {
            filteredNews.addAll(newlyFiltered);
          });
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
        isSearchComplete = true; // Mark search as complete after data is loaded
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
                    hintText: 'Search news...',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  ),
                  onSubmitted: (query) {
                    final trimmedQuery = query.trim();
                    if (trimmedQuery.isNotEmpty) {
                      _fetchAllNewsGlobal(trimmedQuery);
                    } else {
                      setState(() {
                        allNews.clear();
                        filteredNews.clear();
                        isSearchComplete = false; // Reset to search icon
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
                      : const Icon(Icons.search, color: Colors.black),
              onPressed: () {
                final query = _searchController.text.trim();
                if (query.isNotEmpty) {
                  _fetchAllNewsGlobal(query);
                } else {
                  setState(() {
                    allNews.clear();
                    filteredNews.clear();
                    isSearchComplete = false; // Reset to search icon
                  });
                }
              },
            ),
          ],
        ),
      ),
      body: isLoading && filteredNews.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : filteredNews.isEmpty
              ? const Center(
                  child: Text('Masukkan kata kunci untuk mencari berita.'),
                )
              : GridView.builder(
                  controller: _scrollController,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  itemCount: filteredNews.length,
                  gridDelegate:
                      const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.90,
                  ),
                  itemBuilder: (context, index) {
                    final item = filteredNews[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewsDetailScreen(
                              newsId: item['news_id'].toString(),
                            ),
                          ),
                        );
                      },
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
                              child: item['picture'] != null
                                  ? Image.network(
                                      item['picture'],
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (ctx, err, st) =>
                                          Container(color: Colors.grey[300]),
                                    )
                                  : Container(color: Colors.grey[300]),
                            ),
                            const SizedBox(height: 4),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                item['rl_date']?.toString() ?? "Unknown Date",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
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