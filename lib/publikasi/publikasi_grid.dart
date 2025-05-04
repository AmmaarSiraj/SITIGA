import 'package:flutter/material.dart';
import 'detail/publikasi_detail.dart'; // Assuming this is where the detail screen is defined

class PublikasiGrid extends StatelessWidget {
  final List<Map<String, dynamic>> publications;
  final ScrollController scrollController;

  const PublikasiGrid(
      {required this.publications, required this.scrollController});

  // Define the function to show the publication detail popup
  void showPublicationDetailPopup(BuildContext context, Map<String, dynamic> publication) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(publication['title'] ?? 'No Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  publication['description'] ?? 'No Description Available',
                  style: TextStyle(fontSize: 14, height: 1.5),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

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
                // Use Expanded widget to make the image fill available space
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
