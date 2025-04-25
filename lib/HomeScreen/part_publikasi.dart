import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../publikasi/publikasi_screen.dart';
import '../publikasi/detail/publikasi_detail.dart';

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
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24), // Atas = 0
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24), // Tambahkan spasi atas
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(width: 4, height: 24, color: Colors.blue),
                  const SizedBox(width: 8),
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
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: publikasiList.map((item) {
                    return GestureDetector(
                      onTap: () {
                        showPublicationDetailPopup(context, item);
                      },
                      child: Container(
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
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
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
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'] ?? '',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    item['abstract'] ?? '',
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Tahun ${item['pub_year'] ?? ''}',
                                    style: const TextStyle(
                                      fontSize: 12,
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
