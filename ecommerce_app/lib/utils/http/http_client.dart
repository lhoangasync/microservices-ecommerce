import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class THttpHelper {
  static const String _baseUrl = 'http://192.168.0.117:8888/api/v1';
  static final _localStorage = GetStorage();

  /// Build headers, optionally including Authorization token
  static Map<String, String> _buildHeaders(bool useToken) {
    final headers = {'Content-Type': 'application/json'};

    if (useToken) {
      final token = _localStorage.read('ACCESS_TOKEN');
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  static Future<Map<String, dynamic>> get(
    String endpoint, {
    bool useToken = false,
  }) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: _buildHeaders(useToken),
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> post(
    String endpoint,
    dynamic data, {
    bool useToken = false,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: _buildHeaders(useToken),
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  // static Future<Map<String, dynamic>> put(
  //   String endpoint,
  //   dynamic data, {
  //   bool useToken = false,
  // }) async {
  //   final response = await http.put(
  //     Uri.parse('$_baseUrl/$endpoint'),
  //     headers: _buildHeaders(useToken),
  //     body: json.encode(data),
  //   );
  //   return _handleResponse(response);
  // }

  static Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> data, {
    bool useToken = false,
  }) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: _buildHeaders(useToken),
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> delete(
    String endpoint, {
    bool useToken = false,
  }) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: _buildHeaders(useToken),
    );
    return _handleResponse(response);
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    if (kDebugMode) {
      print("Raw body: ${response.body}");
    }

    Map<String, dynamic> responseData;
    try {
      responseData = json.decode(response.body);
    } catch (_) {
      responseData = {'message': 'Invalid JSON format from server'};
    }

    return {
      'code': response.statusCode,
      'message': responseData['message'] ?? 'Something went wrong!',
      'error': responseData['error'],
      'data': responseData,
    };
  }

  /// Upload file using multipart/form-data
  static Future<Map<String, dynamic>> uploadMultipartFile(
    String endpoint,
    String fieldName,
    String filePath, {
    bool useToken = false,
  }) async {
    final uri = Uri.parse('$_baseUrl/$endpoint');
    final request = http.MultipartRequest('PUT', uri);

    // Add token to headers
    if (useToken) {
      final token = _localStorage.read('ACCESS_TOKEN');
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
    }

    // Add file
    request.files.add(await http.MultipartFile.fromPath(fieldName, filePath));

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (kDebugMode) {
      print('Multipart response body: $responseBody');
    }

    Map<String, dynamic> responseData;
    try {
      responseData = json.decode(responseBody);
    } catch (_) {
      responseData = {'message': 'Invalid JSON format from server'};
    }

    return {
      'code': response.statusCode,
      'message': responseData['message'] ?? 'Something went wrong!',
      'error': responseData['error'],
      'data': responseData['data'],
    };
  }
}
