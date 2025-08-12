import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../utils/constants.dart';

class AuthService {
  static Future<bool> sendOTP(String phone, String role) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/auth/send-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone, 'role': role}),
      );
      return response.statusCode == 200;
    } catch (e) {
      // Mock success for demo purposes
      return true;
    }
  }

  static Future<User?> verifyOTP(String phone, String otp, {String? role}) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/auth/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone, 'otp': otp}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _saveUserData(data['user'], data['token']);
        return User.fromJson(data['user']);
      }
      return null;
    } catch (e) {
      // Mock user creation for demo purposes
      if (otp == '123456') {
        final mockUser = User(
          id: 'user_${DateTime.now().millisecondsSinceEpoch}',
          phone: phone,
          role: role ?? _getRoleFromPhone(phone),
          name: _getNameFromRole(role ?? _getRoleFromPhone(phone)),
          createdAt: DateTime.now(),
        );
        await _saveUserData(mockUser.toJson(), 'mock_token_123');
        return mockUser;
      }
      return null;
    }
  }

  static String _getRoleFromPhone(String phone) {
    // Simple logic to determine role based on phone number for demo
    if (phone.startsWith('1')) return 'hospital';
    if (phone.startsWith('2')) return 'aww';
    return 'mother';
  }

  static String _getNameFromRole(String role) {
    // Mock name generation based on role
    switch (role) {
      case 'hospital':
        return 'Hospital Staff';
      case 'aww':
        return 'AWW Worker/Mitanin';
      case 'mother':
        return 'Mother User';
      default:
        return 'User';
    }
  }

  static Future<void> _saveUserData(
      Map<String, dynamic> user, String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(user));
    await prefs.setString('auth_token', token);
  }

  static Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');
    if (userData != null) {
      return User.fromJson(jsonDecode(userData));
    }
    return null;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token != null) {
      final url = Uri.parse('${AppConstants.baseUrl}/auth/logout');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (response.statusCode != 200 || responseData['success'] != true) {
        throw Exception(responseData['message'] ?? 'Logout failed');
      }
    }
    await prefs.clear();
  }
}
