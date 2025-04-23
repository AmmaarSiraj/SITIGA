import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class HtmlTablePage extends StatelessWidget {
  final String rawTableHtml;

  const HtmlTablePage({Key? key, required this.rawTableHtml}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("=== RAW HTML ===");
    print(rawTableHtml); // Debug

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tabel Lengkap"),
      ),
      body: rawTableHtml.trim().isEmpty
          ? const Center(child: Text("Data tabel tidak tersedia"))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Html(data: "<div>$rawTableHtml</div>"),
            ),
    );
  }
}
