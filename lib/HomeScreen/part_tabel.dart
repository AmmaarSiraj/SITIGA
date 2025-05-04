import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'; // Tambahkan ini
import '../providers/data_provider.dart';

class CategoryGrid extends StatefulWidget {
  const CategoryGrid({Key? key}) : super(key: key);

  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

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

  Widget buildCategoryItem(BuildContext context, Map<String, dynamic> category,
      int index, List<Map<String, dynamic>> subjects) {
    final color = backgroundColors[index % backgroundColors.length];
    final matchingSubject = subjects.firstWhere(
      (subject) =>
          subject['title']
              ?.toString()
              .toLowerCase()
              .contains(category['label'].toString().toLowerCase()) ??
          false,
      orElse: () => {},
    );
    final String? iconUrl = matchingSubject['icon'];

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
            child: category['label'] == 'Lainnya'
                ? Icon(category['icon'] ?? Icons.apps,
                    size: 35, color: iconColors[index])
                : iconUrl != null
                    ? (iconUrl.endsWith('.svg')
                        ? SvgPicture.network(Uri.encodeFull(iconUrl),
                            width: 40,
                            height: 40,
                            placeholderBuilder: (_) => Icon(Icons.image),
                            color: iconColors[index])
                        : ColorFiltered(
                            colorFilter: ColorFilter.mode(
                                iconColors[index], BlendMode.srcIn),
                            child: Image.network(Uri.encodeFull(iconUrl),
                                width: 40)))
                    : Icon(Icons.folder, size: 40, color: iconColors[index]),
          ),
        ),
        SizedBox(height: 8),
        Text(category['label'],
            textAlign: TextAlign.center, style: TextStyle(fontSize: 9)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final subjects = Provider.of<DataProvider>(context).allSubjects;

    if (subjects.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        final crossAxisCount = isWide ? 4 : 3;
        final rowCount = 2;
        final itemHeight = (constraints.maxWidth / crossAxisCount) * 0.95;
        final gridHeight = itemHeight * rowCount + 20;

        final totalPages =
            (predefinedCategories.length / (crossAxisCount * rowCount)).ceil();

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Tabel Data Statistik',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 12),
              SizedBox(
                height: gridHeight,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: totalPages,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemBuilder: (context, pageIndex) {
                    final startIndex = pageIndex * (crossAxisCount * rowCount);
                    final endIndex = (startIndex + (crossAxisCount * rowCount))
                        .clamp(0, predefinedCategories.length);
                    final categoriesPage =
                        predefinedCategories.sublist(startIndex, endIndex);

                    return GridView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: categoriesPage.length,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.85,
                      ),
                      itemBuilder: (context, index) {
                        final actualIndex = startIndex + index;
                        return buildCategoryItem(
                            context,
                            predefinedCategories[actualIndex],
                            actualIndex,
                            subjects);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 2),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(totalPages * 2 - 1, (index) {
                    if (index.isOdd) {
                      return const SizedBox(width: 8); // jarak antar diamond
                    } else {
                      final pageIndex = index ~/ 2;
                      final isActive = pageIndex == _currentPage;

                      return Transform.rotate(
                        angle: 0.7854, // 45 derajat
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: isActive ? 10 : 6,
                          height: isActive ? 10 : 6,
                          decoration: BoxDecoration(
                            color: isActive ? Colors.yellow : Colors.blue,
                            border: isActive
                                ? Border.all(color: Colors.blueAccent, width: 2)
                                : null,
                            shape: BoxShape.rectangle,
                          ),
                        ),
                      );
                    }
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
