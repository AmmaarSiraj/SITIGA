import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/data_provider.dart'; // Pastikan di-import
import '../main_screen.dart';
import '../infographic/detail/infographic_detail.dart';

class PartInfografis extends StatelessWidget {
  const PartInfografis({super.key});

  @override
  Widget build(BuildContext context) {
    final infographicList = Provider.of<DataProvider>(context).allInfographics;

    if (infographicList.isEmpty) {
      return const Center(child: CircularProgressIndicator()); // Loading kecil kalau datanya belum ada
    }

    final top5Infographics = infographicList.take(5).toList(); // Ambil 5 teratas

    return Column(
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(width: 4, height: 24, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(
                    "Infografis Terbaru",
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
                      builder: (_) => const MainScreen(initialIndex: 1),
                    ),
                  );
                },
                child: const Text("Lihat Semua"),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: top5Infographics.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final infographic = top5Infographics[index];
              final rawUrl = infographic['img'];
              final imgUrl = rawUrl
                  .toString()
                  .replaceAll(r'\/', '/')
                  .replaceAll(r'\\', '');

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InfografisDetail(
                        img: imgUrl,
                        title: infographic['title'] ?? '-',
                        description: infographic['description'] ?? '-',
                      ),
                    ),
                  );
                },
                child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: imgUrl.isNotEmpty
                        ? Image.network(
                            imgUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image),
                          )
                        : Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.image_not_supported),
                          ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
