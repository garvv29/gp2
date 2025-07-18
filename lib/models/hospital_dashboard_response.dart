class HospitalDashboardResponse {
  final bool success;
  final String message;
  final HospitalDashboardData data;

  HospitalDashboardResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory HospitalDashboardResponse.fromJson(Map<String, dynamic> json) {
    return HospitalDashboardResponse(
      success: json['success'],
      message: json['message'],
      data: HospitalDashboardData.fromJson(json['data']),
    );
  }
}

class HospitalDashboardData {
  final HospitalDashboardCounters counters;
  final List<HospitalDistrict> districtList;
  final List<HospitalBlock> blockList;
  final List<HospitalPlant> plantList;

  HospitalDashboardData({
    required this.counters,
    required this.districtList,
    required this.blockList,
    required this.plantList,
  });

  factory HospitalDashboardData.fromJson(Map<String, dynamic> json) {
    return HospitalDashboardData(
      counters: HospitalDashboardCounters.fromJson(json['counters']),
      districtList: (json['district_list'] as List)
          .map((e) => HospitalDistrict.fromJson(e))
          .toList(),
      blockList: (json['block_list'] as List)
          .map((e) => HospitalBlock.fromJson(e))
          .toList(),
      plantList: (json['plant_list'] as List)
          .map((e) => HospitalPlant.fromJson(e))
          .toList(),
    );
  }
}

class HospitalDashboardCounters {
  final int totalMothers;
  final int activePlants;
  final int uploadedPhotos;
  final int distributedPlants;

  HospitalDashboardCounters({
    required this.totalMothers,
    required this.activePlants,
    required this.uploadedPhotos,
    required this.distributedPlants,
  });

  factory HospitalDashboardCounters.fromJson(Map<String, dynamic> json) {
    return HospitalDashboardCounters(
      totalMothers: json['total_mothers'],
      activePlants: json['active_plants'],
      uploadedPhotos: json['uploaded_photos'],
      distributedPlants: json['distributed_plants'],
    );
  }
}

class HospitalDistrict {
  final int districtCode;
  final String? districtName;
  final String? lgdDistrictCode;

  HospitalDistrict({
    required this.districtCode,
    this.districtName,
    this.lgdDistrictCode,
  });

  factory HospitalDistrict.fromJson(Map<String, dynamic> json) {
    return HospitalDistrict(
      districtCode: json['district_code'],
      districtName: json['district_name']?.toString(),
      lgdDistrictCode: json['lgd_district_code']?.toString(),
    );
  }
}

class HospitalBlock {
  final int blockCode;
  final String? blockName;
  final String? lgdBlockCode;
  final int? districtCode;

  HospitalBlock({
    required this.blockCode,
    this.blockName,
    this.lgdBlockCode,
    this.districtCode,
  });

  factory HospitalBlock.fromJson(Map<String, dynamic> json) {
    return HospitalBlock(
      blockCode: json['block_code'],
      blockName: json['block_name']?.toString(),
      lgdBlockCode: json['lgd_block_code']?.toString(),
      districtCode: json['district_code'],
    );
  }
}

class HospitalPlant {
  final int id;
  final String name;
  final String localName;
  final String category;

  HospitalPlant({
    required this.id,
    required this.name,
    required this.localName,
    required this.category,
  });

  factory HospitalPlant.fromJson(Map<String, dynamic> json) {
    return HospitalPlant(
      id: json['id'],
      name: json['name'],
      localName: json['local_name'],
      category: json['category'],
    );
  }
}
