import 'dart:convert';
import 'package:http/http.dart' as http;

class FetchService {
  final String url = "https://api.sawalef.app/api/v1/reels";

  Future<List<dynamic>> getReels() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse['data'];  
    } else {
      throw Exception(
          'There is a problem with status code ${response.statusCode}');
    }
  }
}
