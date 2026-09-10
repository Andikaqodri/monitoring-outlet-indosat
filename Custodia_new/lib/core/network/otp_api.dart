import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class OtpApi {
  OtpApi._();

    static String get _baseUrl => kIsWeb
      ? 'http://localhost:8000/api/v1'
      : 'http://10.10.121.31:8000/api/v1';

  static Future<void> send(String phone) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/otp/send'),
      headers: {'Accept': 'application/json'},
      body: {'phone': phone, 'type': 'REGISTER'},
    );
    _ensureSuccess(response, 'Gagal mengirim OTP.');
  }

  static Future<void> verify(String phone, String code) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/otp/verify'),
      headers: {'Accept': 'application/json'},
      body: {'phone': phone, 'otp_code': code, 'type': 'REGISTER'},
    );
    _ensureSuccess(response, 'Kode OTP tidak valid atau telah kedaluwarsa.');
  }

  static Future<void> verifyForgotPassword(String phone, String code) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/otp/verify'),
      headers: {'Accept': 'application/json'},
      body: {
        'phone': phone,
        'otp_code': code,
        'type': 'FORGOT_PASSWORD',
      },
    );
    _ensureSuccess(response, 'Kode OTP tidak valid atau telah kedaluwarsa.');
  }

  static Future<void> sendForgotPassword(String phone) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/forgot-password'),
      headers: {'Accept': 'application/json'},
      body: {'phone': phone},
    );
    _ensureSuccess(response, 'Gagal mengirim OTP reset password.');
  }

  static Future<void> resetPassword(
    String phone,
    String code,
    String newPassword,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/reset-password'),
      headers: {'Accept': 'application/json'},
      body: {
        'phone': phone,
        'otp_code': code,
        'new_password': newPassword,
      },
    );
    _ensureSuccess(response, 'Gagal mengubah kata sandi.');
  }

  static void _ensureSuccess(http.Response response, String fallbackMessage) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;

    String message = fallbackMessage;
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final errors = body['errors'] as Map<String, dynamic>?;
      final firstError = errors?.values.first;
      if (firstError is List && firstError.isNotEmpty) {
        message = firstError.first.toString();
      } else if (body['message'] != null) {
        message = body['message'].toString();
      }
    } on FormatException {
      // Keep the fallback message for non-JSON responses.
    }
    throw Exception(message);
  }
}
