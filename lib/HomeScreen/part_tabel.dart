import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../providers/data_provider.dart'; // Import Provider!

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> predefinedCategories = const [
    {'label': 'Kependudukan'},
    {'label': 'Statistik Bisnis'},
    {'label': 'Kesehatan'},
    {'label': 'Pendidikan'},
    {'label': 'Pariwisata'},
    {'label': 'Lingkungan'},
    {'label': 'Perdagangan'},
    {'icon': Icons.apps, 'label': 'Lainnya'},
  ];

  final List<Color> backgroundColors = const [
    Color(0xFFFFF0E0),
    Color(0xFFE0FFE5),
    Color(0xFFE0F7FF),
    Color(0xFFEAE0FF),
    Color(0xFFE8FFE0),
    Color(0xFFE0FFF8),
    Color(0xFFF0F0F0),
    Color(0xFFF5F5F5),
  ];

  final List<Color> iconColors = const [
    Color(0xFFFFA726),
    Color(0xFF66BB6A),
    Color(0xFF29B6F6),
    Color(0xFFAB47BC),
    Color(0xFF9CCC65),
    Color(0xFF4DB6AC),
    Color(0xFFBDBDBD),
    Color(0xFF9E9E9E),
  ];

  Widget buildCategoryItem(BuildContext context, Map<String, dynamic> category, int index, List<Map<String, dynamic>> subjects) {
    final color = backgroundColors[index % backgroundColors.length];

    final matchingSubject = subjects.firstWhere(
      (subject) => subject['title']?.toString().toLowerCase().contains(category['label'].toString().toLowerCase()) ?? false,
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
                        color: iconColors[index % iconColors.length],
                      )
                    : ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          iconColors[index % iconColors.length],
                          BlendMode.srcIn,
                        ),
                        child: Image.network(
                          Uri.encodeFull(iconUrl),
                          width: 40,
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
    final subjects = Provider.of<DataProvider>(context).allSubjects;

    if (subjects.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

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
          GridView.builder(
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
              return buildCategoryItem(context, predefinedCategories[index], index, subjects);
            },
          ),
        ],
      ),
    );
  }
}
