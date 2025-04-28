import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
<<<<<<< HEAD
import '../publikasi/publikasi_screen.dart';
import '../publikasi/detail/publikasi_detail.dart';
=======
import '../main_screen.dart';
import '../publikasi/detail/publikasi_detail.dart'; // Import detail popup
>>>>>>> f1680d6ce69745b7f39b4191619cb49e214dd591

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
<<<<<<< HEAD
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24), // Atas = 0
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24), // Tambahkan spasi atas
          // Header
=======
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul + Lihat lainnya
>>>>>>> f1680d6ce69745b7f39b4191619cb49e214dd591
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
<<<<<<< HEAD
                  Container(width: 4, height: 24, color: Colors.blue),
                  const SizedBox(width: 8),
=======
                  Container(width: 4, height: 20, color: Colors.blue),
                  const SizedBox(width: 6),
>>>>>>> f1680d6ce69745b7f39b4191619cb49e214dd591
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
<<<<<<< HEAD
                      builder: (_) => PublicationListScreen(),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[700],
                ),
                child: const Text("Lihat lainnya"),
              )
            ],
          ),
          const SizedBox(
              height:
                  12), // Menyesuaikan jarak vertikal antara header dan publikasi
=======
                      builder: (_) => const MainScreen(initialIndex: 3),
                    ),
                  );
                },
                child: const Text("Lihat Semua"),
              ),
            ],
          ),
          const SizedBox(height: 12),

>>>>>>> f1680d6ce69745b7f39b4191619cb49e214dd591
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: publikasiList.map((item) {
                    return GestureDetector(
                      onTap: () {
                        showPublicationDetailPopup(context, item);
                      },
                      child: Container(
<<<<<<< HEAD
                        margin: const EdgeInsets.only(
                            bottom:
                                12), // Menambahkan jarak antar item publikasi
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
=======
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F9F9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
>>>>>>> f1680d6ce69745b7f39b4191619cb49e214dd591
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
<<<<<<< HEAD
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item['cover'] ?? '',
                                width: 60,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image, size: 60),
                              ),
                            ),
                            const SizedBox(width: 12),
=======
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
>>>>>>> f1680d6ce69745b7f39b4191619cb49e214dd591
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'] ?? '',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
<<<<<<< HEAD
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
=======
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
>>>>>>> f1680d6ce69745b7f39b4191619cb49e214dd591
                                  Text(
                                    item['abstract'] ?? '',
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
<<<<<<< HEAD
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Tahun ${item['pub_year'] ?? ''}',
                                    style: const TextStyle(
                                      fontSize: 12,
=======
                                      fontSize: 11.5,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item['pub_year'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 11,
>>>>>>> f1680d6ce69745b7f39b4191619cb49e214dd591
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
<<<<<<< HEAD
}
=======
}
>>>>>>> f1680d6ce69745b7f39b4191619cb49e214dd591
