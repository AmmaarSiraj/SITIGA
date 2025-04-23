// appbar.dart
import 'package:flutter/material.dart';

PreferredSizeWidget buildAppBar() {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: Color.fromARGB(255, 101, 149, 153),
    title: Row(
      children: [
        Image.asset(
          'assets/images/logo.png',
          height: 40,
          fit: BoxFit.contain,
        ),
        SizedBox(width: 10),
        Text(
          "SITIGA",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    ),
    actions: [
      IconButton(
        icon: Icon(Icons.notifications, color: Colors.white),
        onPressed: () {},
      ),
    ],
  );
}
