import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void showPublicationDetailPopup(
    BuildContext context, Map<String, dynamic> publication) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.all(8),
        child: PublicationDetailContent(publication: publication),
      );
    },
  );
}

class PublicationDetailContent extends StatefulWidget {
  final Map<String, dynamic> publication;

  const PublicationDetailContent({super.key, required this.publication});

  @override
  State<PublicationDetailContent> createState() =>
      _PublicationDetailContentState();
}

class _PublicationDetailContentState extends State<PublicationDetailContent> {
  List<dynamic> relatedPublications = [];

  @override
  void initState() {
    super.initState();
    fetchRelatedPublications();
  }

  Future<void> fetchRelatedPublications() async {
    final response = await http.get(Uri.parse(
        'https://webapi.bps.go.id/v1/api/list/model/publication/lang/ind/domain/3373/key/91e4d5e9c5a13e1b6214a14f037956de/'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        relatedPublications = data['data'] ?? [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final publication = widget.publication;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),

            Image.network(
              publication['cover'] ?? '',
              height: 180,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 100),
            ),

            const SizedBox(height: 12),

            Text(
              publication['title'] ?? 'Judul Tidak Tersedia',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                infoText("Nomor Katalog", publication['kat_no']),
                infoText("Nomor Publikasi", publication['pub_no']),
                infoText("ISSN/ISBN", publication['issn']),
                infoText("Tanggal Rilis", publication['rl_date']),
                infoText("Tanggal Update", publication['update_date']),
                infoText("Ukuran File", publication['size']),
              ],
            ),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Abstrak",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              publication['abstract'] ?? 'Tidak ada abstrak yang tersedia.',
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 13),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                final Uri pdfUrl = Uri.parse(publication['pdf'] ?? '');
                if (await canLaunchUrl(pdfUrl)) {
                  await launchUrl(pdfUrl);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Unduh"),
            ),

            const SizedBox(height: 12),

            // Share button without icon
            OutlinedButton(
              onPressed: () {},
              child: const Text("Bagikan"),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              color: Colors.blue.shade800,
              child: const Text(
                "Publikasi Terkait",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: relatedPublications.length,
              itemBuilder: (context, index) {
                final item = relatedPublications[index];
                return ListTile(
                  leading: Image.network(
                    item['cover'] ?? '',
                    width: 50,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image),
                  ),
                  title: Text(
                    item['title'] ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(item['rl_date'] ?? ''),
                  onTap: () {
                    Navigator.of(context).pop(); // close current
                    showPublicationDetailPopup(context, item); // open new
                  },
                );
              },
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget infoText(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text("$label :")),
          Expanded(flex: 5, child: Text(value ?? '-')),
        ],
      ),
    );
  }
}
