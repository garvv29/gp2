# GREEN PALNA - Plant Care Management App

A Flutter application for managing mother registrations and plant care in the Green Palna Yojna program. The app supports bilingual interface (English and Hindi) and provides role-based access for hospital staff, mothers, and AWW (Anganwadi) workers.

## Features

### 🔐 Authentication & Role Management
- Multi-role login system (Hospital Staff, Mother, AWW)
- OTP-based authentication
- Role-specific dashboards

### 👩‍⚕️ Hospital Staff Features
- **Mother Registration Form**: Comprehensive registration with all required fields
- **Local Data Storage**: All registrations stored locally using SharedPreferences
- **Mothers List**: View, search, and manage all registered mothers
- **Statistics Dashboard**: Real-time statistics based on stored data
- **Data Persistence**: Data persists across app restarts until manually deleted

### 🌱 Mother Features
- Plant assignment tracking
- Photo upload capabilities
- Care instructions and tips

### 👩‍🏫 AWW (Anganwadi) Features
- Review plant care uploads
- Progress monitoring
- Report generation

## Local Storage Implementation

The app uses **SharedPreferences** for local data storage, providing:

### ✅ Benefits
- **No Backend Required**: Works completely offline
- **Data Persistence**: Data survives app restarts
- **Fast Performance**: Local storage is instant
- **Privacy**: All data stays on the device
- **Easy Management**: Simple CRUD operations

### 📊 Stored Data
- Mother personal information
- Delivery details
- Address information
- Plant selections
- File paths (certificates and photos)
- Registration timestamps

### 🔧 Storage Operations
- **Save**: `LocalStorageService.saveMotherRegistration()`
- **Retrieve**: `LocalStorageService.getAllMotherRegistrations()`
- **Search**: `LocalStorageService.searchRegistrations()`
- **Delete**: `LocalStorageService.deleteMotherRegistration()`
- **Update**: `LocalStorageService.updateMotherRegistration()`

## Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd green_palna_yojna_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## Usage

### Hospital Staff Workflow
1. **Login** as Hospital Staff
2. **Register New Mother** using the comprehensive form
3. **View All Mothers** in the list screen
4. **Search and Manage** registrations
5. **Monitor Statistics** on the dashboard

### Data Management
- All mother registrations are stored locally
- Data persists until manually deleted
- Search functionality for quick access
- Export capabilities (coming soon)

## Project Structure

```
lib/
├── models/
│   └── mother_registration.dart    # Data model for mother registrations
├── screens/
│   ├── hospital/
│   │   ├── hospital_dashboard.dart
│   │   ├── register_mother_screen.dart
│   │   └── mothers_list_screen.dart
│   ├── mother/
│   │   └── mother_dashboard.dart
│   └── aww/
│       └── aww_dashboard.dart
├── services/
│   ├── local_storage_service.dart  # Local storage operations
│   ├── auth_service.dart
│   └── api_service.dart
└── utils/
    ├── app_localizations.dart      # Bilingual support
    ├── theme.dart
    └── responsive.dart
```

## Local Storage API

### MotherRegistration Model
```dart
class MotherRegistration {
  final String id;
  final String motherName;
  final String fatherHusbandName;
  final String mobileNumber;
  final DateTime deliveryDate;
  final String deliveryType;
  final String bloodGroup;
  final String district;
  final String project;
  final String sector;
  final String anganwadiCenter;
  final List<String> selectedPlants;
  final String? certificatePath;
  final String? photoPath;
  final DateTime registrationDate;
}
```

### Key Methods
```dart
// Save a new registration
await LocalStorageService.saveMotherRegistration(registration);

// Get all registrations
List<MotherRegistration> registrations = await LocalStorageService.getAllMotherRegistrations();

// Search registrations
List<MotherRegistration> results = await LocalStorageService.searchRegistrations("query");

// Delete a registration
await LocalStorageService.deleteMotherRegistration("id");

// Get registration count
int count = await LocalStorageService.getRegistrationCount();
```

## Future Enhancements

- [ ] Data export functionality
- [ ] Backup and restore features
- [ ] Cloud synchronization
- [ ] Advanced search filters
- [ ] Data analytics and reporting
- [ ] Photo management system

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions, please contact the development team or create an issue in the repository.
