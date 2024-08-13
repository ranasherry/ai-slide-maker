import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

class MyAPIService {
  // final MyAPIService _auth = MyAPIService.instance;
  static final MyAPIService _instance = MyAPIService._internal();

  factory MyAPIService() {
    // Purchases.setEmail(email)
    return _instance;
  }

  MyAPIService._internal();

  Future<List<String>?> fetchImageUrl(String prompt, int imageCount) async {
    final String apiUrl = 'http://aqibsiddiqui.com/image?url=true';

    try {
      developer.log('MYAPITAG fetchImageUrl API Called ');

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'prompt': prompt,
          // 'image_count': 1, // Add the image_count parameter here
        }),
      );
      developer.log('MYAPITAG fetchImageUrl API Response: $response ');

      if (response.statusCode == 200) {
        developer.log('MYAPITAG fetchImageUrl API Status code 200');
        developer.log('MYAPITAG fetchImageUrl response Body: ${response.body}');

        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        developer.log('MYAPITAG fetchImageUrl jsonResponse: ${jsonResponse}');
        final List<String> imageUrls =
            jsonResponse['url'].cast<String>(); // Cast to List<String>
        return imageUrls;
        // return jsonResponse['url'];
      } else {
        developer.log(
            'MYAPITAG Failed to get image URL. Status code: ${response.statusCode}');
      }
    } catch (e) {
      developer.log('MYAPITAG Error occurred while fetching image URL: $e');
    }
    return null;
  }

  Future<Uint8List?> downloadImage(String url) async {
    developer.log('MYAPITAG Download Image Started');
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'http://$url';
    }
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        developer.log(
            'MYAPITAG Failed to download image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      developer.log('MYAPITAG Error occurred while downloading image: $e');
    }
    return null;
  }

  // Sign in with email and password

  // Other sign-in methods (e.g., sign in with Google) can be added here
}
