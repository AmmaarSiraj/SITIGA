import 'package:flutter/material.dart';
import 'detail/news_detail.dart';
import '../components/appbar.dart';
import './news_service.dart';
import 'news_header.dart';
import '../components/next_page.dart';
import './filter_news.dart';

class NewsListScreen extends StatefulWidget {
  @override
  _NewsListScreenState createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  Map<int, List<Map<String, dynamic>>> cachedNews = {};
  List<Map<String, dynamic>> newsList = [];
  bool isLoading = true;
  int currentPage = 1;
  int totalPages = 1;
  final int itemsPerPage = 10;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchNews(currentPage);
  }

  Future<void> fetchNews(int page) async {
    if (cachedNews.containsKey(page)) {
      setState(() {
        newsList = cachedNews[page]!;
        isLoading = false;
      });
      return;
    }

    try {
      final fetchedList = await NewsService.fetchNews(page);
      cachedNews[page] = fetchedList;

      final totalCount = 190; // ideally from API
      setState(() {
        newsList = fetchedList;
        totalPages = (totalCount / itemsPerPage).ceil();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print("Error fetching data: $e");
    }
  }

  void changePage(int page) {
    setState(() {
      currentPage = page;
      isLoading = true;
    });
    fetchNews(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                NewsHeader(
                  currentPage: currentPage,
                  totalPages: totalPages,
                  onPageChanged: changePage,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FilterNewsScreen(query: ''),
                        ),
                      );
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search news...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            childAspectRatio: 0.90,
                          ),
                          itemCount: newsList.length,
                          itemBuilder: (context, index) {
                            final item = newsList[index];
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
                        const SizedBox(height: 20),
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
