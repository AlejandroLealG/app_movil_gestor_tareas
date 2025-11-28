import 'package:flutter/foundation.dart';

import '../models/task.dart';
import '../services/api_service.dart';
import 'auth_provider.dart';

class TaskProvider extends ChangeNotifier {
  TaskProvider({ApiService? apiService}) : _apiService = apiService ?? ApiService();

  final ApiService _apiService;
  AuthProvider? _authProvider;
  String? _currentToken;

  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasData => _tasks.isNotEmpty;

  void updateAuth(AuthProvider authProvider) {
    _authProvider = authProvider;
    if (_currentToken == authProvider.token) {
      return;
    }
    _currentToken = authProvider.token;
    if (!authProvider.isAuthenticated) {
      _tasks = [];
      notifyListeners();
    } else {
      fetchTasks();
    }
  }

  Future<void> fetchTasks() async {
    final token = _authProvider?.token;
    if (token == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.get('/tareas', token: token);
      final List<dynamic> data;
      if (response is List<dynamic>) {
        data = response;
      } else if (response is Map<String, dynamic>) {
        data = (response['data'] as List<dynamic>?) ??
            (response['tasks'] as List<dynamic>?) ??
            [];
      } else {
        data = [];
      }
      _tasks = data.map((item) => Task.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createTask(TaskPayload payload) async {
    final token = _authProvider?.token;
    if (token == null) return false;

    try {
      await _apiService.post('/tareas', body: payload.toJson(), token: token);
      await fetchTasks();
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateTask(int id, TaskPayload payload) async {
    final token = _authProvider?.token;
    if (token == null) return false;

    try {
      await _apiService.put('/tareas/$id', body: payload.toJson(), token: token);
      await fetchTasks();
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteTask(int id) async {
    final token = _authProvider?.token;
    if (token == null) return false;

    try {
      await _apiService.delete('/tareas/$id', token: token);
      _tasks = _tasks.where((task) => task.id != id).toList();
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }
}

