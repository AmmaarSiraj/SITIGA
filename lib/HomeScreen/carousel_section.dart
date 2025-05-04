import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselSection extends StatefulWidget {
  final List<String> carouselImages;

  const CarouselSection({Key? key, required this.carouselImages})
      : super(key: key);

  @override
  _CarouselSectionState createState() => _CarouselSectionState();
}

class _CarouselSectionState extends State<CarouselSection> {
  final CarouselController _controller = CarouselController();
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Stack(
            children: [
              CarouselSlider(
                carouselController: _controller,
                options: CarouselOptions(
                  height: 180.0,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  autoPlayInterval: const Duration(seconds: 7),
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
                items: widget.carouselImages.map((item) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset(item, fit: BoxFit.contain, width: 1000),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 1), // Tambahkan ini untuk kontrol jarak
          // Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                List.generate(widget.carouselImages.length * 2 - 1, (index) {
              if (index.isOdd) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Container(
                    width: 3,
                    height: 3,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade200,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              } else {
                final itemIndex = index ~/ 2;
                final isActive = itemIndex == _current;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Transform.rotate(
                    angle: 0.7854, // 45 derajat
                    child: Container(
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
                  ),
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
