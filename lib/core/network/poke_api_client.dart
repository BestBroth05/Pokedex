import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokedex/config/env.dart';

class PokeApiClient {
  static String baseUrl = Environment.baseUrl;

  Future<Map<String, dynamic>> getJson(
    String path, {
    Map<String, String>? query,
  }) async {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: query);
    final res = await http.get(uri);

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw HttpException('HTTP ${res.statusCode}', uri.toString());
    }
    return jsonDecode(res.body) as Map<String, dynamic>;
  }
}

class HttpException implements Exception {
  final String message;
  final String url;
  HttpException(this.message, this.url);

  @override
  String toString() => 'HttpException($message) url=$url';
}
