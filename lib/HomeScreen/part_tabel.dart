import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';

class CategoryGrid extends StatefulWidget {
  const CategoryGrid({Key? key}) : super(key: key);

  @override
  _CategoryGridState createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  List<Map<String, dynamic>> subjects = [];
  bool isLoading = true;

  final List<Map<String, dynamic>> predefinedCategories = [
    {'label': 'Kependudukan'},
    {'label': 'Statistik Bisnis'},
    {'label': 'Kesehatan'},
    {'label': 'Pendidikan'},
    {'label': 'Pariwisata'},
    {'label': 'Lingkungan'},
    {'label': 'Perdagangan'},
    {'icon': Icons.apps, 'label': 'Lainnya'},
  ];

  final List<Color> backgroundColors = [
    Color(0xFFFFF0E0),
    Color(0xFFE0FFE5),
    Color(0xFFE0F7FF),
    Color(0xFFEAE0FF),
    Color(0xFFE8FFE0),
    Color(0xFFE0FFF8),
    Color(0xFFF0F0F0),
    Color(0xFFF5F5F5),
  ];

  final List<Color> iconColors = [
    Color(0xFFFFA726),
    Color(0xFF66BB6A),
    Color(0xFF29B6F6),
    Color(0xFFAB47BC),
    Color(0xFF9CCC65),
    Color(0xFF4DB6AC),
    Color(0xFFBDBDBD),
    Color(0xFF9E9E9E),
  ];

  @override
  void initState() {
    super.initState();
    fetchSubjects();
  }

  Future<void> fetchSubjects() async {
    final int totalPages = 4;
    List<Map<String, dynamic>> allSubjects = [];

    try {
      for (int page = 1; page <= totalPages; page++) {
        final url = Uri.parse(
          "https://webapi.bps.go.id/v1/api/list/domain/3373/model/subjectcsa/page/$page/key/91e4d5e9c5a13e1b6214a14f037956de/",
        );
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['data'] is List && data['data'].length > 1) {
            final List<dynamic> rawList = data['data'][1];
            allSubjects.addAll(rawList.cast<Map<String, dynamic>>());
          }
        }
      }

      setState(() {
        subjects = allSubjects;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error saat mengambil data: $e");
    }
  }

   Widget buildCategoryItem(Map<String, dynamic> category, int index) {
  final color = backgroundColors[index % backgroundColors.length];

  final matchingSubject = subjects.firstWhere(
    (subject) => subject['title']?.toString()?.toLowerCase()?.contains(category['label'].toString().toLowerCase()) ?? false,
    orElse: () => {},
  );

  final String? iconUrl = matchingSubject['icon'];

  if (category['label'] == 'Lainnya') {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Icon(
              category['icon'] ?? Icons.apps,
              size: 35,
              color: iconColors[index % iconColors.length],
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          category['label'],
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 9),
        ),
      ],
    );
  }

  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: iconUrl != null
              ? (iconUrl.endsWith('.svg')
                  ? SvgPicture.network(
                      Uri.encodeFull(iconUrl),
                      width: 40,
                      height: 40,
                      placeholderBuilder: (context) => Icon(Icons.image, size: 40),
                      color: iconColors[index % iconColors.length], // <= SVG bisa dikasih warna langsung
                    )
                  : ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        iconColors[index % iconColors.length],
                        BlendMode.srcIn,
                      ),
                      child: Image.network(
                        Uri.encodeFull(iconUrl),
                        width: 40,
                        height: 40,
                        errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 40),
                      ),
                    ))
              : Icon(Icons.folder, size: 40, color: iconColors[index % iconColors.length]),
        ),
      ),
      SizedBox(height: 8),
      Text(
        category['label'],
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 9),
      ),
    ],
  );
}

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tabel Data Statistik',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 12),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 110,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: predefinedCategories.length,
                  itemBuilder: (context, index) {
                    return buildCategoryItem(predefinedCategories[index], index);
                  },
                ),
        ],
      ),
    );
  }
}
