class AppConstants {
  static const String appName = 'Plant Care Monitor';
  static const String baseUrl = 'http://192.168.1.9:3000/api/v1';//https://gpy.ssipmt.in/api/v1 //http://192.168.29.163:3000/api/v1
  static const int otpLength = 6;
  static const int plantsPerMother = 4;
  static const List<String> plantEmojis = ['🌱', '🌿', '🍀', '🌳'];
  static const bool enableApiDebugging = true; // Add this for debugging API responses
}
