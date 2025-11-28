import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';

class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Uri _buildUri(String endpoint) => Uri.parse('$apiBaseUrl$endpoint');

  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final response = await _client.post(
      _buildUri(endpoint),
      headers: _headers(token: token),
      body: jsonEncode(body ?? {}),
    );
    return _handleResponse(response);
  }

  Future<dynamic> put(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final response = await _client.put(
      _buildUri(endpoint),
      headers: _headers(token: token),
      body: jsonEncode(body ?? {}),
    );
    return _handleResponse(response);
  }

  Future<dynamic> get(
    String endpoint, {
    String? token,
  }) async {
    final response = await _client.get(
      _buildUri(endpoint),
      headers: _headers(token: token),
    );
    return _handleResponse(response);
  }

  Future<void> delete(
    String endpoint, {
    String? token,
  }) async {
    final response = await _client.delete(
      _buildUri(endpoint),
      headers: _headers(token: token),
    );
    _handleResponse(response);
  }

  Map<String, String> _headers({String? token}) {
    final headers = {
      'Content-Type': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers[authTokenHeader] = token;
    }
    return headers;
  }

  dynamic _handleResponse(http.Response response) {
    if (response.body.isEmpty) {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {};
      }
      throw Exception('Error de red (${response.statusCode})');
    }

    final dynamic data = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    }

    if (data is Map<String, dynamic>) {
      final message = data['error'] ?? data['message'] ?? 'Error inesperado';
      throw Exception(message.toString());
    }

    throw Exception('Error inesperado');
  }

  void dispose() {
    _client.close();
  }
}

