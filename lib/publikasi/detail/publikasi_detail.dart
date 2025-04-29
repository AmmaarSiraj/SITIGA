import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void showPublicationDetailPopup(BuildContext context, Map<String, dynamic> publication) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    publication['title'] ?? "Judul Tidak Tersedia",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 200,
                      child: Image.network(
                        publication['cover'] ?? "",
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Tanggal Rilis: ${publication['rl_date'] ?? '-'}"),
                          Text("Nomor Katalog: ${publication['kat_no'] ?? '-'}"),
                          Text("Nomor Publikasi: ${publication['pub_no'] ?? '-'}"),
                          Text("Ukuran File: ${publication['size'] ?? '-'}"),
                          Text("ISSN/ISBN: ${publication['issn'] ?? '-'}"),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Text(
                      publication['abstract'] ?? "Tidak ada abstrak yang tersedia.",
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      final Uri pdfUrl = Uri.parse(publication['pdf'] ?? "");
                      if (await canLaunchUrl(pdfUrl)) {
                        await launchUrl(pdfUrl);
                      }
                    },
                    child: Text("UNDUH"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
