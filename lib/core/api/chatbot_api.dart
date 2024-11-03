import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:playhub/core/api/api_config.dart';

class ChatBot {
  static Future<String> sendMessage(String message) async {
    final mlUrl = ApiConfig.getChatbotUrl('query/');

    try {
      final mlResponse = await http.post(
        mlUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'questions': [message],
        }),
      );

      if (mlResponse.statusCode == 200) {
        final data = json.decode(mlResponse.body);
        return data['results'][0]['answer'];
      } else {
        throw Exception('Failed to send message');
      }
    } catch (e) {
      throw Exception('Failed to send message');
    }
  }
}
