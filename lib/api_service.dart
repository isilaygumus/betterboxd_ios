import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'genre.dart';
import 'movie.dart';
import 'package:flutter/foundation.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService {
static const String baseUrl = 'http://10.0.2.2:5277';
  static const Duration _timeout = Duration(seconds: 10);
  static const Map<String, String> _headers = {'Content-Type': 'application/json'};


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
  
  Future<Map<String, dynamic>> registerUser(String userName, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/users/register'),
      headers: _headers,
      body: jsonEncode({
        'userName': userName,
        'email' : email,
        'password' : password,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201){
      return jsonDecode(response.body);
    } 

    throw ApiException(_parseError(response.body));
  }

    Future<Map<String, dynamic>?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/users/login'),
      headers: _headers,
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    if (response.statusCode == 401) return null;
    
    throw ApiException(_parseError(response.body));
  }

  String _parseError(String body){
    try{
      final data = jsonDecode(body);

      if (data is List) return data.join('\n');

      if (data is Map && data['errors'] is Map){
        final messages = (data['errors'] as Map)
          .values
          .expand((e) => e is List ? e : [e])
          .join('\n');
        
        if (messages.isNotEmpty) return messages;
      }

      if (data is String) return data;
    }

    catch(_){
      if (body.isNotEmpty) return body;
    }

    return 'Kayıt sırasında bir hata oluştu.';
  }
}
