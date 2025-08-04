import 'dart:async';
import '../models/login_response.dart';
import '../models/mother_plant_detail_response.dart';
import '../models/user.dart';

/// Service interface for handling API calls
abstract class ApiService {
  /// Get mother plant details by assignment ID 
  Future<MotherPlantDetailResponse?> getMotherPlantDetails(int assignmentId);
  
  /// Upload mother plant photo
  Future<Map<String, dynamic>> uploadMotherPlantAssignment({
    required int assignmentId,
    required String photoPath,
    required String latitude,
    required String longitude,
    String? remarks,
  });
  
  /// Get list of mothers
  Future<List<User>> getAllMothers();
  
  /// Call AI prediction API
  Future<Map<String, dynamic>> predictPlantImageAI(String imagePath);
}

// Login helper functions - not part of the interface
Future<LoginResponse> loginUser(String userId, String password, String loginType) async {
  // TODO: Implement login logic
  throw UnimplementedError('loginUser() has not been implemented.');
}

// Password management helper function - not part of the interface  
Future<bool> changePassword({
  required String currentPassword,
  required String newPassword,
  required String confirmPassword,
}) async {
  // TODO: Implement password change logic
  return false;
}
