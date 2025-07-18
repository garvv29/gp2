class MotherRegistration {
  final String id;
  final String motherName;
  final String fatherHusbandName;
  final String mobileNumber;
  final DateTime deliveryDate;
  final String deliveryType;
  final String bloodGroup;
  final String district;
  final String block;
  final List<String> selectedPlants;
  final String? certificatePath;
  final String? photoPath;
  final DateTime registrationDate;

  MotherRegistration({
    required this.id,
    required this.motherName,
    required this.fatherHusbandName,
    required this.mobileNumber,
    required this.deliveryDate,
    required this.deliveryType,
    required this.bloodGroup,
    required this.district,
    required this.block,
    required this.selectedPlants,
    this.certificatePath,
    this.photoPath,
    required this.registrationDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'motherName': motherName,
      'fatherHusbandName': fatherHusbandName,
      'mobileNumber': mobileNumber,
      'deliveryDate': deliveryDate.toIso8601String(),
      'deliveryType': deliveryType,
      'bloodGroup': bloodGroup,
      'district': district,
      'block': block,
      'selectedPlants': selectedPlants,
      'certificatePath': certificatePath,
      'photoPath': photoPath,
      'registrationDate': registrationDate.toIso8601String(),
    };
  }

  factory MotherRegistration.fromJson(Map<String, dynamic> json) {
    return MotherRegistration(
      id: json['id'],
      motherName: json['motherName'],
      fatherHusbandName: json['fatherHusbandName'],
      mobileNumber: json['mobileNumber'],
      deliveryDate: DateTime.parse(json['deliveryDate']),
      deliveryType: json['deliveryType'],
      bloodGroup: json['bloodGroup'],
      district: json['district'],
      block: json['block'],
      selectedPlants: List<String>.from(json['selectedPlants']),
      certificatePath: json['certificatePath'],
      photoPath: json['photoPath'],
      registrationDate: DateTime.parse(json['registrationDate']),
    );
  }

  MotherRegistration copyWith({
    String? id,
    String? motherName,
    String? fatherHusbandName,
    String? mobileNumber,
    DateTime? deliveryDate,
    String? deliveryType,
    String? bloodGroup,
    String? district,
    String? block,
    List<String>? selectedPlants,
    String? certificatePath,
    String? photoPath,
    DateTime? registrationDate,
  }) {
    return MotherRegistration(
      id: id ?? this.id,
      motherName: motherName ?? this.motherName,
      fatherHusbandName: fatherHusbandName ?? this.fatherHusbandName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      deliveryType: deliveryType ?? this.deliveryType,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      district: district ?? this.district,
      block: block ?? this.block,
      selectedPlants: selectedPlants ?? this.selectedPlants,
      certificatePath: certificatePath ?? this.certificatePath,
      photoPath: photoPath ?? this.photoPath,
      registrationDate: registrationDate ?? this.registrationDate,
    );
  }
} 