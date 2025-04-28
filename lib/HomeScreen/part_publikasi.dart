import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main_screen.dart';
import '../publikasi/detail/publikasi_detail.dart'; // Import detail popup

class PartPublikasi extends StatefulWidget {
  const PartPublikasi({super.key});

  @override
  State<PartPublikasi> createState() => _PartPublikasiState();
}

class _PartPublikasiState extends State<PartPublikasi> {
  List<Map<String, dynamic>> publikasiList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPublikasi();
  }

  Future<void> fetchPublikasi() async {
    final url = Uri.parse(
      'https://webapi.bps.go.id/v1/api/list/model/publication/lang/ind/domain/3373/key/91e4d5e9c5a13e1b6214a14f037956de/',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] is List && data['data'].length > 1) {
          final List<dynamic> rawList = data['data'][1];
          setState(() {
            publikasiList =
                rawList.cast<Map<String, dynamic>>().take(3).toList();
            isLoading = false;
          });
        } else {
          throw Exception("Format data tidak valid");
        }
      } else {
        throw Exception("Gagal memuat publikasi");
      }
    } catch (e) {
      debugPrint("Gagal mengambil data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul + Lihat lainnya
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(width: 4, height: 20, color: Colors.blue),
                  const SizedBox(width: 6),
                  Text(
                    'Publikasi',
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
                      builder: (_) => const MainScreen(initialIndex: 3),
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
              : Column(
                  children: publikasiList.map((item) {
                    return GestureDetector(
                      onTap: () {
                        showPublicationDetailPopup(context, item);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F9F9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                item['cover'] ?? '',
                                width: 72,
                                height: 96,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image, size: 72),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'] ?? '',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item['abstract'] ?? '',
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 11.5,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item['pub_year'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }
}

