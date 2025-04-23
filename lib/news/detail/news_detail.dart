import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart';
import '../../main_screen.dart';

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
      backgroundColor: const Color.fromARGB(255, 255, 246, 246),
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
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => MainScreen(initialIndex: 4)),
                            (route) => false,
                          );
                        },
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cleanNewsContent(newsDetail!['news'] ?? ""),
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontSize: 16,
                                  height: 1.6,
                                  color: Colors.black87),
                            ),
                            SizedBox(height: 20),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(
                                    255, 0, 144, 221), // Warna latar belakang
                                borderRadius: BorderRadius.circular(
                                    8), // Border agar tidak terlalu kaku
                              ),
                              child: Center(
                                child: Text(
                                  "Related News",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors
                                        .white70, // Warna teks lebih kontras
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 180,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: relatedNews.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: NewsCard(
                                      news: relatedNews[index],
                                      onTap: () {
                                        Navigator.push(
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

    TextStyle titleStyle = TextStyle(
        color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold);

    // Menggunakan TextPainter untuk menghitung jumlah baris
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: title, style: titleStyle),
      maxLines: 2,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 144); // Sesuaikan dengan lebar card

    bool isSingleLine = textPainter.didExceedMaxLines ==
        false; // Jika tidak lebih dari satu baris

    return InkWell(
      onTap: onTap,
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 5, spreadRadius: 2)
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Image.network(
                news['picture'] ?? '',
                width: 160,
                height: 110,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: 160,
                  padding: EdgeInsets.all(8),
                  color: Colors.black.withOpacity(0.7),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: titleStyle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                          height: isSingleLine
                              ? 20
                              : 4), // Tambahkan lebih banyak jarak jika satu baris
                      Text(
                        date,
                        style: TextStyle(color: Colors.white70, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
