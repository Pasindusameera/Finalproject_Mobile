import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:playhub/core/api/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerAPI {
  static Future<Map<String, dynamic>> fetchCustomerById(
      String customerId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('jwt');

    if (token == null) {
      throw Exception('No token found, redirecting to login');
    }

    final url = ApiConfig.getBaseUrl('user/customers/$customerId');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load coach');
    }
  }

  static Future<Map<String, dynamic>> AddReview(
    String coachId,
    double rating,
    String review,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('jwt');
    final customerId = prefs.getString('_id');
    String sentiment = '';
    int points;

    if (token == null) {
      throw Exception('No token found, redirecting to login');
    }

    if (customerId == null) {
      throw Exception('Customer ID not found in SharedPreferences');
    }

    final url = ApiConfig.getBaseUrl('book/add_review');
    final mlUrl = ApiConfig.getMLUrl('predict');
    final coachUrl = ApiConfig.getBaseUrl('user/coach_points/$coachId');

    try {
      final mlResponse = await http.post(
        mlUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'text': review,
        }),
      );

      if (mlResponse.statusCode == 200) {
        final mlData = json.decode(mlResponse.body);
        sentiment = mlData['sentiment'];

        if (sentiment == 'positive') {
          points = 1;
        } else if (sentiment == 'negative') {
          points = -1;
        } else {
          points = 0;
        }
      } else {
        throw Exception('Failed to get rating from ML model');
      }

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'rating': rating,
          'review': review,
          'coachId': coachId,
          'customerId': customerId,
          'sentiment': sentiment,
        }),
      );

      if (response.statusCode == 201) {
        final coachResponse = await http.put(
          coachUrl,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'points': points,
          }),
        );

        if (coachResponse.statusCode == 200) {
          return json.decode(response.body);
        } else {
          throw Exception('Failed to update coach points');
        }
      }

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to add review');
      }
    } catch (e) {
      throw Exception('Failed to submit review: $e');
    }
  }

  static Future<Map<String, dynamic>> updateCustomerProfileById(
    Map<String, dynamic> updatedData,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('jwt');
    final customerId = prefs.getString('_id');

    if (token == null) {
      throw Exception('No token found, redirecting to login');
    }

    final url = ApiConfig.getBaseUrl('book/update_profile/$customerId');

    updatedData = updatedData.map((key, value) {
      if (value is String && value.isEmpty) return MapEntry(key, null);
      if (value is List && value.isEmpty) return MapEntry(key, null);
      return MapEntry(key, value);
    });
    updatedData.removeWhere((key, value) => value == null);

    print('URL: $url');
    print('Token: $token');
    print('Updated Data: $updatedData');

    final response = await http.patch(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(updatedData),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update customer profile: ${response.body}');
    }
  }
}
