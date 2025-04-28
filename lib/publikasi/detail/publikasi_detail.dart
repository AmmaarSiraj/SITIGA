import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void showPublicationDetailPopup(
    BuildContext context, Map<String, dynamic> publication) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Tombol close
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),

                const SizedBox(height: 4),

                // Judul
                Text(
                  publication['title'] ?? "Judul Tidak Tersedia",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Cover dan info
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: 100,
                        height: 140,
                        child: Image.network(
                          publication['cover'] ?? "",
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, size: 80),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "Tanggal Rilis: ${publication['rl_date'] ?? '-'}"),
                          const SizedBox(height: 4),
                          Text(
                              "Nomor Katalog: ${publication['kat_no'] ?? '-'}"),
                          const SizedBox(height: 4),
                          Text(
                              "Nomor Publikasi: ${publication['pub_no'] ?? '-'}"),
                          const SizedBox(height: 4),
                          Text("Ukuran File: ${publication['size'] ?? '-'}"),
                          const SizedBox(height: 4),
                          Text("ISSN/ISBN: ${publication['issn'] ?? '-'}"),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Abstrak
                Text(
                  publication['abstract'] ?? "Tidak ada abstrak yang tersedia.",
                  textAlign: TextAlign.justify,
                  style: const TextStyle(fontSize: 13),
                ),

                const SizedBox(height: 20),

                // Tombol Unduh
                ElevatedButton(
                  onPressed: () async {
                    final pdfUrl = Uri.parse(publication['pdf'] ?? "");
                    if (await canLaunchUrl(pdfUrl)) {
                      await launchUrl(pdfUrl,
                          mode: LaunchMode.externalApplication);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Gagal membuka tautan PDF')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("UNDUH"),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
