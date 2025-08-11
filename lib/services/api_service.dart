import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/plant.dart' as plant_model;
import '../models/upload.dart';
import '../models/user.dart';
import '../utils/constants.dart';
import '../models/login_response.dart';
import '../models/mother_plants_response.dart';
import '../models/mother_plant_detail_response.dart';
import '../models/hospital_dashboard_response.dart';
import '../models/mother_registration_response.dart';
import '../models/mothers_list_response.dart';
import '../models/mother_detail_response.dart';
import '../models/pending_verification_response.dart';
import '../models/uploaded_photos_response.dart';
import '../models/mitanin_mother_detail_response.dart';

class ApiService {
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<List<plant_model.Plant>> getPlants(String motherId) async {
    try {
      final token = await _getToken();
      final url = Uri.parse('${AppConstants.baseUrl}/plants/$motherId');
      print('[API REQUEST] GET: $url');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      print('[API RESPONSE] ${response.statusCode}: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => plant_model.Plant.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      // Mock data for demo
      return _getMockPlants(motherId);
    }
  }

  static List<plant_model.Plant> _getMockPlants(String motherId) {
    return List.generate(AppConstants.plantsPerMother, (index) {
      return plant_model.Plant(
        id: 'plant_${motherId}_${index + 1}',
        motherId: motherId,
        plantNumber: index + 1,
        assignedDate: DateTime.now().subtract(Duration(days: 30)),
        lastUploadDate: index < 2
            ? DateTime.now().subtract(Duration(days: 7)).toIso8601String()
            : null,
      );
    });
  }

  static Future<bool> uploadPlantImage(String plantId, String imagePath) async {
    try {
      final token = await _getToken();
      final url = Uri.parse('${AppConstants.baseUrl}/uploads');
      print('[API REQUEST] POST: $url, plantId: $plantId, imagePath: $imagePath');
      final request = http.MultipartRequest(
        'POST',
        url,
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
      request.fields['plant_id'] = plantId;
      final response = await request.send();
      print('[API RESPONSE] ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      // Mock success for demo
      return true;
    }
  }

  static Future<List<Upload>> getPendingUploads() async {
    try {
      final token = await _getToken();
      final url = Uri.parse('${AppConstants.baseUrl}/uploads/pending');
      print('[API REQUEST] GET: $url');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      print('[API RESPONSE] ${response.statusCode}: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Upload.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      // Mock data for demo
      return _getMockUploads();
    }
  }

  static List<Upload> _getMockUploads() {
    return [
      Upload(
        id: 'upload_1',
        plantId: 'plant_1',
        imageUrl: 'https://example.com/image1.jpg',
        uploadDate: DateTime.now().subtract(Duration(days: 1)),
        status: 'pending',
        motherName: 'Priya Sharma',
      ),
      Upload(
        id: 'upload_2',
        plantId: 'plant_2',
        imageUrl: 'https://example.com/image2.jpg',
        uploadDate: DateTime.now().subtract(Duration(days: 2)),
        status: 'pending',
        motherName: 'Sunita Devi',
      ),
    ];
  }

  static Future<List<User>> getAllMothers() async {
    try {
      final token = await _getToken();
      final url = Uri.parse('${AppConstants.baseUrl}/mothers');
      print('[API REQUEST] GET: $url');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      print('[API RESPONSE] ${response.statusCode}: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => User.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      // Mock data for demo
      return _getMockMothers();
    }
  }

  static List<User> _getMockMothers() {
    return [
      User(
        id: 'mother_1',
        phone: '9876543210',
        role: 'mother',
        name: 'Priya Sharma',
        createdAt: DateTime.now().subtract(Duration(days: 30)),
      ),
      User(
        id: 'mother_2',
        phone: '9876543211',
        role: 'mother',
        name: 'Sunita Devi',
        createdAt: DateTime.now().subtract(Duration(days: 25)),
      ),
    ];
  }

  static Future<MotherRegistrationResponse?> registerMother({
    required String motherName,
    required String fatherHusbandName,
    required String childGender,
    required String mobileNumber,
    required String deliveryDate,
    required String deliveryTime,
    required String deliveryType,
    required String bloodGroup,
    required String childOrder,
    required String weightAtBirth,
    required String districtLgdCode,
    required String blockLgdCode,
    required List<Map<String, dynamic>> plantQuantity,
    required String birthCertificate,
    required String pmmvy,
    required List<Map<String, dynamic>> plants,
    required String isShramikCard,
    required String isUsedAyushmanCard,
    required String ayushmanCardAmount,
    required String isBenefitNsy,
    required String isNsyForm,
    required String mantraVandana,
    String? deliveryDocumentPath,
    String? motherPhotoPath,
    // New yes/no questions
    String? jananiSurakshaYojana,
    String? ayushmanCardUsed,
    String? pmMatruVandanaYojana,
    String? pmMatruVandanaYojanaAmount,
    String? mahtariVandanYojana,
    String? shramikCard,
    String? noniSurakshaYojana,
  }) async {
    final token = await _getToken();
    final url = Uri.parse('${AppConstants.baseUrl}/hospital/new-mother-registration');
    print('[API REQUEST] POST: $url');
    print('[API REQUEST BODY] {mother_name: $motherName, ...}');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'mother_name': motherName,
        'father_husband_name': fatherHusbandName,
        'child_gender': childGender,
        'mobile_number': mobileNumber,
        'delivery_date': deliveryDate,
        'delivery_time': deliveryTime,
        'delivery_type': deliveryType,
        'blood_group': bloodGroup,
        'child_order': childOrder,
        'weight_at_birth': weightAtBirth,
        'district_lgd_code': districtLgdCode,
        'block_lgd_code': blockLgdCode,
        'plant_quantity': plantQuantity,
        'birth_certificate': birthCertificate,
        'pmmvy': pmmvy,
        'plants': plants,
        'is_shramik_card': isShramikCard,
        'is_used_ayushman_card': isUsedAyushmanCard,
        'ayushman_card_amount': ayushmanCardAmount,
        'is_benefit_nsy': isBenefitNsy,
        'is_nsy_form': isNsyForm,
        'mantra_vandana': mantraVandana,
        'delivery_document': deliveryDocumentPath,
        'mother_photo': motherPhotoPath,
        // New yes/no questions
        'jananiSurakshaYojana': jananiSurakshaYojana,
        'ayushmanCardUsed': ayushmanCardUsed,
        'pmMatruVandanaYojana': pmMatruVandanaYojana,
        'pmMatruVandanaYojanaAmount': pmMatruVandanaYojanaAmount,
        'mahtariVandanYojana': mahtariVandanYojana,
        'shramikCard': shramikCard,
        'noniSurakshaYojana': noniSurakshaYojana,
      }),
    );
    print('[API RESPONSE] ${response.statusCode}: ${response.body}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = jsonDecode(response.body);
      return MotherRegistrationResponse.fromJson(decoded);
    }
    return null;
  }

  static Future<bool> reviewUpload(
      String uploadId, String status, String review) async {
    try {
      final token = await _getToken();
      final url = Uri.parse('${AppConstants.baseUrl}/uploads/$uploadId/review');
      print('[API REQUEST] PUT: $url, body: {status: $status, review: $review}');
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'status': status, 'review': review}),
      );
      print('[API RESPONSE] ${response.statusCode}: ${response.body}');
      return response.statusCode == 200;
    } catch (e) {
      // Mock success for demo
      return true;
    }
  }

  static Future<MotherPlantsResponse?> getMotherPlants() async {
    try {
      print('=== GET MOTHER PLANTS API REQUEST START ===');
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final url = Uri.parse('${AppConstants.baseUrl}/mother/plants');
      
      print('[API REQUEST] Method: GET');
      print('[API REQUEST] URL: $url');
      print('[API REQUEST] Headers: Authorization: Bearer $token');
      
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      
      print('=== GET MOTHER PLANTS API RESPONSE ===');
      print('[API RESPONSE] Status Code: ${response.statusCode}');
      print('[API RESPONSE] Headers: ${response.headers}');
      print('[API RESPONSE] Body: ${response.body}');
      
      if (response.statusCode == 200) {
        print('[API RESPONSE] Success - Parsing JSON response...');
        final Map<String, dynamic> data = jsonDecode(response.body);
        print('[API PARSING] JSON Data Keys: ${data.keys.toList()}');
        
        try {
          final result = MotherPlantsResponse.fromJson(data);
          print('[API PARSING] Successfully parsed MotherPlantsResponse');
          print('[API PARSING] Plants Count: ${result.data.plantSummary.plants.length}');
          print('[API PARSING] Total Plants Assigned: ${result.data.plantSummary.totalPlantsAssigned}');
          print('=== GET MOTHER PLANTS API REQUEST END (SUCCESS) ===');
          return result;
        } catch (parseError) {
          print('[API PARSING] Error parsing JSON: $parseError');
          print('[API PARSING] Stack trace: ${StackTrace.current}');
          print('=== GET MOTHER PLANTS API REQUEST END (PARSE ERROR) ===');
          return null;
        }
      }
      print('[API ERROR] Non-200 status code: ${response.statusCode}');
      print('=== GET MOTHER PLANTS API REQUEST END (ERROR) ===');
      return null;
    } catch (e) {
      print('=== GET MOTHER PLANTS API EXCEPTION ===');
      print('[API EXCEPTION] Error Type: ${e.runtimeType}');
      print('[API EXCEPTION] Error Message: $e');
      print('[API EXCEPTION] Stack Trace: ${StackTrace.current}');
      print('=== GET MOTHER PLANTS API REQUEST END (EXCEPTION) ===');
      return null;
    }
  }

  static Future<MotherPlantDetailResponse?> getMotherPlantDetails(int assignmentId) async {
    try {
      print('=== GET PLANT DETAILS API REQUEST START ===');
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final url = Uri.parse('${AppConstants.baseUrl}/mother/plants/$assignmentId/details');
      
      print('[API REQUEST] Method: GET');
      print('[API REQUEST] URL: $url');
      print('[API REQUEST] Assignment ID: $assignmentId');
      print('[API REQUEST] Headers: Authorization: Bearer $token');
      
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      
      print('=== GET PLANT DETAILS API RESPONSE ===');
      print('[API RESPONSE] Status Code: ${response.statusCode}');
      print('[API RESPONSE] Headers: ${response.headers}');
      print('[API RESPONSE] Content Length: ${response.contentLength}');
      print('[API RESPONSE] Body: ${response.body}');
      
      if (response.statusCode == 200) {
        print('[API RESPONSE] Success - Parsing JSON response...');
        final Map<String, dynamic> data = jsonDecode(response.body);
        print('[API PARSING] JSON Data Keys: ${data.keys.toList()}');
        print('[API PARSING] Success: ${data['success']}');
        print('[API PARSING] Message: ${data['message']}');
        
        try {
          final result = MotherPlantDetailResponse.fromJson(data);
          print('[API PARSING] Successfully parsed MotherPlantDetailResponse');
          print('[API PARSING] Assignment ID: ${result.data.assignment.id}');
          print('[API PARSING] Plant Name: ${result.data.assignment.plant.name}');
          print('[API PARSING] Total Schedules: ${result.data.stats.totalSchedules}');
          print('=== GET PLANT DETAILS API REQUEST END (SUCCESS) ===');
          return result;
        } catch (parseError) {
          print('[API PARSING] Error parsing JSON: $parseError');
          print('[API PARSING] Error type: ${parseError.runtimeType}');
          print('[API PARSING] Stack trace: ${StackTrace.current}');
          print('=== GET PLANT DETAILS API REQUEST END (PARSE ERROR) ===');
          return null;
        }
      }
      print('[API ERROR] Non-200 status code: ${response.statusCode}');
      print('=== GET PLANT DETAILS API REQUEST END (ERROR) ===');
      return null;
    } catch (e) {
      print('=== GET PLANT DETAILS API EXCEPTION ===');
      print('[API EXCEPTION] Error Type: ${e.runtimeType}');
      print('[API EXCEPTION] Error Message: $e');
      print('[API EXCEPTION] Stack Trace: ${StackTrace.current}');
      print('=== GET PLANT DETAILS API REQUEST END (EXCEPTION) ===');
      return null;
    }
  }

  static Future<Map<String, dynamic>> uploadMotherPlantAssignment({
    required int assignmentId,
    required String photoPath,
    required String latitude,
    required String longitude,
    required String remarks,
  }) async {
    try {
      print('=== PHOTO UPLOAD API REQUEST START ===');
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      // Use the correct endpoint with assignmentId in the URL
      final url = Uri.parse('${AppConstants.baseUrl}/mother/plants/$assignmentId/upload-photo');
      print('[API REQUEST] Method: POST');
      print('[API REQUEST] URL: $url');
      print('[API REQUEST] Assignment ID: $assignmentId');
      print('[API REQUEST] Photo Path: $photoPath');
      print('[API REQUEST] Latitude: $latitude');
      print('[API REQUEST] Longitude: $longitude');
      print('[API REQUEST] Remarks: $remarks');
      print('[API REQUEST] Auth Token: Bearer ${token != null ? '${token.substring(0, 20)}...' : 'NULL'}');
      if (token == null) {
        print('[API ERROR] No auth token found in shared preferences');
        return {
          'success': false,
          'message': 'प्रमाणीकरण टोकन नहीं मिला। कृपया पुनः लॉगिन करें।',
          'statusCode': 401
        };
      }
      final file = File(photoPath);
      if (!await file.exists()) {
        print('[API REQUEST] ERROR: Photo file does not exist at path: $photoPath');
        return {
          'success': false,
          'message': 'Photo file not found. Please take photo again.'
        };
      }
      final fileSize = await file.length();
      print('[API REQUEST] Photo file size: ${fileSize} bytes (${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB)');
      if (fileSize > 10 * 1024 * 1024) {
        print('[API REQUEST] ERROR: Photo file too large: ${fileSize} bytes');
        return {
          'success': false,
          'message': 'Photo file too large. Please choose a smaller image.'
        };
      }
      if (fileSize == 0) {
        print('[API REQUEST] ERROR: Photo file is empty: ${fileSize} bytes');
        return {
          'success': false,
          'message': 'Photo file is empty. Please take photo again.'
        };
      }
      try {
        final lat = double.parse(latitude);
        final lng = double.parse(longitude);
        print('[API REQUEST] Parsed coordinates: lat=$lat, lng=$lng');
        if (lat.abs() > 90 || lng.abs() > 180) {
          print('[API REQUEST] ERROR: Invalid coordinates: lat=$lat, lng=$lng');
          return {
            'success': false,
            'message': 'Invalid GPS coordinates. Please enable location and try again.'
          };
        }
      } catch (e) {
        print('[API REQUEST] ERROR: Invalid coordinate format: lat=$latitude, lng=$longitude, error=$e');
        return {
          'success': false,
          'message': 'Invalid location data. Please enable location and try again.'
        };
      }
      final request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $token';
      // Do NOT add assignment_id to fields, it's in the URL now
      request.fields['latitude'] = latitude;
      request.fields['longitude'] = longitude;
      request.fields['remarks'] = remarks;
      final multipartFile = await http.MultipartFile.fromPath(
        'photo',
        photoPath,
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(multipartFile);
      print('[API REQUEST] Form Fields: ${request.fields}');
      print('[API REQUEST] Files: ${request.files.map((f) => 'Field: ${f.field}, Filename: ${f.filename}, ContentType: ${f.contentType}, Length: ${f.length}')}');
      print('[API REQUEST] Sending request...');
      print('[API REQUEST] Request timeout: 30 seconds');
      final streamedResponse = await request.send().timeout(
        Duration(seconds: 30),
        onTimeout: () {
          print('[API REQUEST] ERROR: Request timeout after 30 seconds');
          throw Exception('Request timeout. Please check your internet connection.');
        },
      );
      final response = await http.Response.fromStream(streamedResponse);
      print('=== PHOTO UPLOAD API RESPONSE ===');
      print('[API RESPONSE] Status Code: ${response.statusCode}');
      print('[API RESPONSE] Headers: ${response.headers}');
      print('[API RESPONSE] Content Length: ${response.contentLength}');
      print('[API RESPONSE] Body: ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('[API RESPONSE] Success - Parsing JSON response...');
        final decoded = jsonDecode(response.body);
        print('[API RESPONSE] Parsed JSON: $decoded');
        final result = {
          'success': true,
          'message': decoded['message'] ?? 'Photo uploaded successfully',
          'data': decoded
        };
        print('[API RESPONSE] Final Result: $result');
        print('=== PHOTO UPLOAD API REQUEST END (SUCCESS) ===');
        return result;
      } else {
        print('[API RESPONSE] Error - Non-success status code');
        print('[API RESPONSE] Status Code Details: ${response.statusCode}');
        print('[API RESPONSE] Reason Phrase: ${response.reasonPhrase}');
        try {
          final decoded = jsonDecode(response.body);
          print('[API RESPONSE] Error JSON: $decoded');
          String errorMessage = 'Upload failed';
          if (decoded['message'] != null && decoded['message'].toString().isNotEmpty) {
            errorMessage = decoded['message'].toString();
          } else if (response.statusCode == 500) {
            errorMessage = 'Server error: Assignment ID $assignmentId might not exist or server configuration issue. Please contact support.';
          } else if (response.statusCode == 413) {
            errorMessage = 'File too large. Please choose a smaller image.';
          } else if (response.statusCode == 401) {
            errorMessage = 'Authentication failed. Please login again.';
          } else if (response.statusCode == 403) {
            errorMessage = 'Permission denied. Contact support.';
          } else if (response.statusCode == 422) {
            errorMessage = 'Invalid data provided. Check photo and location.';
          } else {
            errorMessage = 'Upload failed with status ${response.statusCode}';
          }
          final result = {
            'success': false,
            'message': errorMessage,
            'statusCode': response.statusCode,
            'rawResponse': decoded
          };
          print('[API RESPONSE] Error Result: $result');
          print('=== PHOTO UPLOAD API REQUEST END (ERROR) ===');
          return result;
        } catch (parseError) {
          print('[API RESPONSE] Failed to parse error JSON: $parseError');
          print('[API RESPONSE] Raw error body: ${response.body}');
          String errorMessage = 'Upload failed';
          if (response.statusCode == 500) {
            errorMessage = 'Server error: Assignment ID $assignmentId might not exist or server configuration issue. Please contact support.';
          } else if (response.statusCode == 413) {
            errorMessage = 'File too large. Please choose a smaller image.';
          } else if (response.statusCode == 401) {
            errorMessage = 'Authentication failed. Please login again.';
          } else if (response.statusCode == 403) {
            errorMessage = 'Permission denied. Contact support.';
          } else {
            errorMessage = 'Upload failed with status ${response.statusCode}';
          }
          final result = {
            'success': false,
            'message': errorMessage,
            'statusCode': response.statusCode,
            'rawBody': response.body
          };
          print('[API RESPONSE] Default Error Result: $result');
          print('=== PHOTO UPLOAD API REQUEST END (PARSE ERROR) ===');
          return result;
        }
      }
    } catch (e) {
      print('=== PHOTO UPLOAD API EXCEPTION ===');
      print('[API EXCEPTION] Error Type: ${e.runtimeType}');
      print('[API EXCEPTION] Error Message: $e');
      print('[API EXCEPTION] Stack Trace: ${StackTrace.current}');
      
      final result = {
        'success': false,
        'message': 'Network error: ${e.toString()}'
      };
      print('[API EXCEPTION] Exception Result: $result');
      print('=== PHOTO UPLOAD API REQUEST END (EXCEPTION) ===');
      return result;
    }
  }

  // Mitanin photo upload for mothers
  static Future<Map<String, dynamic>> uploadMitaninPlantPhoto({
    required int assignmentId,
    required String photoPath,
    required String latitude,
    required String longitude,
    required String remarks,
  }) async {
    try {
      print('=== MITANIN PHOTO UPLOAD API REQUEST START ===');
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      // Use the mitanin endpoint
      final url = Uri.parse('${AppConstants.baseUrl}/mitanin/plants/$assignmentId/upload-photo');
      print('[API REQUEST] Method: POST');
      print('[API REQUEST] URL: $url');
      print('[API REQUEST] Assignment ID: $assignmentId');
      print('[API REQUEST] Photo Path: $photoPath');
      print('[API REQUEST] Latitude: $latitude');
      print('[API REQUEST] Longitude: $longitude');
      print('[API REQUEST] Remarks: $remarks');
      print('[API REQUEST] Auth Token: Bearer ${token != null ? '${token.substring(0, 20)}...' : 'NULL'}');
      
      if (token == null) {
        print('[API ERROR] No auth token found in shared preferences');
        return {
          'success': false,
          'message': 'प्रमाणीकरण टोकन नहीं मिला। कृपया पुनः लॉगिन करें।',
          'statusCode': 401
        };
      }

      final file = File(photoPath);
      if (!await file.exists()) {
        print('[API REQUEST] ERROR: Photo file does not exist at path: $photoPath');
        return {
          'success': false,
          'message': 'Photo file not found. Please take photo again.'
        };
      }

      final fileSize = await file.length();
      print('[API REQUEST] Photo file size: ${fileSize} bytes (${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB)');
      
      if (fileSize > 10 * 1024 * 1024) {
        print('[API REQUEST] ERROR: Photo file too large: ${fileSize} bytes');
        return {
          'success': false,
          'message': 'Photo file too large. Please choose a smaller image.'
        };
      }
      
      if (fileSize == 0) {
        print('[API REQUEST] ERROR: Photo file is empty: ${fileSize} bytes');
        return {
          'success': false,
          'message': 'Photo file is empty. Please take photo again.'
        };
      }

      try {
        final lat = double.parse(latitude);
        final lng = double.parse(longitude);
        print('[API REQUEST] Parsed coordinates: lat=$lat, lng=$lng');
        if (lat.abs() > 90 || lng.abs() > 180) {
          print('[API REQUEST] ERROR: Invalid coordinates: lat=$lat, lng=$lng');
          return {
            'success': false,
            'message': 'Invalid GPS coordinates. Please enable location and try again.'
          };
        }
      } catch (e) {
        print('[API REQUEST] ERROR: Invalid coordinate format: lat=$latitude, lng=$longitude, error=$e');
        return {
          'success': false,
          'message': 'Invalid location data. Please enable location and try again.'
        };
      }

      final request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['latitude'] = latitude;
      request.fields['longitude'] = longitude;
      request.fields['remarks'] = remarks;

      final multipartFile = await http.MultipartFile.fromPath(
        'photo',
        photoPath,
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(multipartFile);

      print('[API REQUEST] Form Fields: ${request.fields}');
      print('[API REQUEST] Files: ${request.files.map((f) => 'Field: ${f.field}, Filename: ${f.filename}, ContentType: ${f.contentType}, Length: ${f.length}')}');
      print('[API REQUEST] Sending request...');
      print('[API REQUEST] Request timeout: 30 seconds');

      final streamedResponse = await request.send().timeout(
        Duration(seconds: 30),
        onTimeout: () {
          print('[API REQUEST] ERROR: Request timeout after 30 seconds');
          throw Exception('Request timeout. Please check your internet connection.');
        },
      );

      final response = await http.Response.fromStream(streamedResponse);
      print('=== MITANIN PHOTO UPLOAD API RESPONSE ===');
      print('[API RESPONSE] Status Code: ${response.statusCode}');
      print('[API RESPONSE] Headers: ${response.headers}');
      print('[API RESPONSE] Content Length: ${response.contentLength}');
      print('[API RESPONSE] Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('[API RESPONSE] Success - Parsing JSON response...');
        final decoded = jsonDecode(response.body);
        print('[API RESPONSE] Parsed JSON: $decoded');
        final result = {
          'success': true,
          'message': decoded['message'] ?? 'Photo uploaded successfully by mitanin',
          'data': decoded
        };
        print('[API RESPONSE] Final Result: $result');
        print('=== MITANIN PHOTO UPLOAD API REQUEST END (SUCCESS) ===');
        return result;
      } else {
        try {
          final decoded = jsonDecode(response.body);
          String errorMessage = decoded['message'] ?? 'Upload failed';
          if (response.statusCode == 404) {
            errorMessage = 'Plant assignment not found or does not belong to your hospital';
          } else if (response.statusCode == 401) {
            errorMessage = 'Authentication failed. Please login again.';
          } else if (response.statusCode == 403) {
            errorMessage = 'You do not have permission to upload photos for this assignment';
          } else if (response.statusCode == 422) {
            errorMessage = 'Invalid data provided. Check photo and location.';
          } else {
            errorMessage = 'Upload failed with status ${response.statusCode}';
          }
          final result = {
            'success': false,
            'message': errorMessage,
            'statusCode': response.statusCode,
            'rawResponse': decoded
          };
          print('[API RESPONSE] Error Result: $result');
          print('=== MITANIN PHOTO UPLOAD API REQUEST END (ERROR) ===');
          return result;
        } catch (parseError) {
          print('[API RESPONSE] Failed to parse error JSON: $parseError');
          print('[API RESPONSE] Raw error body: ${response.body}');
          String errorMessage = 'Upload failed';
          if (response.statusCode == 500) {
            errorMessage = 'Server error: Assignment ID $assignmentId might not exist or server configuration issue. Please contact support.';
          } else if (response.statusCode == 413) {
            errorMessage = 'Photo file too large. Please choose a smaller image.';
          } else {
            errorMessage = 'Network error: Unable to upload photo. Status: ${response.statusCode}';
          }
          final result = {
            'success': false,
            'message': errorMessage,
            'statusCode': response.statusCode,
            'rawBody': response.body
          };
          print('[API RESPONSE] Default Error Result: $result');
          print('=== MITANIN PHOTO UPLOAD API REQUEST END (PARSE ERROR) ===');
          return result;
        }
      }
    } catch (e) {
      print('=== MITANIN PHOTO UPLOAD API EXCEPTION ===');
      print('[API EXCEPTION] Error Type: ${e.runtimeType}');
      print('[API EXCEPTION] Error Message: $e');
      print('[API EXCEPTION] Stack Trace: ${StackTrace.current}');
      
      final result = {
        'success': false,
        'message': 'Network error: ${e.toString()}'
      };
      print('[API EXCEPTION] Exception Result: $result');
      print('=== MITANIN PHOTO UPLOAD API REQUEST END (EXCEPTION) ===');
      return result;
    }
  }

  static Future<HospitalDashboardResponse?> getHospitalDashboard() async {
    final token = await _getToken();
    final url = Uri.parse('${AppConstants.baseUrl}/hospital/dashboard');
    print('[API REQUEST] GET: $url');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    print('[API RESPONSE] ${response.statusCode}: ${response.body}');
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      // Save to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('dashboarddata', response.body);
      return HospitalDashboardResponse.fromJson(decoded);
    }
    return null;
  }

  static Future<MothersListResponse?> getMothers({int page = 1}) async {
    try {
      final token = await _getToken();
      final url = Uri.parse('${AppConstants.baseUrl}/hospital/mothers?page=$page');
      
      print('[API REQUEST] GET: $url');
      
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      
      print('[API RESPONSE] ${response.statusCode}: ${response.body}');
      
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return MothersListResponse.fromJson(decoded);
      }
      return null;
    } catch (e) {
      print('[API ERROR] getMothers: $e');
      return null;
    }
  }

  static Future<MotherDetailResponse?> getMotherDetail(int childId) async {
    try {
      final token = await _getToken();
      final url = Uri.parse('${AppConstants.baseUrl}/hospital/mothers/$childId');
      
      print('[API REQUEST] GET: $url');
      
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      
      print('[API RESPONSE] ${response.statusCode}: ${response.body}');
      
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return MotherDetailResponse.fromJson(decoded);
      }
      return null;
    } catch (e) {
      print('[API ERROR] getMotherDetail: $e');
      return null;
    }
  }

  static Future<PendingVerificationResponse?> getPendingVerificationPhotos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final url = Uri.parse('${AppConstants.baseUrl}/mitanin/pending-verification');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return PendingVerificationResponse.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error fetching pending verification photos: $e');
      return null;
    }
  }

  static Future<UploadedPhotosResponse?> getUploadedPhotos({int page = 1, int limit = 10}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final url = Uri.parse('${AppConstants.baseUrl}/mitanin/uploaded-photos?page=$page&limit=$limit');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return UploadedPhotosResponse.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error fetching uploaded photos: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getMitaninMotherPlants(String childId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final url = Uri.parse('${AppConstants.baseUrl}/mitanin/mothers/$childId/plants');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      }
      return null;
    } catch (e) {
      print('Error fetching mitanin mother plants: $e');
      return null;
    }
  }

  // Get plant details for mitanin
  static Future<Map<String, dynamic>?> getMitaninPlantDetails(int assignmentId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final url = Uri.parse('${AppConstants.baseUrl}/mitanin/plants/$assignmentId/details');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      }
      return null;
    } catch (e) {
      print('Error fetching mitanin plant details: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> verifyPhoto({
    required int photoId,
    required String verificationStatus,
    required String verificationRemarks,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final url = Uri.parse('${AppConstants.baseUrl}/mitanin/verify-photo/$photoId');
      
      print('[API REQUEST] PUT: $url');
      print('[API REQUEST BODY]: {verification_status: $verificationStatus, verification_remarks: $verificationRemarks}');
      
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'verification_status': verificationStatus,
          'verification_remarks': verificationRemarks,
        }),
      );
      
      print('[API RESPONSE] ${response.statusCode}: ${response.body}');
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Error verifying photo: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getMitaninDashboard() async {
    try {
      final token = await _getToken();
      final url = Uri.parse('${AppConstants.baseUrl}/mitanin/dashboard');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Error fetching mitanin dashboard: $e');
      return null;
    }
  }

  // Helper to get assignment IDs from getMotherPlants()
  static Future<List<int>> getAssignmentIdsFromMotherPlants() async {
    final response = await getMotherPlants();
    if (response != null &&
        response.data.plantSummary.plants.isNotEmpty) {
      // Adjust the property name if your model uses a different field for assignment ID
      return response.data.plantSummary.plants
          .map((plant) => plant.assignmentId)
          .whereType<int>()
          .toList();
    }
    return [];
  }

  static Future<MitaninMotherDetailResponse?> getMitaninMotherDetail(int childId) async {
    try {
      final token = await _getToken();
      final url = Uri.parse('${AppConstants.baseUrl}/mitanin/mothers/$childId');
      print('[API REQUEST] GET: $url');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      print('[API RESPONSE] ${response.statusCode}: ${response.body}');
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return MitaninMotherDetailResponse.fromJson(decoded);
      }
      return null;
    } catch (e) {
      print('[API ERROR] getMitaninMotherDetail: $e');
      return null;
    }
  }

  static Future<MothersListResponse?> getMothersFromUrl(Uri url, String? token) async {
    try {
      print('[API REQUEST] GET: $url');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      print('[API RESPONSE] ${response.statusCode}: ${response.body}');
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return MothersListResponse.fromJson(decoded);
      }
      return null;
    } catch (e) {
      print('[API ERROR] getMothersFromUrl: $e');
      return null;
    }
  }

  /// Calls the AI prediction API with the given image file and returns the result.
  static Future<Map<String, dynamic>> predictPlantImageAI(String imagePath) async {
    print('[AI API] Starting prediction for: $imagePath');
    const url = 'http://165.22.208.62:4999/predict';
    const maxRetries = 2;
    
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      print('[AI API] Attempt $attempt of $maxRetries');
      
      try {
        final file = File(imagePath);
        if (!await file.exists()) {
          print('[AI API] Error: Image file not found');
          return {
            'success': false,
            'message': 'Image file not found for AI prediction.'
          };
        }

        final fileSize = await file.length();
        print('[AI API] File size: ${fileSize} bytes');
        
        if (fileSize > 10 * 1024 * 1024) { // 10MB limit
          print('[AI API] Error: File too large');
          return {
            'success': false,
            'message': 'Image file too large. Please select a smaller image.'
          };
        }

        print('[AI API] Creating multipart request to: $url');
        final request = http.MultipartRequest('POST', Uri.parse(url));
        
        // Add proper headers
        request.headers.addAll({
          'Accept': 'application/json',
          'User-Agent': 'GreenPalna-Flutter-App/1.0',
        });
        
        // Auto-detect content type based on file extension
        MediaType? contentType;
        final extension = imagePath.toLowerCase().split('.').last;
        switch (extension) {
          case 'jpg':
          case 'jpeg':
            contentType = MediaType('image', 'jpeg');
            break;
          case 'png':
            contentType = MediaType('image', 'png');
            break;
          case 'webp':
            contentType = MediaType('image', 'webp');
            break;
          default:
            contentType = MediaType('image', 'jpeg'); // Default fallback
        }
        
        print('[AI API] Detected file extension: $extension, Content-Type: ${contentType.toString()}');
        
        request.files.add(await http.MultipartFile.fromPath(
          'image', 
          imagePath,
          contentType: contentType,
        ));

        print('[AI API] Sending request with 20 second timeout...');
        final streamedResponse = await request.send().timeout(
          Duration(seconds: 20),
          onTimeout: () {
            print('[AI API] Request timed out after 20 seconds');
            throw TimeoutException('AI server response timeout', Duration(seconds: 20));
          },
        );

        final response = await http.Response.fromStream(streamedResponse);
        print('[AI API] Response received - Status: ${response.statusCode}');

        if (response.statusCode == 200) {
          try {
            final decoded = jsonDecode(response.body);
            print('[AI API] Successfully parsed JSON response');
            
            // Validate response structure
            if (decoded is Map && decoded.containsKey('predicted_class')) {
              print('[AI API] Valid prediction received: ${decoded['predicted_class']}');
              return {
                'success': true,
                'data': decoded
              };
            } else {
              print('[AI API] Invalid response format: $decoded');
              return {
                'success': false,
                'message': 'AI server returned invalid response format'
              };
            }
          } catch (jsonError) {
            print('[AI API] JSON parsing error: $jsonError');
            return {
              'success': false,
              'message': 'Failed to parse AI server response: $jsonError'
            };
          }
        } else if (response.statusCode == 500) {
          print('[AI API] Server error 500 on attempt $attempt');
          if (attempt == maxRetries) {
            return {
              'success': false,
              'message': 'AI server is currently down (500 error). Please try again later.'
            };
          }
          // Wait before retry
          await Future.delayed(Duration(seconds: 2));
          continue;
        } else if (response.statusCode == 404) {
          print('[AI API] 404 error - AI endpoint not found');
          return {
            'success': false,
            'message': 'AI service endpoint not available (404 error)'
          };
        } else {
          print('[AI API] HTTP error ${response.statusCode}: ${response.body}');
          return {
            'success': false,
            'message': 'AI prediction failed with status: ${response.statusCode}',
            'rawBody': response.body
          };
        }
      } on SocketException catch (e) {
        print('[AI API] Network error on attempt $attempt: $e');
        if (attempt == maxRetries) {
          return {
            'success': false,
            'message': 'Network connection error. Please check your internet connection.'
          };
        }
        await Future.delayed(Duration(seconds: 2));
        continue;
      } on TimeoutException catch (e) {
        print('[AI API] Timeout error on attempt $attempt: $e');
        if (attempt == maxRetries) {
          return {
            'success': false,
            'message': 'AI server response timeout. Please check your internet connection and try again.'
          };
        }
        await Future.delayed(Duration(seconds: 2));
        continue;
      } catch (e) {
        print('[AI API] Unexpected error on attempt $attempt: ${e.runtimeType} - $e');
        if (attempt == maxRetries) {
          return {
            'success': false,
            'message': 'AI prediction error: ${e.toString()}'
          };
        }
        await Future.delayed(Duration(seconds: 2));
        continue;
      }
    }
    
    // This should never be reached, but just in case
    return {
      'success': false,
      'message': 'AI prediction failed after multiple attempts'
    };
  }
}

Future<LoginResponse> loginUser(String userId, String password, String loginType) async {
  print('=== LOGIN API REQUEST START ===');
  final url = Uri.parse('${AppConstants.baseUrl}/auth/login');
  
  print('[API REQUEST] Method: POST');
  print('[API REQUEST] URL: $url');
  print('[API REQUEST] User ID: $userId');
  print('[API REQUEST] Login Type: $loginType');
  print('[API REQUEST] Password: [HIDDEN]');
  print('[API REQUEST] Headers: Content-Type: application/json');
  
  final requestBody = {
    'userId': userId,
    'password': password,
    'loginType': loginType,
  };
  print('[API REQUEST] Body: {userId: $userId, password: [HIDDEN], loginType: $loginType}');
  
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(requestBody),
  );
  
  print('=== LOGIN API RESPONSE ===');
  print('[API RESPONSE] Status Code: ${response.statusCode}');
  print('[API RESPONSE] Headers: ${response.headers}');
  print('[API RESPONSE] Body: ${response.body}');

  if (response.statusCode == 200) {
    print('[API RESPONSE] Success - Parsing JSON response...');
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    print('[API PARSING] Response Data Keys: ${responseData.keys.toList()}');
    print('[API PARSING] Success: ${responseData['success']}');
    print('[API PARSING] Message: ${responseData['message']}');
    
    if (responseData['success'] == true) {
      try {
        // Pass the whole responseData to LoginResponse.fromJson
        final loginResponse = LoginResponse.fromJson(responseData);
        print('[API PARSING] Successfully parsed LoginResponse');
        print('[API PARSING] User Role: ${loginResponse.user.role}');
        print('[API PARSING] User Name: ${loginResponse.user.name}');
        print('[API PARSING] Token Length: ${loginResponse.token.length}');
        
        // Save login response
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', loginResponse.token);
        await prefs.setString('refresh_token', loginResponse.refreshToken);
        await prefs.setString('user_data', jsonEncode(loginResponse.user.toJson()));
        
        print('[API STORAGE] Saved auth_token, refresh_token, and user_data to SharedPreferences');
        print('=== LOGIN API REQUEST END (SUCCESS) ===');
        return loginResponse;
      } catch (parseError) {
        print('[API PARSING] Error parsing LoginResponse: $parseError');
        print('[API PARSING] Stack trace: ${StackTrace.current}');
        print('=== LOGIN API REQUEST END (PARSE ERROR) ===');
        throw Exception('Failed to parse login response: $parseError');
      }
    } else {
      print('[API ERROR] Login failed - success: false');
      print('[API ERROR] Error message: ${responseData['message']}');
      print('=== LOGIN API REQUEST END (LOGIN FAILED) ===');
      throw Exception(responseData['message'] ?? 'Login failed');
    }
  } else {
    print('[API ERROR] Non-200 status code: ${response.statusCode}');
    print('[API ERROR] Response body: ${response.body}');
    print('=== LOGIN API REQUEST END (HTTP ERROR) ===');
    throw Exception('Failed to login: ${response.statusCode}');
  }
}

Future<bool> changePassword({
  required String currentPassword,
  required String newPassword,
  required String confirmPassword,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
  if (token == null) {
    throw Exception('No auth token found');
  }
  final url = Uri.parse('${AppConstants.baseUrl}/auth/change-password');
  print('[API REQUEST] POST: $url, body: {currentPassword: [HIDDEN], newPassword: [HIDDEN], confirmPassword: [HIDDEN]}');
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'currentPassword': currentPassword,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    }),
  );
  print('[API RESPONSE] ${response.statusCode}: ${response.body}');
  final Map<String, dynamic> responseData = jsonDecode(response.body);
  if (response.statusCode == 200 && responseData['success'] == true) {
    return true;
  } else {
    throw Exception(responseData['message'] ?? 'Failed to change password');
  }
}
