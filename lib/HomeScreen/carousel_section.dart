import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselSection extends StatelessWidget {
  final List<String> carouselImages;

  const CarouselSection({Key? key, required this.carouselImages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 180.0,
          enlargeCenterPage: true,
          autoPlay: true,
          aspectRatio: 16 / 9,
          autoPlayInterval: const Duration(seconds: 3),
        ),
        items: carouselImages.map((item) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset(item, fit: BoxFit.contain, width: 1000),
          );
        }).toList(),
      ),
    );
  }
}
