import 'dart:convert';
import 'package:http/http.dart' as http;
import 'movie.dart';
import 'package:flutter/foundation.dart';

class ApiService {

  static const String baseUrl = 'http://localhost:5277';
  static const Map<String, String> _headers = {'Content-Type': 'application/json'};   
  

  Future<List<Movie>> getMovies() async {
    final response = await http.get(Uri.parse('$baseUrl/api/movies'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Movie.fromJson(e)).toList();
    }
    throw Exception('Filmler alınamadı: ${response.statusCode}');
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

    debugPrint('REGISTER ${response.statusCode}: ${response.body}');

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
    return null;
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

class ApiException implements Exception{
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;

}