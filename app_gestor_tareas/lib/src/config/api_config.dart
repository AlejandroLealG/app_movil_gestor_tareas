import 'package:flutter/foundation.dart';

const String _defaultApiBaseUrlWeb = 'http://localhost:8081/api';
const String _defaultApiBaseUrlMobile = 'http://10.0.2.2:8081/api';

// Permite sobrescribir la URL desde --dart-define=API_BASE_URL=...
const String _envApiBaseUrl = String.fromEnvironment('API_BASE_URL');

final String apiBaseUrl = _envApiBaseUrl.isNotEmpty
    ? _envApiBaseUrl
    : (kIsWeb ? _defaultApiBaseUrlWeb : _defaultApiBaseUrlMobile);

const String authTokenHeader = 'X-Auth-Token';

