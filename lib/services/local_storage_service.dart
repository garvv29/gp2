import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/mother_registration.dart';

class LocalStorageService {
  static const String _motherRegistrationsKey = 'mother_registrations';
  static const String _nextIdKey = 'next_mother_id';
  static const String _localPhotosKey = 'local_photos';

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

  // Photo Storage Methods
  
  // Save a locally taken photo
  static Future<bool> saveLocalPhoto({
    required int assignmentId,
    required int weekNumber,
    required int monthNumber,
    required String imagePath,
    required String remarks,
    String? latitude,
    String? longitude,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Get existing local photos
      List<Map<String, dynamic>> localPhotos = await getLocalPhotos();
      
      // Create photo data
      Map<String, dynamic> photoData = {
        'assignmentId': assignmentId,
        'weekNumber': weekNumber,
        'monthNumber': monthNumber,
        'imagePath': imagePath,
        'remarks': remarks,
        'latitude': latitude,
        'longitude': longitude,
        'timestamp': DateTime.now().toIso8601String(),
        'uploaded': false,
      };
      
      // Add new photo
      localPhotos.add(photoData);
      
      // Save to SharedPreferences
      List<String> jsonList = localPhotos.map((photo) => jsonEncode(photo)).toList();
      await prefs.setStringList(_localPhotosKey, jsonList);
      
      return true;
    } catch (e) {
      print('Error saving local photo: $e');
      return false;
    }
  }

  // Get all local photos
  static Future<List<Map<String, dynamic>>> getLocalPhotos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String>? jsonList = prefs.getStringList(_localPhotosKey);
      
      if (jsonList == null || jsonList.isEmpty) {
        return [];
      }
      
      return jsonList.map((json) => jsonDecode(json) as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error getting local photos: $e');
      return [];
    }
  }

  // Get local photos for a specific assignment
  static Future<List<Map<String, dynamic>>> getLocalPhotosForAssignment(int assignmentId) async {
    try {
      List<Map<String, dynamic>> allPhotos = await getLocalPhotos();
      return allPhotos.where((photo) => photo['assignmentId'] == assignmentId).toList();
    } catch (e) {
      print('Error getting local photos for assignment: $e');
      return [];
    }
  }

  // Mark a local photo as uploaded
  static Future<bool> markPhotoAsUploaded(int assignmentId, int weekNumber, int monthNumber) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<Map<String, dynamic>> localPhotos = await getLocalPhotos();
      
      // Find and update the photo
      for (int i = 0; i < localPhotos.length; i++) {
        if (localPhotos[i]['assignmentId'] == assignmentId &&
            localPhotos[i]['weekNumber'] == weekNumber &&
            localPhotos[i]['monthNumber'] == monthNumber) {
          localPhotos[i]['uploaded'] = true;
          break;
        }
      }
      
      // Save updated list
      List<String> jsonList = localPhotos.map((photo) => jsonEncode(photo)).toList();
      await prefs.setStringList(_localPhotosKey, jsonList);
      
      return true;
    } catch (e) {
      print('Error marking photo as uploaded: $e');
      return false;
    }
  }

  // Delete a local photo
  static Future<bool> deleteLocalPhoto(int assignmentId, int weekNumber, int monthNumber) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<Map<String, dynamic>> localPhotos = await getLocalPhotos();
      
      // Remove the photo
      localPhotos.removeWhere((photo) => 
          photo['assignmentId'] == assignmentId &&
          photo['weekNumber'] == weekNumber &&
          photo['monthNumber'] == monthNumber);
      
      // Save updated list
      List<String> jsonList = localPhotos.map((photo) => jsonEncode(photo)).toList();
      await prefs.setStringList(_localPhotosKey, jsonList);
      
      return true;
    } catch (e) {
      print('Error deleting local photo: $e');
      return false;
    }
  }
} 