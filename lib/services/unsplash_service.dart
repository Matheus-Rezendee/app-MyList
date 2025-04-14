// unsplash_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class UnsplashService {
  static Future<String?> fetchImageUrl({required String query}) async {
    try {
      // A lógica para buscar a URL da imagem.
      // Suponha que você tenha algum código para fazer uma requisição à API do Unsplash.
      // Exemplo fictício:
      final response = await http.get(Uri.parse('https://api.unsplash.com/search/photos?query=$query&client_id=kp1dM0x1xxYHKI6a8q2AgX3x50_IkmdI7T5gAp1Gzew'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['results'].isNotEmpty) {
          return data['results'][0]['urls']['small']; // Retorna a URL da imagem
        }
      }
    } catch (e) {
      print('Erro ao buscar a imagem: $e');
    }
    return null; // Retorna null caso não encontre ou haja erro
  }
}

