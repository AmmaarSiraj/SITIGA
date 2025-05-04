import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart';

class NewsDetailScreen extends StatefulWidget {
  final String newsId;

  NewsDetailScreen({required this.newsId});

  @override
  _NewsDetailScreenState createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  Map<String, dynamic>? newsDetail;
  List<dynamic> relatedNews = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNewsDetail();
  }

  Future<void> fetchNewsDetail() async {
    final apiUrl =
        "https://webapi.bps.go.id/v1/api/view/domain/3373/model/news/lang/ind/id/${widget.newsId}/key/91e4d5e9c5a13e1b6214a14f037956de/";

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          newsDetail = data['data'];
          relatedNews = data['data']['related'] ?? [];
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
      print("Error fetching news detail: $e");
    }
  }

  String cleanNewsContent(String content) {
    var document = parse(content);
    document.querySelectorAll('a').forEach((element) {
      element.remove();
    });
    String parsedText = document.body?.text ?? "";
    return parsedText
        .replaceAll(
            RegExp(r"</?(span|p|style|a|o:p|i|li|ul|font|div)[^>]*>"), "")
        .replaceAll(RegExp(r"&nbsp;|&amp;|&lt;|&gt;"), " ")
        .replaceAll(RegExp(r"\s*\n\s*"), "\n")
        .replaceAll(RegExp(r"\n{3,}"), "\n\n")
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : newsDetail == null
              ? Center(child: Text("Failed to load news details"))
              : CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      backgroundColor: Colors.transparent,
                      expandedHeight: 220,
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text(
                          newsDetail!['title'] ?? "",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            shadows: [
                              Shadow(
                                blurRadius: 5,
                                color: Colors.black.withOpacity(0.7),
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              newsDetail!['picture'] ?? '',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(color: Colors.grey[300]);
                              },
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(0.6),
                                    Colors.transparent
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // --- Konten berita utama ---
                            Text(
                              cleanNewsContent(newsDetail!['news'] ?? ""),
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.8,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 30),

                            // --- Related News header ---
                            Row(
                              children: [
                                Icon(Icons.newspaper,
                                    color: Color.fromARGB(255, 0, 144, 221)),
                                SizedBox(width: 8),
                                Text(
                                  "Berita Terkait",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),

                            // --- Related News Cards ---
                            Container(
                              height: 200,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: relatedNews.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: NewsCard(
                                      news: relatedNews[index],
                                      onTap: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                NewsDetailScreen(
                                              newsId: relatedNews[index]
                                                      ['news_id']
                                                  .toString(),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
    String title = news['title'] ?? 'No Title';
    String date = news['rl_date'] ?? 'Unknown Date';

    return InkWell(
      onTap: onTap,
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                news['picture'] ?? '',
                width: 160,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 100,
                    color: Colors.grey[300],
                  );
                },
              ),
            ),
            // Konten Teks
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
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