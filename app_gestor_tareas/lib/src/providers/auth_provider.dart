import 'package:flutter/foundation.dart';

import '../services/api_service.dart';

enum AuthStatus { idle, loading, authenticated, error }

class AuthProvider extends ChangeNotifier {
  AuthProvider({ApiService? apiService}) : _apiService = apiService ?? ApiService();

  final ApiService _apiService;

  AuthStatus _status = AuthStatus.idle;
  String? _token;
  String? _errorMessage;

  AuthStatus get status => _status;
  String? get token => _token;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _token != null && _token!.isNotEmpty;

  Future<bool> register({
    required String nombre,
    required String email,
    required String username,
    required String password,
  }) async {
    _setStatus(AuthStatus.loading);
    _errorMessage = null;
    try {
      await _apiService.post(
        '/register',
        body: {
          'nombre': nombre,
          'email': email,
          'username': username,
          'password': password,
        },
      );
      _setStatus(AuthStatus.idle);
      return true;
    } catch (e) {
      _handleError(e);
      return false;
    }
  }

  Future<bool> login({
    required String usernameOrEmail,
    required String password,
  }) async {
    _errorMessage = null;
    _setStatus(AuthStatus.loading);
    try {
      final response = await _apiService.post(
        '/login',
        body: {
          'usernameOrEmail': usernameOrEmail,
          'password': password,
        },
      );
      _token = response['token'] as String?;
      if (_token == null) {
        throw Exception('No se recibió token. Verifica el backend.');
      }
      _setStatus(AuthStatus.authenticated);
      return true;
    } catch (e) {
      _token = null;
      _errorMessage = null;
      _handleError(e);
      return false;
    }
  }

  void logout() {
    _token = null;
    _errorMessage = null;
    _setStatus(AuthStatus.idle);
  }

  void _setStatus(AuthStatus status) {
    _status = status;
    notifyListeners();
  }

  void _handleError(Object error) {
    _errorMessage = error.toString().replaceFirst('Exception: ', '');
    _setStatus(AuthStatus.error);
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }
}

