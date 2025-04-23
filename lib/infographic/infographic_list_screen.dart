import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../components/appbar.dart';
import 'detail/infographic_detail.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../providers/data_provider.dart';

class InfographicListScreen extends StatefulWidget {
  @override
  _InfographicListScreenState createState() => _InfographicListScreenState();
}

class _InfographicListScreenState extends State<InfographicListScreen> {
  int currentPage = 1;
  final int itemsPerPage = 10;

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    final allInfographics = dataProvider.allInfographics;
    final isLoading = dataProvider.isLoading;

    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = (startIndex + itemsPerPage);
    final pagedInfographics = allInfographics.sublist(
      startIndex,
      endIndex > allInfographics.length ? allInfographics.length : endIndex,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      body: Column(
        children: [
          Container(
            color: Color(0xFFFFF6F6),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              children: [
                Container(width: 5, height: 40, color: Colors.blue),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Infografis", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("📍 BPS Kota Salatiga", style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: pagedInfographics.length + 1,
                    itemBuilder: (context, index) {
                      if (index == pagedInfographics.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: currentPage > 1
                                    ? () => setState(() => currentPage--)
                                    : null,
                                child: Text("Previous"),
                              ),
                              Text("Page $currentPage"),
                              TextButton(
                                onPressed: currentPage * itemsPerPage < allInfographics.length
                                    ? () => setState(() => currentPage++)
                                    : null,
                                child: Text("Next"),
                              ),
                            ],
                          ),
                        );
                      }
                      final infographic = pagedInfographics[index];
                      return InfographicCard(
                        img: infographic['img'],
                        title: infographic['title']?.toString() ?? "No Title",
                        description: infographic['abstract']?.toString() ?? "No Description",
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class InfographicCard extends StatelessWidget {
  final String img;
  final String title;
  final String description;

  const InfographicCard({
    Key? key,
    required this.img,
    required this.title,
    required this.description,
  }) : super(key: key);

  Future<void> downloadImage(BuildContext context, String imgUrl) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final response = await http.get(Uri.parse(imgUrl));
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      await GallerySaver.saveImage(file.path).then((bool? success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success == true ? 'Gambar berhasil disimpan!' : 'Gagal menyimpan gambar.',
            ),
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Izin penyimpanan ditolak.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => InfografisDetail(
                  img: img,
                  title: title,
                  description: description,
                ),
              ),
            );
          },
          child: Image.network(
            img,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(color: Colors.grey[700], fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(Icons.download, size: 20),
                  onPressed: () => downloadImage(context, img),
                ),
              ),
            ],
          ),
        ),
        Divider(thickness: 1, height: 24),
      ],
    );
  }
}
