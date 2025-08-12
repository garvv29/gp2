class MotherSearchResponse {
  final bool success;
  final String message;
  final MotherSearchData? data;

  MotherSearchResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory MotherSearchResponse.fromJson(Map<String, dynamic> json) {
    return MotherSearchResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? MotherSearchData.fromJson(json['data']) : null,
    );
  }
}

class MotherSearchData {
  final int childId;
  final String motherName;
  final String childName;
  final String motherMobile;
  final String deliveryDate;
  final String childGender;
  final String registrationDate;
  final LocationInfo location;
  final List<PlantAssignmentDetail> plantAssignments;
  final TrackingSummary trackingSummary;

  MotherSearchData({
    required this.childId,
    required this.motherName,
    required this.childName,
    required this.motherMobile,
    required this.deliveryDate,
    required this.childGender,
    required this.registrationDate,
    required this.location,
    required this.plantAssignments,
    required this.trackingSummary,
  });

  factory MotherSearchData.fromJson(Map<String, dynamic> json) {
    return MotherSearchData(
      childId: json['child_id'] ?? 0,
      motherName: json['mother_name'] ?? '',
      childName: json['child_name'] ?? '',
      motherMobile: json['mother_mobile'] ?? '',
      deliveryDate: json['delivery_date'] ?? '',
      childGender: json['child_gender'] ?? '',
      registrationDate: json['registration_date'] ?? '',
      location: LocationInfo.fromJson(json['location'] ?? {}),
      plantAssignments: (json['plant_assignments'] as List<dynamic>?)
          ?.map((x) => PlantAssignmentDetail.fromJson(x))
          .toList() ?? [],
      trackingSummary: TrackingSummary.fromJson(json['tracking_summary'] ?? {}),
    );
  }
}

class LocationInfo {
  final String districtName;
  final String blockName;
  final String villageName;

  LocationInfo({
    required this.districtName,
    required this.blockName,
    required this.villageName,
  });

  factory LocationInfo.fromJson(Map<String, dynamic> json) {
    return LocationInfo(
      districtName: json['district_name'] ?? 'N/A',
      blockName: json['block_name'] ?? 'N/A',
      villageName: json['village_name'] ?? 'N/A',
    );
  }
}

class PlantAssignmentDetail {
  final int assignmentId;
  final PlantInfo plant;
  final String assignedDate;
  final String status;
  final List<TrackingScheduleDetail> trackingSchedules;

  PlantAssignmentDetail({
    required this.assignmentId,
    required this.plant,
    required this.assignedDate,
    required this.status,
    required this.trackingSchedules,
  });

  factory PlantAssignmentDetail.fromJson(Map<String, dynamic> json) {
    return PlantAssignmentDetail(
      assignmentId: json['assignment_id'] ?? 0,
      plant: PlantInfo.fromJson(json['plant'] ?? {}),
      assignedDate: json['assigned_date'] ?? '',
      status: json['status'] ?? '',
      trackingSchedules: (json['tracking_schedules'] as List<dynamic>?)
          ?.map((x) => TrackingScheduleDetail.fromJson(x))
          .toList() ?? [],
    );
  }
}

class PlantInfo {
  final int id;
  final String name;
  final String localName;
  final String category;

  PlantInfo({
    required this.id,
    required this.name,
    required this.localName,
    required this.category,
  });

  factory PlantInfo.fromJson(Map<String, dynamic> json) {
    return PlantInfo(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      localName: json['local_name'] ?? '',
      category: json['category'] ?? '',
    );
  }
}

class TrackingScheduleDetail {
  final int scheduleId;
  final int weekNumber;
  final int monthNumber;
  final String dueDate;
  final String uploadStatus;
  final String? completedDate;
  final String weekTitle;
  final bool isOverdue;

  TrackingScheduleDetail({
    required this.scheduleId,
    required this.weekNumber,
    required this.monthNumber,
    required this.dueDate,
    required this.uploadStatus,
    this.completedDate,
    required this.weekTitle,
    required this.isOverdue,
  });

  factory TrackingScheduleDetail.fromJson(Map<String, dynamic> json) {
    return TrackingScheduleDetail(
      scheduleId: json['schedule_id'] ?? 0,
      weekNumber: json['week_number'] ?? 0,
      monthNumber: json['month_number'] ?? 0,
      dueDate: json['due_date'] ?? '',
      uploadStatus: json['upload_status'] ?? '',
      completedDate: json['completed_date'],
      weekTitle: json['week_title'] ?? '',
      isOverdue: json['is_overdue'] ?? false,
    );
  }
}

class TrackingSummary {
  final int totalWeeks;
  final int completedWeeks;
  final int pendingWeeks;
  final int overdueWeeks;
  final int completionPercentage;

  TrackingSummary({
    required this.totalWeeks,
    required this.completedWeeks,
    required this.pendingWeeks,
    required this.overdueWeeks,
    required this.completionPercentage,
  });

  factory TrackingSummary.fromJson(Map<String, dynamic> json) {
    return TrackingSummary(
      totalWeeks: json['total_weeks'] ?? 0,
      completedWeeks: json['completed_weeks'] ?? 0,
      pendingWeeks: json['pending_weeks'] ?? 0,
      overdueWeeks: json['overdue_weeks'] ?? 0,
      completionPercentage: json['completion_percentage'] ?? 0,
    );
  }
}
