class MitaninMotherDetailResponse {
  final bool success;
  final String message;
  final MitaninMotherDetailData data;

  MitaninMotherDetailResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory MitaninMotherDetailResponse.fromJson(Map<String, dynamic> json) {
    return MitaninMotherDetailResponse(
      success: json['success'],
      message: json['message'],
      data: MitaninMotherDetailData.fromJson(json['data']),
    );
  }
}

class MitaninMotherDetailData {
  final MitaninChildInfo childInfo;
  final MitaninLocationDetails locationDetails;
  final MitaninUserAccount userAccount;

  MitaninMotherDetailData({
    required this.childInfo,
    required this.locationDetails,
    required this.userAccount,
  });

  factory MitaninMotherDetailData.fromJson(Map<String, dynamic> json) {
    return MitaninMotherDetailData(
      childInfo: MitaninChildInfo.fromJson(json['child_info']),
      locationDetails: MitaninLocationDetails.fromJson(json['location_details']),
      userAccount: MitaninUserAccount.fromJson(json['user_account']),
    );
  }
}

class MitaninChildInfo {
  final int childId;
  final String childName;
  final String motherName;
  final String motherMobile;
  final String deliveryDate;
  final String childGender;
  final String registrationDate;
  final String lastUpdated;
  final bool isActive;

  MitaninChildInfo({
    required this.childId,
    required this.childName,
    required this.motherName,
    required this.motherMobile,
    required this.deliveryDate,
    required this.childGender,
    required this.registrationDate,
    required this.lastUpdated,
    required this.isActive,
  });

  factory MitaninChildInfo.fromJson(Map<String, dynamic> json) {
    return MitaninChildInfo(
      childId: json['child_id'],
      childName: json['child_name'],
      motherName: json['mother_name'],
      motherMobile: json['mother_mobile'],
      deliveryDate: json['delivery_date'],
      childGender: json['child_gender'],
      registrationDate: json['registration_date'],
      lastUpdated: json['last_updated'],
      isActive: json['is_active'],
    );
  }
}

class MitaninLocationDetails {
  final MitaninDistrict district;
  final MitaninBlock block;
  final MitaninVillage? village;

  MitaninLocationDetails({
    required this.district,
    required this.block,
    this.village,
  });

  factory MitaninLocationDetails.fromJson(Map<String, dynamic> json) {
    return MitaninLocationDetails(
      district: MitaninDistrict.fromJson(json['district']),
      block: MitaninBlock.fromJson(json['block']),
      village: json['village'] != null ? MitaninVillage.fromJson(json['village']) : null,
    );
  }
}

class MitaninDistrict {
  final int districtCode;
  final String districtName;
  final int lgdDistrictCode;

  MitaninDistrict({
    required this.districtCode,
    required this.districtName,
    required this.lgdDistrictCode,
  });

  factory MitaninDistrict.fromJson(Map<String, dynamic> json) {
    return MitaninDistrict(
      districtCode: json['district_code'],
      districtName: json['district_name'],
      lgdDistrictCode: json['lgd_district_code'],
    );
  }
}

class MitaninBlock {
  final int blockCode;
  final String blockName;
  final int lgdBlockCode;

  MitaninBlock({
    required this.blockCode,
    required this.blockName,
    required this.lgdBlockCode,
  });

  factory MitaninBlock.fromJson(Map<String, dynamic> json) {
    return MitaninBlock(
      blockCode: json['block_code'],
      blockName: json['block_name'],
      lgdBlockCode: json['lgd_block_code'],
    );
  }
}

class MitaninVillage {
  final int? villageCode;
  final String? villageName;
  final int? lgdVillageCode;

  MitaninVillage({
    this.villageCode,
    this.villageName,
    this.lgdVillageCode,
  });

  factory MitaninVillage.fromJson(Map<String, dynamic> json) {
    return MitaninVillage(
      villageCode: json['village_code'],
      villageName: json['village_name'],
      lgdVillageCode: json['lgd_village_code'],
    );
  }
}

class MitaninUserAccount {
  final int userId;
  final String userid;
  final String name;
  final String mobile;
  final bool isPasswordChanged;
  final bool isActive;
  final String accountCreated;

  MitaninUserAccount({
    required this.userId,
    required this.userid,
    required this.name,
    required this.mobile,
    required this.isPasswordChanged,
    required this.isActive,
    required this.accountCreated,
  });

  factory MitaninUserAccount.fromJson(Map<String, dynamic> json) {
    return MitaninUserAccount(
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
