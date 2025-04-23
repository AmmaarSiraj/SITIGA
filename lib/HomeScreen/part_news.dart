import 'package:flutter/material.dart';
import '../news/detail/news_detail.dart';
import '../main_screen.dart'; // Navigasi ke News tab di MainScreen
import '../net/network.dart'; // Pastikan fetchNews() tersedia di sini

class PartNews extends StatefulWidget {
  const PartNews({super.key});

  @override
  State<PartNews> createState() => _PartNewsState();
}

class _PartNewsState extends State<PartNews> {
  List<Map<String, dynamic>> newsList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadNews();
  }

  Future<void> loadNews() async {
    final data = await fetchNews();
    setState(() {
      newsList = data.take(6).toList(); // Ambil 6 berita teratas
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(width: 4, height: 24, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(
                    "Berita",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MainScreen(initialIndex: 4),
                    ),
                  );
                },
                child: const Text("Lihat Semua"),
              ),
            ],
          ),
          const SizedBox(height: 12),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SizedBox(
                  height: 280,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
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
                        child: Container(
                          width: 220,
                          margin: const EdgeInsets.only(right: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  item['picture'] ?? '',
                                  height: 120,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    height: 120,
                                    color: Colors.grey.shade300,
                                    child:
                                        const Icon(Icons.broken_image_outlined),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                item['title'] ?? '-',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(item['rl_date'] ?? '',
                                  style: const TextStyle(fontSize: 10)),
                              const SizedBox(height: 4),
                              Text(
                                item['news'] ?? '',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
