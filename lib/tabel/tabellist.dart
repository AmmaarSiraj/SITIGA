import 'package:flutter/material.dart';
import '../tabel/tabeldetail.dart';

class TableList extends StatelessWidget {
  final List<Map<String, dynamic>> tables;

  const TableList({Key? key, required this.tables}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tables.length,
      itemBuilder: (context, index) {
        final table = tables[index];
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: ListTile(
            title: Text(table['title']?.toString() ?? "No Title"),
            subtitle: Text("Table ID: ${table['table_id']?.toString() ?? "Unknown ID"}"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TabelDetailPage(
                    tableId: table['table_id'],  // Pass the tableId here
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
