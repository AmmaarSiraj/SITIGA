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
<<<<<<< HEAD
import '../infographic/infografis_header.dart';
=======
>>>>>>> 6848fdb5d042b3187a6ab30d123ccc3dbf5f0965
import '../components/next_page.dart';

class InfographicListScreen extends StatefulWidget {
  @override
  _InfographicListScreenState createState() => _InfographicListScreenState();
}

class _InfographicListScreenState extends State<InfographicListScreen> {
  int currentPage = 1;
  final int itemsPerPage = 10;
  final ScrollController _scrollController = ScrollController();

  void changePage(int page) {
    setState(() {
      currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    final allInfographics = dataProvider.allInfographics;
    final isLoading = dataProvider.isLoading;

    final totalPages = (allInfographics.length / itemsPerPage).ceil();

    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = (startIndex + itemsPerPage).clamp(0, allInfographics.length);
    final pagedInfographics = allInfographics.sublist(startIndex, endIndex);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
<<<<<<< HEAD
                InfografisHeader(
                  currentPage: currentPage,
                  totalPages: totalPages,
                  onPageChanged: changePage,
                ),
                Expanded(
  child: SingleChildScrollView(
    controller: _scrollController,
    child: Column(
      children: [
        ...pagedInfographics.map((infographic) => InfographicCard(
              img: infographic['img'],
              title: infographic['title']?.toString() ?? "No Title",
              description: infographic['desc']?.toString() ?? "No Description",
            )),
        const SizedBox(height: 20),
        NextPage(
          currentPage: currentPage,
          totalPages: totalPages,
          onPageChanged: changePage,
          scrollController: _scrollController,
        ),
        const SizedBox(height: 20),
      ],
    ),
  ),
),
  ],
=======
                Container(
                  color: const Color(0xFFFFF6F6),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(width: 5, height: 40, color: Colors.blue),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Infografis",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.location_on, size: 18, color: Colors.grey[700]),
                                  const SizedBox(width: 4),
                                  const Text(
                                    "BPS Kota Salatiga",
                                    style: TextStyle(fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      DropdownButton<int>(
                        value: currentPage,
                        icon: const Icon(Icons.arrow_drop_down),
                        onChanged: (int? newPage) {
                          if (newPage != null) changePage(newPage);
                          _scrollController.animateTo(
                            0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        },
                        items: List.generate(totalPages, (index) {
                          int pageNumber = index + 1;
                          return DropdownMenuItem(
                            value: pageNumber,
                            child: Text('Halaman $pageNumber'),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(bottom: 16),
                          itemCount: pagedInfographics.length,
                          itemBuilder: (context, index) {
                            final infographic = pagedInfographics[index];
                            return InfographicCard(
                              img: infographic['img'],
                              title: infographic['title']?.toString() ?? "No Title",
                              description: infographic['desc']?.toString() ?? "No Description",
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        NextPage(
                          currentPage: currentPage,
                          totalPages: totalPages,
                          onPageChanged: (page) {
                            changePage(page);
                          },
                          scrollController: _scrollController,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
>>>>>>> 6848fdb5d042b3187a6ab30d123ccc3dbf5f0965
            ),
    );
  }
}

class InfographicCard extends StatefulWidget {
  final String img;
  final String title;
  final String description;

  const InfographicCard({
    Key? key,
    required this.img,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  State<InfographicCard> createState() => _InfographicCardState();
}

class _InfographicCardState extends State<InfographicCard> {
  bool isExpanded = false;
  bool showExpandButton = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkDescriptionLength();
    });
  }

  void checkDescriptionLength() {
    final textPainter = TextPainter(
      text: TextSpan(
        text: cleanDescription(widget.description),
        style: const TextStyle(fontSize: 13),
      ),
      maxLines: 2,
      textDirection: TextDirection.ltr,
<<<<<<< HEAD
    )..layout(
        maxWidth:
            MediaQuery.of(context).size.width - 32); // 16 padding kiri + kanan
=======
    )..layout(maxWidth: MediaQuery.of(context).size.width - 32);
>>>>>>> 6848fdb5d042b3187a6ab30d123ccc3dbf5f0965

    if (textPainter.didExceedMaxLines) {
      setState(() {
        showExpandButton = true;
      });
    }
  }

  String cleanDescription(String text) {
<<<<<<< HEAD
    return text.replaceAll(RegExp(r'<\/?p>'), '').trim();
=======
    return text.replaceAll(RegExp(r'<\/?.*?>'), '').trim();
>>>>>>> 6848fdb5d042b3187a6ab30d123ccc3dbf5f0965
  }

  Future<void> downloadImage(BuildContext context, String imgUrl) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final tempDir = await getTemporaryDirectory();
      final filePath =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final response = await http.get(Uri.parse(imgUrl));
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      await GallerySaver.saveImage(file.path).then((bool? success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success == true
                ? 'Gambar berhasil disimpan!'
                : 'Gagal menyimpan gambar.'),
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Izin penyimpanan ditolak.')),
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
                  img: widget.img,
                  title: widget.title,
                  description: widget.description,
                ),
              ),
            );
          },
          child: Image.network(
            widget.img,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(Icons.broken_image, size: 80, color: Colors.grey)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                cleanDescription(widget.description),
                style: TextStyle(color: Colors.grey[700], fontSize: 13),
                maxLines: isExpanded ? null : 2,
                overflow:
                    isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              ),
              if (showExpandButton)
                TextButton(
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child: Text(
                    isExpanded ? 'Sembunyikan' : 'Lebih Banyak',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.download, size: 20),
                  onPressed: () => downloadImage(context, widget.img),
                ),
              ),
            ],
          ),
        ),
        const Divider(thickness: 1, height: 24),
      ],
    );
  }
}
