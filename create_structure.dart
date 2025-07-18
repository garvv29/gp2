import 'dart:io';

void main() {
  final files = [
    'lib/main.dart',
    'lib/models/user.dart',
    'lib/models/plant.dart',
    'lib/models/upload.dart',
    'lib/screens/welcome_screen.dart',
    'lib/screens/auth/otp_screen.dart',
    'lib/screens/hospital/hospital_dashboard.dart',
    'lib/screens/mother/mother_dashboard.dart',
    'lib/screens/aww/aww_dashboard.dart',
    'lib/services/auth_service.dart',
    'lib/services/api_service.dart',
    'lib/widgets/custom_button.dart',
    'lib/widgets/plant_card.dart',
    'lib/utils/colors.dart',
    'lib/utils/constants.dart',
    'assets/images/logo.jpg',
    'pubspec.yaml',
  ];

  for (var path in files) {
    final file = File(path);
    file.createSync(recursive: true);
    if (path.endsWith('.dart')) {
      file.writeAsStringSync('// $path\n\nvoid main() {}');
    } else if (path.endsWith('.png')) {
      file.writeAsStringSync(''); // Placeholder, can't add image content
    } else if (path.endsWith('pubspec.yaml')) {
      file.writeAsStringSync('''
name: plant_care_app
description: A Flutter app for plant care.
version: 1.0.0+1
environment:
  sdk: ">=3.0.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter

flutter:
  assets:
    - assets/images/logo.jpg
''');
    }
    print('✅ Created: $path');
  }
}
