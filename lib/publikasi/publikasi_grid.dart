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
  clipBehavior: Clip.antiAlias,
  child: Column(
    // biarkan Column mengisi seluruh tinggi cell
    mainAxisSize: MainAxisSize.max,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          publication['title']?.toString() ?? "No Title",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
      const SizedBox(height: 4),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          publication['rl_date']?.toString() ?? "Tanggal tidak tersedia",
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ),
      const SizedBox(height: 4),
      // Ganti fixed-height Container dengan Expanded
      Expanded(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
          child: Image.network(
            publication['cover'] ?? "",
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (ctx, err, st) =>
                Container(color: Colors.grey[300]),
          ),
        ),
      ),
    ],
  ),
),


        );
      },
    );
  }
}