import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/mother_registration.dart';

class LocalStorageService {
  static const String _motherRegistrationsKey = 'mother_registrations';
  static const String _nextIdKey = 'next_mother_id';

  // Save a new mother registration
  static Future<bool> saveMotherRegistration(MotherRegistration registration) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Get existing registrations
      List<MotherRegistration> registrations = await getAllMotherRegistrations();
      
      // Add new registration
      registrations.add(registration);
      
      // Convert to JSON and save
      List<String> jsonList = registrations.map((r) => jsonEncode(r.toJson())).toList();
      await prefs.setStringList(_motherRegistrationsKey, jsonList);
      
      return true;
    } catch (e) {
      print('Error saving mother registration: $e');
      return false;
    }
  }

  // Get all mother registrations
  static Future<List<MotherRegistration>> getAllMotherRegistrations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String>? jsonList = prefs.getStringList(_motherRegistrationsKey);
      
      if (jsonList == null || jsonList.isEmpty) {
        return [];
      }
      
      return jsonList.map((json) => MotherRegistration.fromJson(jsonDecode(json))).toList();
    } catch (e) {
      print('Error getting mother registrations: $e');
      return [];
    }
  }

  // Get a specific mother registration by ID
  static Future<MotherRegistration?> getMotherRegistrationById(String id) async {
    try {
      List<MotherRegistration> registrations = await getAllMotherRegistrations();
      return registrations.firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }

  // Update an existing mother registration
  static Future<bool> updateMotherRegistration(MotherRegistration updatedRegistration) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<MotherRegistration> registrations = await getAllMotherRegistrations();
      
      // Find and update the registration
      int index = registrations.indexWhere((r) => r.id == updatedRegistration.id);
      if (index != -1) {
        registrations[index] = updatedRegistration;
        
        // Save updated list
        List<String> jsonList = registrations.map((r) => jsonEncode(r.toJson())).toList();
        await prefs.setStringList(_motherRegistrationsKey, jsonList);
        return true;
      }
      return false;
    } catch (e) {
      print('Error updating mother registration: $e');
      return false;
    }
  }

  // Delete a mother registration
  static Future<bool> deleteMotherRegistration(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<MotherRegistration> registrations = await getAllMotherRegistrations();
      
      // Remove the registration
      registrations.removeWhere((r) => r.id == id);
      
      // Save updated list
      List<String> jsonList = registrations.map((r) => jsonEncode(r.toJson())).toList();
      await prefs.setStringList(_motherRegistrationsKey, jsonList);
      
      return true;
    } catch (e) {
      print('Error deleting mother registration: $e');
      return false;
    }
  }

  // Clear all mother registrations
  static Future<bool> clearAllMotherRegistrations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_motherRegistrationsKey);
      return true;
    } catch (e) {
      print('Error clearing mother registrations: $e');
      return false;
    }
  }

  // Get next available ID
  static Future<String> getNextId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int nextId = prefs.getInt(_nextIdKey) ?? 1;
      
      // Increment and save
      await prefs.setInt(_nextIdKey, nextId + 1);
      
      return 'mother_$nextId';
    } catch (e) {
      print('Error getting next ID: $e');
      return 'mother_${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  // Get registration count
  static Future<int> getRegistrationCount() async {
    try {
      List<MotherRegistration> registrations = await getAllMotherRegistrations();
      return registrations.length;
    } catch (e) {
      return 0;
    }
  }

  // Search registrations by name or mobile number
  static Future<List<MotherRegistration>> searchRegistrations(String query) async {
    try {
      List<MotherRegistration> registrations = await getAllMotherRegistrations();
      String lowerQuery = query.toLowerCase();
      
      return registrations.where((registration) {
        return registration.motherName.toLowerCase().contains(lowerQuery) ||
               registration.mobileNumber.contains(query) ||
               registration.fatherHusbandName.toLowerCase().contains(lowerQuery);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  // Get registrations by date range
  static Future<List<MotherRegistration>> getRegistrationsByDateRange(DateTime startDate, DateTime endDate) async {
    try {
      List<MotherRegistration> registrations = await getAllMotherRegistrations();
      
      return registrations.where((registration) {
        return registration.registrationDate.isAfter(startDate.subtract(Duration(days: 1))) &&
               registration.registrationDate.isBefore(endDate.add(Duration(days: 1)));
      }).toList();
    } catch (e) {
      return [];
    }
  }
} 