import 'package:flutter/material.dart';
import 'detail/publikasi_detail.dart';

class PublikasiGrid extends StatelessWidget {
  final List<Map<String, dynamic>> publications;
  final ScrollController scrollController;

  const PublikasiGrid(
      {required this.publications, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.90,
      ),
      itemCount: publications.length,
      itemBuilder: (context, index) {
        final publication = publications[index];
        return GestureDetector(
          onTap: () {
            showPublicationDetailPopup(context, publication);
          },
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.only(bottom: 10),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    publication['title']?.toString() ?? "No Title",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      publication['rl_date']?.toString() ?? "Tanggal tidak tersedia",
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ),
                ),
                SizedBox(height: 4),
                // Batasi tinggi gambar agar tidak melebihi ruang
                Container(
                  height: 100, // Tinggi gambar yang tetap
                  child: Image.network(
                    publication['cover'] ?? "",
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(height: 100, color: Colors.grey[300]),
                  ),
                ),
                // Menambahkan Expanded untuk membuat ruang fleksibel
                Expanded(
                  child: SizedBox.shrink(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
