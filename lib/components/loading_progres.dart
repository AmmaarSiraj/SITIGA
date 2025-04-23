import 'package:flutter/material.dart';

class LoadingProgress extends StatelessWidget {
  final int completed;
  final int total;
  final String? message;

  const LoadingProgress({
    Key? key,
    required this.completed,
    required this.total,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double progress = total > 0 ? completed / total : 0;
    int percent = (progress * 100).toInt();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message ?? "Memuat data...",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          SizedBox(
            width: 250,
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.grey[300],
              color: Colors.blueAccent,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "$percent%",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10),
          
        ],
      ),
    );
  }
}