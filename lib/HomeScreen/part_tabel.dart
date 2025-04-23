import 'package:flutter/material.dart';

class CategoryGrid extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.people, 'label': 'Kependudukan'},
    {'icon': Icons.attach_money, 'label': 'Inflasi'},
    {'icon': Icons.health_and_safety, 'label': 'Kesehatan'},
    {'icon': Icons.school, 'label': 'Pendidikan'},
    {'icon': Icons.forest, 'label': 'Pariwisata'},
    {'icon': Icons.public, 'label': 'Geografis'},
    {'icon': Icons.balance, 'label': 'Perdagangan'},
    {'icon': Icons.apps, 'label': 'Lainnya'},
  ];

  CategoryGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 0.8,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.blueGrey,
                child: Icon(
                  categories[index]['icon'],
                  size: 30,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: 70,
                child: Text(
                  categories[index]['label'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 11),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
