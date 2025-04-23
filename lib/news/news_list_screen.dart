import 'package:flutter/material.dart';
import 'detail/news_detail.dart';
import '../components/appbar.dart';
import './news_service.dart';

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
  bool isDarkMode = false;
  String selectedLanguage = 'IDN';

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

    setState(() {
      newsList = fetchedList;
      totalPages = (fetchedList.length / itemsPerPage).ceil(); // bisa disesuaikan
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
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: (newsList.length / 2).ceil() + 1, // +1 for pagination
              itemBuilder: (context, index) {
                if (index < (newsList.length / 2).ceil()) {
                  final firstIndex = index * 2;
                  final secondIndex = firstIndex + 1;

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Row(
                      children: [
                        // First card
                        Expanded(
                          child: NewsCard(
                            news: newsList[firstIndex],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NewsDetailScreen(
                                    newsId: newsList[firstIndex]['news_id']
                                        .toString(),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 8),
                        // Second card, check if exists
                        Expanded(
                          child: secondIndex < newsList.length
                              ? NewsCard(
                                  news: newsList[secondIndex],
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NewsDetailScreen(
                                          newsId: newsList[secondIndex]
                                                  ['news_id']
                                              .toString(),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Container(),
                        ),
                      ],
                    ),
                  );
                } else {
                  // Pagination bar
                  return Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: currentPage > 1
                              ? () => changePage(currentPage - 1)
                              : null,
                        ),
                        Text("Page $currentPage of $totalPages"),
                        IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: currentPage < totalPages
                              ? () => changePage(currentPage + 1)
                              : null,
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final Map<String, dynamic> news;
  final VoidCallback? onTap;

  const NewsCard({required this.news, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: Colors.white, // Bisa diubah kalau mau transparan/beda
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            news['picture'] != null
                ? ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      news['picture'],
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                  ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news['title']?.toString() ?? "No Title",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    news['rl_date']?.toString() ?? "Unknown Date",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Spacer(),
                      Icon(Icons.share, size: 16, color: Colors.grey),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}