import 'package:http/http.dart' as http;
import 'dart:convert';

// network.dart

Future<List<Map<String, dynamic>>> fetchSubjects() async {
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
    return allSubjects;
  } catch (e) {
    throw Exception("Error fetching subjects: $e");
  }
}


Future<List<Map<String, dynamic>>> fetchInfographicData() async {
  final url = Uri.parse(
      "https://webapi.bps.go.id/v1/api/list/model/infographic/lang/ind/domain/3373/key/91e4d5e9c5a13e1b6214a14f037956de/");

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['data'] is List && data['data'].length > 1) {
        return List<Map<String, dynamic>>.from(data['data'][1]);
      } else {
        throw Exception("Invalid data format");
      }
    } else {
      throw Exception("Failed to load infographic data");
    }
  } catch (e) {
    throw Exception("Error fetching infographic: $e");
  }
}

Future<List<Map<String, dynamic>>> fetchNews() async {
  final url = Uri.parse(
      "https://webapi.bps.go.id/v1/api/list/model/news/lang/ind/domain/3373/key/91e4d5e9c5a13e1b6214a14f037956de/");

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['data'] is List && data['data'].length > 1) {
        return List<Map<String, dynamic>>.from(data['data'][1]);
      } else {
        throw Exception("Invalid data format");
      }
    } else {
      throw Exception("Failed to load news data");
    }
  } catch (e) {
    throw Exception("Error fetching news: $e");
  }
}
