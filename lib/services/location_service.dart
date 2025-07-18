import 'package:geolocator/geolocator.dart';

/// Result of location permission request
class LocationPermissionResult {
  final bool granted;
  final String? error;
  final bool shouldOpenSettings;

  LocationPermissionResult({
    required this.granted,
    this.error,
    this.shouldOpenSettings = false,
  });
}

class LocationService {
  static const String _noLocationPermission = 'Location permission not granted';

  /// Request location permission from the user - Shows system permission dialog
  static Future<LocationPermissionResult> requestLocationPermission() async {
    try {
      // First check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return LocationPermissionResult(
          granted: false,
          error: 'स्थान सेवाएं बंद हैं। कृपया सेटिंग्स में जाकर स्थान सेवाएं चालू करें।',
          shouldOpenSettings: true,
        );
      }

      // Check current permission status
      LocationPermission permission = await Geolocator.checkPermission();
      
      // If permission is already granted, return success
      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        return LocationPermissionResult(granted: true);
      }
      
      // If permanently denied, guide to settings
      if (permission == LocationPermission.deniedForever) {
        return LocationPermissionResult(
          granted: false,
          error: 'स्थान की अनुमति स्थायी रूप से मना कर दी गई है। कृपया सेटिंग्स में जाकर अनुमति दें।',
          shouldOpenSettings: true,
        );
      }
      
      // Request permission - this will show the system dialog
      permission = await Geolocator.requestPermission();
      
      // Check the result after user interaction
      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        return LocationPermissionResult(granted: true);
      } else if (permission == LocationPermission.deniedForever) {
        return LocationPermissionResult(
          granted: false,
          error: 'स्थान की अनुमति स्थायी रूप से मना कर दी गई है। कृपया सेटिंग्स में जाकर अनुमति दें।',
          shouldOpenSettings: true,
        );
      } else {
        return LocationPermissionResult(
          granted: false,
          error: 'स्थान की अनुमति आवश्यक है। कृपया अनुमति दें और पुनः प्रयास करें।',
        );
      }
    } catch (e) {
      return LocationPermissionResult(
        granted: false,
        error: 'अनुमति प्राप्त करने में त्रुटि: ${e.toString()}',
      );
    }
  }

  /// Check if location permission is already granted
  static Future<bool> hasLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      return permission == LocationPermission.whileInUse || 
             permission == LocationPermission.always;
    } catch (e) {
      return false;
    }
  }

  /// Get current location
  static Future<Position> getCurrentLocation() async {
    try {
      bool hasPermission = await hasLocationPermission();
      if (!hasPermission) {
        LocationPermissionResult result = await requestLocationPermission();
        if (!result.granted) {
          throw Exception(result.error ?? _noLocationPermission);
        }
      }

      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
    } catch (e) {
      throw Exception('Failed to get location: ${e.toString()}');
    }
  }

  /// Get location string in format "lat, lng"
  static Future<String> getLocationString() async {
    try {
      Position position = await getCurrentLocation();
      return '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
