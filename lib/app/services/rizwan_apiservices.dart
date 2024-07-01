import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://rizwanmunir190.pythonanywhere.com/";

  // GET requests with prompt parameter
  static Future<dynamic> get(String endpoint, String prompt) async {
    final url = Uri.parse('$baseUrl/$endpoint?prompt=$prompt');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data from $endpoint');
    }
  }

  static Future<Uint8List?> getImageBytes(String prompt) async {
    final url = Uri.parse('$baseUrl/image');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'prompt': prompt,

        // Add any other data you want to send in the body
      }),
    );
    log("getImageBytes response: ${response.body}");

    if (response.statusCode == 200) {
      // print("Response Body: ${}")

      log("getImageBytes: ${response.body as Map<String, dynamic>}");
    } else {
      throw Exception('Failed to load data from $baseUrl/image?prompt=$prompt');
    }
  }

  // POST request for chat endpoint with specific parameters
  static Future<dynamic> postChat(
      String message, String user, String model) async {
    final url = Uri.parse('$baseUrl/chat');
    final body = jsonEncode({
      "message": message,
      "user": user,
      "model": model,
      "history": [], // Replace with actual history data if needed
    });

    final response = await http
        .post(url, body: body, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to send chat message');
    }
  }
}
