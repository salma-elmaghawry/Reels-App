import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String url = "https://api.sawalef.app/api/v1/reels";

  Future<List<String>> getReels() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        List<dynamic> data = jsonResponse['data'] ?? [];
        List<String> videoUrls = data.map((item) => item['video'] as String).toList();
        return videoUrls;
      } catch (e) {
        throw Exception('Error parsing JSON data: $e');
      }
    } else {
      throw Exception(
          'There is a problem with the status code ${response.statusCode}');
    }
  }
}
