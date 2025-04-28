import 'dart:convert';
import 'package:http/http.dart' as http;

class TabelService {
  final int totalRequests;
  final Function(Map<String, Map<String, List<Map<String, dynamic>>>>) onDataFetched;
  final Function(int) onProgress;
  final Map<String, String> categoryMapping;

  TabelService({
    required this.totalRequests,
    required this.onDataFetched,
    required this.onProgress,
    required this.categoryMapping,
  });

  Future<void> fetchPublications() async {
    Map<String, Map<String, List<Map<String, dynamic>>>> groupedCategories = {
      "Statistik Demografi dan Sosial": {},
      "Statistik Ekonomi": {},
      "Statistik Lingkungan Hidup dan Multi-domain": {}
    };

    int completedRequests = 0;
    final baseUrl =
        "https://webapi.bps.go.id/v1/api/list/model/statictable/lang/ind/domain/3373/page/";
    final key = "/key/91e4d5e9c5a13e1b6214a14f037956de/";

    for (int i = 0; i < totalRequests; i += 10) {
      List<Future<void>> batchRequests = [];
      for (int j = i; j < i + 10 && j <= totalRequests; j++) {
        final url = "$baseUrl$j$key";
        batchRequests.add(_fetchPage(url, groupedCategories));
      }
      await Future.wait(batchRequests);
      onProgress(completedRequests += batchRequests.length);
    }

    onDataFetched(groupedCategories);
  }

  Future<void> _fetchPage(String url,
      Map<String, Map<String, List<Map<String, dynamic>>>> groupedCategories) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] is List && data['data'].length > 1) {
          final List<dynamic> rawList = data['data'][1];

          for (var table in rawList) {
            String subj = table['subj']?.toString() ?? "Uncategorized";
            String? mainCategory = categoryMapping[subj] ?? "Uncategorized";

            groupedCategories.putIfAbsent(mainCategory, () => {});
            groupedCategories[mainCategory]!
                .putIfAbsent(subj, () => [])
                .add(table);
          }
        }
      } else {
        throw Exception("Failed to load page: $url");
      }
    } catch (e) {
      print("Error fetching data from $url: $e");
    }
  }

  static fetchAllPages({required int totalRequests, required Map<String, Map<String, List<Map<String, dynamic>>>> groupedCategories, required Null Function(dynamic completed) onProgress}) {}
}
