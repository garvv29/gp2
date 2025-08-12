class MotherDetailResponse {
  final bool success;
  final String message;
  final MotherDetailData data;

  MotherDetailResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory MotherDetailResponse.fromJson(Map<String, dynamic> json) {
    return MotherDetailResponse(
      success: json['success'],
      message: json['message'],
      data: MotherDetailData.fromJson(json['data']),
    );
  }
}

class MotherDetailData {
  final ChildInfo childInfo;
  final LocationDetails locationDetails;
  final UserAccount userAccount;
  final GovernmentSchemes governmentSchemes;
  final AdditionalInfo additionalInfo;
  final PlantTrackingInfo plantTrackingInfo;

  MotherDetailData({
    required this.childInfo,
    required this.locationDetails,
    required this.userAccount,
    required this.governmentSchemes,
    required this.additionalInfo,
    required this.plantTrackingInfo,
  });

  factory MotherDetailData.fromJson(Map<String, dynamic> json) {
    return MotherDetailData(
      childInfo: ChildInfo.fromJson(json['child_info']),
      locationDetails: LocationDetails.fromJson(json['location_details']),
      userAccount: UserAccount.fromJson(json['user_account']),
      governmentSchemes: GovernmentSchemes.fromJson(json['government_schemes'] ?? {}),
      additionalInfo: AdditionalInfo.fromJson(json['additional_info'] ?? {}),
      plantTrackingInfo: PlantTrackingInfo.fromJson(json['plant_tracking_info'] ?? {}),
    );
  }
}

class ChildInfo {
  final int childId;
  final String childName;
  final String motherName;
  final String fatherHusbandName;
  final String motherMobile;
  final String deliveryDate;
  final String deliveryTime;
  final String deliveryType;
  final String bloodGroup;
  final String childGender;
  final String childOrder;
  final String weightAtBirth;
  final String registrationDate;
  final String lastUpdated;
  final bool isActive;
  final String? villageName;
  final String? userVillage;
  final String? userAddress;

  ChildInfo({
    required this.childId,
    required this.childName,
    required this.motherName,
    required this.fatherHusbandName,
    required this.motherMobile,
    required this.deliveryDate,
    required this.deliveryTime,
    required this.deliveryType,
    required this.bloodGroup,
    required this.childGender,
    required this.childOrder,
    required this.weightAtBirth,
    required this.registrationDate,
    required this.lastUpdated,
    required this.isActive,
    this.villageName,
    this.userVillage,
    this.userAddress,
  });

  factory ChildInfo.fromJson(Map<String, dynamic> json) {
    return ChildInfo(
      childId: json['child_id'],
      childName: json['child_name'] ?? '',
      motherName: json['mother_name'] ?? '',
      fatherHusbandName: json['father_husband_name'] ?? '',
      motherMobile: json['mother_mobile'] ?? '',
      deliveryDate: json['delivery_date'] ?? '',
      deliveryTime: json['delivery_time'] ?? '',
      deliveryType: json['delivery_type'] ?? '',
      bloodGroup: json['blood_group'] ?? '',
      childGender: json['child_gender'] ?? '',
      childOrder: json['child_order'] ?? '',
      weightAtBirth: json['weight_at_birth'] ?? '',
      registrationDate: json['registration_date'] ?? '',
      lastUpdated: json['last_updated'] ?? '',
      isActive: json['is_active'] ?? false,
      villageName: json['village_name'],
      userVillage: json['user_village'],
      userAddress: json['user_address'],
    );
  }
}

class LocationDetails {
  final DistrictDetail district;
  final BlockDetail block;
  final VillageDetail village;

  LocationDetails({
    required this.district,
    required this.block,
    required this.village,
  });

  factory LocationDetails.fromJson(Map<String, dynamic> json) {
    return LocationDetails(
      district: DistrictDetail.fromJson(json['district']),
      block: BlockDetail.fromJson(json['block']),
      village: VillageDetail.fromJson(json['village']),
    );
  }
}

class DistrictDetail {
  final int districtCode;
  final String districtName;
  final int lgdDistrictCode;

  DistrictDetail({
    required this.districtCode,
    required this.districtName,
    required this.lgdDistrictCode,
  });

  factory DistrictDetail.fromJson(Map<String, dynamic> json) {
    return DistrictDetail(
      districtCode: json['district_code'],
      districtName: json['district_name'],
      lgdDistrictCode: json['lgd_district_code'],
    );
  }
}

class BlockDetail {
  final int blockCode;
  final String blockName;
  final int lgdBlockCode;

  BlockDetail({
    required this.blockCode,
    required this.blockName,
    required this.lgdBlockCode,
  });

  factory BlockDetail.fromJson(Map<String, dynamic> json) {
    return BlockDetail(
      blockCode: json['block_code'],
      blockName: json['block_name'],
      lgdBlockCode: json['lgd_block_code'],
    );
  }
}

class VillageDetail {
  final int villageCode;
  final String villageName;
  final int? villageLgdCode;

  VillageDetail({
    required this.villageCode,
    required this.villageName,
    this.villageLgdCode,
  });

  factory VillageDetail.fromJson(Map<String, dynamic> json) {
    return VillageDetail(
      villageCode: json['village_code'],
      villageName: json['village_name'],
      villageLgdCode: json['village_lgd_code'],
    );
  }
}

class UserAccount {
  final int userId;
  final String userid;
  final String name;
  final String mobile;
  final bool isPasswordChanged;
  final bool isActive;
  final String accountCreated;

  UserAccount({
    required this.userId,
    required this.userid,
    required this.name,
    required this.mobile,
    required this.isPasswordChanged,
    required this.isActive,
    required this.accountCreated,
  });

  factory UserAccount.fromJson(Map<String, dynamic> json) {
    return UserAccount(
      userId: json['user_id'],
      userid: json['userid'],
      name: json['name'],
      mobile: json['mobile'],
      isPasswordChanged: json['is_password_changed'],
      isActive: json['is_active'],
      accountCreated: json['account_created'],
    );
  }
}

class GovernmentSchemes {
  final String? mmjy;
  final String? pmmvy;
  final Map<String, dynamic>? description;

  GovernmentSchemes({this.mmjy, this.pmmvy, this.description});

  factory GovernmentSchemes.fromJson(Map<String, dynamic> json) {
    return GovernmentSchemes(
      mmjy: json['mmjy'],
      pmmvy: json['pmmvy'],
      description: json['description'],
    );
  }
}

class AdditionalInfo {
  final String? birthCertificate;
  final String? isShramikCard;
  final String? isUsedAyushmanCard;
  final String? ayushmanCardAmount;
  final String? isBenefitNsy;
  final String? isNsyForm;
  final String? weightAtBirth;

  AdditionalInfo({
    this.birthCertificate,
    this.isShramikCard,
    this.isUsedAyushmanCard,
    this.ayushmanCardAmount,
    this.isBenefitNsy,
    this.isNsyForm,
    this.weightAtBirth,
  });

  factory AdditionalInfo.fromJson(Map<String, dynamic> json) {
    return AdditionalInfo(
      birthCertificate: json['birth_certificate'],
      isShramikCard: json['is_shramik_card'],
      isUsedAyushmanCard: json['is_used_ayushman_card'],
      ayushmanCardAmount: json['ayushman_card_amount'],
      isBenefitNsy: json['is_benefit_nsy'],
      isNsyForm: json['is_nsy_form'],
      weightAtBirth: json['weight_at_birth'],
    );
  }
}

class PlantTrackingInfo {
  final int totalAssignments;
  final int totalSchedules;
  final String? trackingDuration;
  final String? photoFrequency;
  final List<PlantAssignment> assignments;

  PlantTrackingInfo({
    required this.totalAssignments,
    required this.totalSchedules,
    this.trackingDuration,
    this.photoFrequency,
    required this.assignments,
  });

  factory PlantTrackingInfo.fromJson(Map<String, dynamic> json) {
    return PlantTrackingInfo(
      totalAssignments: json['total_assignments'] ?? 0,
      totalSchedules: json['total_schedules'] ?? 0,
      trackingDuration: json['tracking_duration'],
      photoFrequency: json['photo_frequency'],
      assignments: (json['assignments'] as List<dynamic>? ?? [])
          .map((e) => PlantAssignment.fromJson(e)).toList(),
    );
  }
}

class PlantAssignment {
  final int assignmentId;
  final PlantInfo plantInfo;
  final AssignmentDetails assignmentDetails;

  PlantAssignment({
    required this.assignmentId,
    required this.plantInfo,
    required this.assignmentDetails,
  });

  factory PlantAssignment.fromJson(Map<String, dynamic> json) {
    return PlantAssignment(
      assignmentId: json['assignment_id'],
      plantInfo: PlantInfo.fromJson(json['plant_info']),
      assignmentDetails: AssignmentDetails.fromJson(json['assignment_details']),
    );
  }
}

class PlantInfo {
  final int plantId;
  final String plant_name;
  final String plant_local_name;
  final String plant_category;

  PlantInfo({
    required this.plantId,
    required this.plant_name,
    required this.plant_local_name,
    required this.plant_category,
  });

  factory PlantInfo.fromJson(Map<String, dynamic> json) {
    return PlantInfo(
      plantId: json['plant_id'],
      plant_name: json['plant_name'] ?? '',
      plant_local_name: json['plant_local_name'] ?? '',
      plant_category: json['plant_category'] ?? '',
    );
  }
}

class AssignmentDetails {
  final String assignedDate;
  final String status;
  final String notes;

  AssignmentDetails({
    required this.assignedDate,
    required this.status,
    required this.notes,
  });

  factory AssignmentDetails.fromJson(Map<String, dynamic> json) {
    return AssignmentDetails(
      assignedDate: json['assigned_date'] ?? '',
      status: json['status'] ?? '',
      notes: json['notes'] ?? '',
    );
  }
}
