import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mixboxapp/service/auth_service.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:3000';

  static Future<String?> getToken() async {
    return await AuthService.getToken();
  }

  static Future<Map<String, dynamic>> get(String endpoint) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      },

      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    }

    throw Exception(data['message'] ?? 'Something went wrong');
  }

  static Future<http.Response> postMultipart({
    required String endpoint,
    required Map<String, String> fields,
    File? file,
    String? fileField,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl$endpoint'),
    );

    request.fields.addAll(fields);

    if (file != null && fileField != null) {
      request.files.add(
        await http.MultipartFile.fromPath(fileField, file.path),
      );
    }

    final streamedResponse = await request.send();

    return await http.Response.fromStream(streamedResponse);
  }
}
