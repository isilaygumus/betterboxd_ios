import 'dart:convert';
import 'package:http/http.dart' as http;
import 'movie.dart';

class ApiService {
  // Emülatör: 10.0.2.2  |  Gerçek telefon: bilgisayarın IP adresi
  static const String baseUrl = 'http://10.0.2.2:5277';

  Future<List<Movie>> getMovies() async {
    final response = await http.get(Uri.parse('$baseUrl/api/movies'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Movie.fromJson(e)).toList();
    }
    throw Exception('Filmler alınamadı: ${response.statusCode}');
  }
}