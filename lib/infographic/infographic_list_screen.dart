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
import '../infographic/infografis_header.dart';
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
    )..layout(
        maxWidth:
            MediaQuery.of(context).size.width - 32); // 16 padding kiri + kanan

    if (textPainter.didExceedMaxLines) {
      setState(() {
        showExpandButton = true;
      });
    }
  }

  String cleanDescription(String text) {
    return text.replaceAll(RegExp(r'<\/?p>'), '').trim();
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
