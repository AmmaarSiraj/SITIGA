import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html_unescape/html_unescape.dart';
import 'package:url_launcher/url_launcher.dart';
import 'html_table_page.dart'; // << Tambahan: import halaman tabel HTML

class TabelDetailPage extends StatefulWidget {
  final int tableId;

  const TabelDetailPage({Key? key, required this.tableId}) : super(key: key);

  @override
  State<TabelDetailPage> createState() => _TabelDetailPageState();
}

class _TabelDetailPageState extends State<TabelDetailPage> {
  late Future<Map<String, dynamic>> _tabelData;

  @override
  void initState() {
    super.initState();
    _tabelData = fetchTabelData(widget.tableId);
  }

  Future<Map<String, dynamic>> fetchTabelData(int id) async {
    final response = await http.get(
      Uri.parse(
        'https://webapi.bps.go.id/v1/api/view/domain/3373/model/statictable/lang/ind/id/$id/key/91e4d5e9c5a13e1b6214a14f037956de/',
      ),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['data'];
    } else {
      throw Exception('Gagal memuat data tabel');
    }
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url.replaceAll(r"\/", "/"));
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Tidak bisa membuka URL: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Tabel"),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _tabelData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
          }

          final data = snapshot.data!;
          final unescape = HtmlUnescape();
          final htmlContent = unescape.convert(data['table']);
          final title = data['title'] ?? 'Judul Tidak Diketahui';
          final kategori = data['subcsa'] ?? 'Kategori Tidak Diketahui';
          final crDate = data['cr_date'] ?? 'Tidak diketahui';
          final updtDate = data['updt_date'] ?? 'Tidak diketahui';
          final excelUrl = data['excel'] ?? '';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                Text("Kategori: $kategori", style: TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 10),
                Text("Tanggal dibuat: $crDate"),
                Text("Terakhir diperbarui: $updtDate"),
                const SizedBox(height: 10),
                if (excelUrl.isNotEmpty)
                  ElevatedButton.icon(
                    onPressed: () => _launchURL(excelUrl),
                    icon: const Icon(Icons.download),
                    label: const Text("Unduh Excel"),
                  ),
                const SizedBox(height: 20),

                // Tombol navigasi ke halaman tampilan tabel HTML
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HtmlTablePage(rawTableHtml: htmlContent),
                      ),
                    );
                  },
                  icon: const Icon(Icons.table_chart),
                  label: const Text("Lihat Tabel Lengkap"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
