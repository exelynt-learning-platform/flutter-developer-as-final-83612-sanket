import 'dart:convert';
import 'package:http/http.dart' as http;
import '../errors/failures.dart'; // From Phase 1

class ApiClient {
  final http.Client client;
  
  // The base URL provided in the assignment
  final String baseUrl = 'https://669b3f09276e45187d34eb4e.mockapi.io/api/v1';

  ApiClient({required this.client});

  // Generic GET request
  Future<dynamic> get(String endpoint) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
      );
      return _processResponse(response);
    } catch (e) {
      throw ServerFailure('Network error occurred');
    }
  }

  // Generic POST request
  Future<dynamic> post(String endpoint, {required Map<String, dynamic> body}) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
      return _processResponse(response);
    } catch (e) {
      throw ServerFailure('Network error occurred');
    }
  }

  // Generic PUT request
  Future<dynamic> put(String endpoint, {required Map<String, dynamic> body}) async {
    try {
      final response = await client.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
      return _processResponse(response);
    } catch (e) {
      throw ServerFailure('Network error occurred');
    }
  }

  // Generic DELETE request
  Future<dynamic> delete(String endpoint) async {
    try {
      final response = await client.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
      );
      return _processResponse(response);
    } catch (e) {
      throw ServerFailure('Network error occurred');
    }
  }

  // Centralized response processing and error handling
  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw ServerFailure('Requested resource not found');
    } else {
      throw ServerFailure('Server returned an error: ${response.statusCode}');
    }
  }
}