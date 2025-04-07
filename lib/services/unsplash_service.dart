import 'dart:convert';
import 'package:http/http.dart' as http;

class UnsplashService {
  static const String _accessKey = 'kp1dM0x1xxYHKI6a8q2AgX3x50_IkmdI7T5gAp1Gzew'; 

  static Future<String?> fetchImageUrl(String query) async {
    final url = Uri.parse(
      'https://api.unsplash.com/search/photos?query=$query&per_page=1&client_id=$_accessKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['results'];
      if (results != null && results.isNotEmpty) {
        return results[0]['urls']['regular'];
      }
    }

    return null;
  }
}
