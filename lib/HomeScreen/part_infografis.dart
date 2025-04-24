import 'package:flutter/material.dart';
import '../net/network.dart';

class PartInfografis extends StatefulWidget {
  const PartInfografis({super.key});

  @override
  State<PartInfografis> createState() => _PartInfografisState();
}

class _PartInfografisState extends State<PartInfografis> {
  List<Map<String, dynamic>> infographicList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadInfographics();
  }

  Future<void> loadInfographics() async {
    final data =
        await fetchInfographicData(); // sesuai dengan yang ada di network.dart
    setState(() {
      infographicList = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Judul dan Tombol
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 16), // Tambahkan padding di sini
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
                  // Aksi tombol "lainnya"
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[700],
                ),
                child: const Text("Lihat Semua"),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Horizontal scroll
        isLoading
            ? const Center(child: CircularProgressIndicator())
            : SizedBox(
                height: 180,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                      horizontal:
                          16), // Agar isi scroll juga punya padding kiri-kanan
                  scrollDirection: Axis.horizontal,
                  itemCount: infographicList.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final infographic = infographicList[index];
                    final rawUrl = infographic['img'];
                    final imgUrl = rawUrl
                        .toString()
                        .replaceAll(r'\/', '/')
                        .replaceAll(r'\\', '');

                    return AspectRatio(
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
                    );
                  },
                ),
              ),
      ],
    );
  }
}
