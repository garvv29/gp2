import 'dart:convert';

import 'mother_detail_response.dart';

class MothersListResponse {
  final bool success;
  final String message;
  final MothersListData data;

  MothersListResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory MothersListResponse.fromJson(Map<String, dynamic> json) {
    return MothersListResponse(
      success: json['success'],
      message: json['message'],
      data: MothersListData.fromJson(json['data']),
    );
  }
}

class MothersListData {
  final List<MotherListItem> mothers;
  final Pagination pagination;

  MothersListData({
    required this.mothers,
    required this.pagination,
  });

  factory MothersListData.fromJson(Map<String, dynamic> json) {
    return MothersListData(
      mothers: (json['mothers'] as List)
          .map((e) => MotherListItem.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}

class PlantQuantityItem {
  final int plantId;
  final int quantity;
  final String status;

  PlantQuantityItem({
    required this.plantId,
    required this.quantity,
    required this.status,
  });

  factory PlantQuantityItem.fromJson(Map<String, dynamic> json) {
    return PlantQuantityItem(
      plantId: json['plant_id'] ?? 0,
      quantity: json['quantity'] ?? 0,
      status: json['status'] ?? '',
    );
  }
}

class MotherListItem {
  final int childId;
  final String motherName;
  final String fatherHusbandName;
  final String childName;
  final String motherMobile;
  final String deliveryDate;
  final String deliveryTime;
  final String deliveryType;
  final String bloodGroup;
  final String childGender;
  final String childOrder;
  final String weightAtBirth;
  final LocationSummary location;
  final String registrationDate;
  final GovernmentSchemes? governmentSchemes;
  final AdditionalInfo? additionalInfo;
  final List<PlantQuantityItem> plantQuantityList;
  final int? uploadedPhotos; // Add photo count field
  final int? totalPlants; // Add total plants count field

  MotherListItem({
    required this.childId,
    required this.motherName,
    required this.fatherHusbandName,
    required this.childName,
    required this.motherMobile,
    required this.deliveryDate,
    required this.deliveryTime,
    required this.deliveryType,
    required this.bloodGroup,
    required this.childGender,
    required this.childOrder,
    required this.weightAtBirth,
    required this.location,
    required this.registrationDate,
    this.governmentSchemes,
    this.additionalInfo,
    required this.plantQuantityList,
    this.uploadedPhotos,
    this.totalPlants,
  });

  factory MotherListItem.fromJson(Map<String, dynamic> json) {
    List<PlantQuantityItem> plantList = [];
    if (json['plant_quantity'] != null && json['plant_quantity'] is String) {
      try {
        final decoded = jsonDecode(json['plant_quantity']);
        if (decoded is List) {
          plantList = decoded.map((e) => PlantQuantityItem.fromJson(e)).toList();
        }
      } catch (_) {}
    }
    return MotherListItem(
      childId: json['child_id'] ?? 0,
      motherName: json['mother_name'] ?? '',
      fatherHusbandName: json['father_husband_name'] ?? '',
      childName: json['child_name'] ?? '',
      motherMobile: json['mother_mobile'] ?? '',
      deliveryDate: json['delivery_date'] ?? '',
      deliveryTime: json['delivery_time'] ?? '',
      deliveryType: json['delivery_type'] ?? '',
      bloodGroup: json['blood_group'] ?? '',
      childGender: json['child_gender'] ?? '',
      childOrder: json['child_order'] ?? '',
      weightAtBirth: json['weight_at_birth'] ?? '',
      location: LocationSummary.fromJson(json['location'] ?? {}),
      registrationDate: json['registration_date'] ?? '',
      governmentSchemes: json['government_schemes'] != null
          ? GovernmentSchemes.fromJson(json['government_schemes'])
          : null,
      additionalInfo: json['additional_info'] != null
          ? AdditionalInfo.fromJson(json['additional_info'])
          : null,
      plantQuantityList: plantList,
      uploadedPhotos: json['uploaded_photos'] ?? 0,
      totalPlants: json['total_plants'] ?? plantList.length,
    );
  }
}

class LocationSummary {
  final String districtName;
  final String blockName;
  final String villageName;

  LocationSummary({
    required this.districtName,
    required this.blockName,
    required this.villageName,
  });

  factory LocationSummary.fromJson(Map<String, dynamic> json) {
    return LocationSummary(
      districtName: json['district_name'],
      blockName: json['block_name'],
      villageName: json['village_name'],
    );
  }
}

class Pagination {
  final int currentPage;
  final int totalPages;
  final int totalRecords;
  final int perPage;
  final bool hasNextPage;
  final bool hasPrevPage;

  Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalRecords,
    required this.perPage,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['current_page'],
      totalPages: json['total_pages'],
      totalRecords: json['total_records'],
      perPage: json['per_page'],
      hasNextPage: json['has_next_page'],
      hasPrevPage: json['has_prev_page'],
    );
  }
}
