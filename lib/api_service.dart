import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'genre.dart';
import 'movie.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService {
  // Emülatör: 10.0.2.2  |  Gerçek telefon: bilgisayarın IP adresi
  static const String baseUrl = 'http://10.0.2.2:5277';
  static const Duration _timeout = Duration(seconds: 10);

  // Tüm GET istekleri buradan geçer (JWT başlığı ileride buraya eklenecek)
  Future<dynamic> _get(String path, [Map<String, String>? query]) async {
    var uri = Uri.parse('$baseUrl$path');
    if (query != null && query.isNotEmpty) {
      uri = uri.replace(queryParameters: query);
    }

    try {
      final response = await http.get(uri).timeout(_timeout);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      if (response.statusCode == 404) {
        throw ApiException('Kayıt bulunamadı.');
      }
      throw ApiException('Sunucu hatası (${response.statusCode}).');
    } on TimeoutException {
      throw ApiException(
          'Sunucu yanıt vermedi. API çalışıyor mu, adres doğru mu?');
    } on SocketException {
      throw ApiException(
          'Bağlantı kurulamadı. İnternetinizi ve API adresini kontrol edin.');
    } on http.ClientException {
      throw ApiException(
          'Bağlantı kurulamadı. İnternetinizi ve API adresini kontrol edin.');
    } on FormatException {
      throw ApiException('Sunucudan beklenmeyen bir yanıt geldi.');
    }
  }

  // search: arama (web tarafında üçüncü kişi ekliyor, şimdilik yoksayılır)
  Future<List<Movie>> getMovies({String? search, int? genreId}) async {
    final query = <String, String>{};
    if (genreId != null) query['genreId'] = genreId.toString();
    if (search != null && search.trim().isNotEmpty) {
      query['search'] = search.trim();
    }
    final data = await _get('/api/movies', query) as List;
    return data.map((e) => Movie.fromJson(e)).toList();
  }

  Future<Movie> getMovie(int id) async {
    final data = await _get('/api/movies/$id') as Map<String, dynamic>;
    return Movie.fromJson(data);
  }

  Future<List<Genre>> getGenres() async {
    final data = await _get('/api/genres') as List;
    return data.map((e) => Genre.fromJson(e)).toList();
  }
}