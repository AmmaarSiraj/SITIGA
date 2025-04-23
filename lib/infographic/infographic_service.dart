import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> fetchAllInfographics({
  int totalPages = 29,
  Function(int page)? onProgress,
}) async {
  List<Map<String, dynamic>> fetchedInfographics = [];

  for (int page = 1; page <= totalPages; page++) {
    final url = Uri.parse(
      "https://webapi.bps.go.id/v1/api/list/model/infographic/lang/ind/domain/3373/page/$page/key/91e4d5e9c5a13e1b6214a14f037956de/",
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] is List && data['data'].length > 1) {
          fetchedInfographics
              .addAll((data['data'][1] as List).cast<Map<String, dynamic>>());
        }
      }
    } catch (e) {
      print("Error fetching data on page $page: $e");
    }

    if (onProgress != null) {
      onProgress(page);
    }
  }

  return fetchedInfographics;
}