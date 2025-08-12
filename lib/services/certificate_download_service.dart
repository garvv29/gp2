import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class CertificateDownloadService {
  static Future<void> downloadMotherCertificate(BuildContext context) async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Downloading certificate..."),
              ],
            ),
          );
        },
      );

      // Request permissions
      bool hasPermission = await _requestStoragePermission();
      if (!hasPermission) {
        Navigator.of(context).pop(); // Close loading dialog
        _showErrorSnackBar(context, 'Storage permission denied');
        return;
      }

      // Get current user to find child ID
      final currentUser = await AuthService.getCurrentUser();
      if (currentUser == null) {
        Navigator.of(context).pop();
        _showErrorSnackBar(context, 'User not logged in');
        return;
      }

      // Get photos for the mother - call without child ID to get all photos for this mother
      final motherPhotosData = await ApiService.getAllMotherPhotos();
      
      if (motherPhotosData == null) {
        Navigator.of(context).pop();
        _showErrorSnackBar(context, 'Failed to fetch photos');
        return;
      }

      // Find certificate photos
      final certificatePhotos = motherPhotosData.photos
          .where((photo) => photo.photoType == 'certificate')
          .toList();

      if (certificatePhotos.isEmpty) {
        Navigator.of(context).pop();
        _showErrorSnackBar(context, 'No certificate found to download');
        return;
      }

      // Download the first certificate
      final certificatePhoto = certificatePhotos.first;
      await _downloadFile(context, certificatePhoto.photoUrl, 'certificate_${certificatePhoto.id}.jpg');

      Navigator.of(context).pop(); // Close loading dialog
      _showSuccessSnackBar(context, 'Certificate downloaded successfully');

    } catch (e) {
      Navigator.of(context).pop(); // Close loading dialog if still open
      _showErrorSnackBar(context, 'Download failed: ${e.toString()}');
    }
  }

  static Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      
      if (androidInfo.version.sdkInt >= 33) {
        // Android 13+ - Request photos permission
        final photosPermission = await Permission.photos.request();
        return photosPermission.isGranted;
      } else {
        // Android 12 and below - Request storage permission
        final storagePermission = await Permission.storage.request();
        return storagePermission.isGranted;
      }
    }
    return true; // iOS doesn't need explicit permission for downloads folder
  }

  static Future<void> _downloadFile(BuildContext context, String url, String fileName) async {
    try {
      // Download the file
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception('Failed to download file');
      }

      // Get downloads directory
      Directory? downloadsDir;
      if (Platform.isAndroid) {
        downloadsDir = Directory('/storage/emulated/0/Download');
        if (!await downloadsDir.exists()) {
          downloadsDir = await getExternalStorageDirectory();
        }
      } else {
        downloadsDir = await getApplicationDocumentsDirectory();
      }

      if (downloadsDir == null) {
        throw Exception('Could not access downloads directory');
      }

      // Save the file
      final filePath = '${downloadsDir.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

    } catch (e) {
      throw Exception('Failed to save file: ${e.toString()}');
    }
  }

  static void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
