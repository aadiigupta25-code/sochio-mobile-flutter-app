import 'dart:convert';
import 'package:http/http.dart' as http;
import '../util/config.dart';

class ApiService {
  static const String _baseUrl = baseURL;
  static const String _secretKey = secretKey;
  static String? _authToken;
  
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': _authToken != null ? 'Bearer $_authToken' : 'Bearer $_secretKey',
    'key': _secretKey,
  };

  static Future<http.Response> getRequest(String endpoint) async {
    final response = await http.get(
      Uri.parse('$_baseUrl$endpoint'),
      headers: _headers,
    );
    
    if (response.statusCode == 401) {
      await _refreshToken();
      return http.get(
        Uri.parse('$_baseUrl$endpoint'),
        headers: _headers,
      );
    }
    
    return response;
  }

  static Future<http.Response> postRequest(String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$endpoint'),
      headers: _headers,
      body: jsonEncode(data),
    );
    
    if (response.statusCode == 401) {
      await _refreshToken();
      return http.post(
        Uri.parse('$_baseUrl$endpoint'),
        headers: _headers,
        body: jsonEncode(data),
      );
    }
    
    return response;
  }

  static Future<void> _refreshToken() async {
    try {
      final response = await http.post(
        Uri.parse('${_baseUrl}api/auth/refresh'),
        headers: {'Authorization': 'Bearer $_secretKey'},
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _authToken = data['token'];
      }
    } catch (e) {
      _authToken = null;
    }
  }

  static Future<bool> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {'Authorization': 'Bearer $_secretKey'},
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${_baseUrl}admin/login'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_secretKey',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true) {
          _authToken = data['token'];
          return data;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<List<dynamic>?> getProducts() async {
    try {
      final response = await getRequest('product/getRealProducts');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['product'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<List<dynamic>?> getCategories() async {
    try {
      final response = await getRequest('category');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['category'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}