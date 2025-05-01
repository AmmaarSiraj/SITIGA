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
  int currentPage = 1;
  bool hasMore = true;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.query;
    _fetchNews(currentPage);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          !isLoading &&
          hasMore) {
        _fetchNews(currentPage);
      }
    });
  }

  Future<void> _fetchNews(int page) async {
    setState(() => isLoading = true);
    try {
      final fetchedNews = await NewsService.fetchNews(page);

      if (fetchedNews.isEmpty) {
        if (mounted) setState(() => hasMore = false);
      } else {
        if (mounted) {
          setState(() {
            allNews.addAll(fetchedNews);
            _applyFilter(_searchController.text);
            currentPage++;
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print("Fetch error: $e");
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _applyFilter(String query) {
    final filtered = allNews
        .where((item) => item['title']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();
    setState(() => filteredNews = filtered);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _applyFilter(query);
  }

  @override
  Widget build(BuildContext context) {
    // Use scaffold background for both header and body
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
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search news...',
              hintStyle: TextStyle(color: Colors.grey[600]),
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            ),
            onChanged: _onSearchChanged,
          ),
        ),
      ),
      body: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        itemCount: filteredNews.length + (isLoading ? 1 : 0),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.90,
        ),
        itemBuilder: (context, index) {
          if (index == filteredNews.length) {
            return const Center(child: CircularProgressIndicator());
          }

          final item = filteredNews[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      NewsDetailScreen(newsId: item['news_id'].toString()),
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
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
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