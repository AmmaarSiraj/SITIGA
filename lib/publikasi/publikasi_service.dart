import 'package:http/http.dart' as http;
import 'dart:convert';

class PublikasiService {
  static Future<List<Map<String, dynamic>>> fetchAllPublications() async {
    final baseUrl = "https://webapi.bps.go.id/v1/api/list/model/publication/domain/3373/page/";
    final key = "/key/91e4d5e9c5a13e1b6214a14f037956de/";
    List<Map<String, dynamic>> allPublications = [];

    for (int i = 1; i <= 28; i++) {
      final response = await http.get(Uri.parse("$baseUrl$i$key"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] is List && data['data'].length > 1) {
          final List<dynamic> rawList = data['data'][1];
          allPublications.addAll(rawList.cast<Map<String, dynamic>>());
        }
      }
    }

    return allPublications;
  }
}
