import 'package:http/http.dart' as http;
import 'dart:convert';

class PublikasiService {
  static const String _baseUrl = "https://webapi.bps.go.id/v1/api/list/model/publication/domain/3373/page/";
  static const String _apiKey = "91e4d5e9c5a13e1b6214a14f037956de";

  static Future<List<Map<String, dynamic>>> fetchPublications(int page) async {
    final response = await http.get(Uri.parse("$_baseUrl$page/key/$_apiKey"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['data'] is List && data['data'].length > 1) {
        return (data['data'][1] as List).cast<Map<String, dynamic>>();
      }
    }
    throw Exception("Failed to load publication data");
  }
}
