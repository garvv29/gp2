class MotherRegistrationResponse {
  final bool success;
  final String message;
  final MotherRegistrationData data;

  MotherRegistrationResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory MotherRegistrationResponse.fromJson(Map<String, dynamic> json) {
    return MotherRegistrationResponse(
      success: json['success'],
      message: json['message'],
      data: MotherRegistrationData.fromJson(json['data']),
    );
  }
}

class MotherRegistrationData {
  final String registrationId;
  final int childId;
  final int motherUserId;
  final String motherName;
  final String childName;
  final String mobileNumber;
  final String deliveryDate;
  final String childGender;
  final LoginCredentials loginCredentials;
  final LocationInfo location;
  final List<AssignedPlant> assignedPlants;
  final FilesUploaded filesUploaded;

  MotherRegistrationData({
    required this.registrationId,
    required this.childId,
    required this.motherUserId,
    required this.motherName,
    required this.childName,
    required this.mobileNumber,
    required this.deliveryDate,
    required this.childGender,
    required this.loginCredentials,
    required this.location,
    required this.assignedPlants,
    required this.filesUploaded,
  });

  factory MotherRegistrationData.fromJson(Map<String, dynamic> json) {
    return MotherRegistrationData(
      registrationId: json['registration_id']?.toString() ?? '',
      childId: json['child_id'] ?? 0,
      motherUserId: json['mother_user_id'] ?? 0,
      motherName: json['mother_name'] ?? '',
      childName: json['child_name'] ?? '',
      mobileNumber: json['mobile_number'] ?? '',
      deliveryDate: json['delivery_date'] ?? '',
      childGender: json['child_gender'] ?? '',
      loginCredentials: LoginCredentials.fromJson(json['login_credentials']),
      location: LocationInfo.fromJson(json['location']),
      assignedPlants: (json['assigned_plants'] as List? ?? [])
          .map((e) => AssignedPlant.fromJson(e))
          .toList(),
      filesUploaded: FilesUploaded.fromJson(json['files_uploaded'] ?? {}),
    );
  }
}

class LoginCredentials {
  final String userid;
  final String defaultPassword;

  LoginCredentials({
    required this.userid,
    required this.defaultPassword,
  });

  factory LoginCredentials.fromJson(Map<String, dynamic> json) {
    return LoginCredentials(
      userid: json['userid'],
      defaultPassword: json['default_password'],
    );
  }
}

class LocationInfo {
  final String district;
  final String block;
  final String village;

  LocationInfo({
    required this.district,
    required this.block,
    required this.village,
  });

  factory LocationInfo.fromJson(Map<String, dynamic> json) {
    return LocationInfo(
      district: json['district'],
      block: json['block'],
      village: json['village'],
    );
  }
}

class AssignedPlant {
  final int? id;
  final String? name;

  AssignedPlant({
    this.id,
    this.name,
  });

  factory AssignedPlant.fromJson(Map<String, dynamic> json) {
    return AssignedPlant(
      id: json['id'] ?? json['plant_id'],
      name: json['name'] ?? json['plant_name'],
    );
  }
}

class FilesUploaded {
  final bool deliveryDocument;
  final bool motherPhoto;

  FilesUploaded({
    required this.deliveryDocument,
    required this.motherPhoto,
  });

  factory FilesUploaded.fromJson(Map<String, dynamic> json) {
    return FilesUploaded(
      deliveryDocument: json['delivery_document'],
      motherPhoto: json['mother_photo'],
    );
  }
}
