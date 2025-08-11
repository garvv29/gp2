class MotherPlantDetailResponse {
  final bool success;
  final String message;
  final MotherPlantDetailData data;

  MotherPlantDetailResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory MotherPlantDetailResponse.fromJson(Map<String, dynamic> json) {
    return MotherPlantDetailResponse(
      success: json['success'],
      message: json['message'],
      data: MotherPlantDetailData.fromJson(json['data']),
    );
  }
}

class MotherPlantDetailData {
  final Assignment assignment;
  final PlantStats stats;
  final List<TrackingHistory> trackingHistory;
  final TrackingHistoryMonthwise trackingHistoryMonthwise;

  MotherPlantDetailData({
    required this.assignment,
    required this.stats,
    required this.trackingHistory,
    required this.trackingHistoryMonthwise,
  });

  factory MotherPlantDetailData.fromJson(Map<String, dynamic> json) {
    return MotherPlantDetailData(
      assignment: Assignment.fromJson(json['assignment']),
      stats: PlantStats.fromJson(json['stats']),
      trackingHistory: (json['tracking_history'] as List)
          .map((e) => TrackingHistory.fromJson(e))
          .toList(),
      trackingHistoryMonthwise: TrackingHistoryMonthwise.fromJson(json['tracking_history_monthwise']),
    );
  }
}

class Assignment {
  final int id;
  final String assignedDate;
  final String status;
  final Plant plant;
  final Child child;

  Assignment({
    required this.id,
    required this.assignedDate,
    required this.status,
    required this.plant,
    required this.child,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'] ?? 0,
      assignedDate: json['assigned_date'] ?? '',
      status: json['status'] ?? '',
      plant: Plant.fromJson(json['plant'] ?? {}),
      child: Child.fromJson(json['child'] ?? {}),
    );
  }
}

class Plant {
  final int id;
  final String name;
  final String species;
  final String localName;
  final String description;
  final String careInstructions;

  Plant({
    required this.id,
    required this.name,
    required this.species,
    required this.localName,
    required this.description,
    required this.careInstructions,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      species: json['species'] ?? '',
      localName: json['local_name'] ?? '',
      description: json['description'] ?? '',
      careInstructions: json['care_instructions'] ?? '',
    );
  }
}

class Child {
  final int id;
  final String childName;
  final String motherName;
  final String motherMobile;

  Child({
    required this.id,
    required this.childName,
    required this.motherName,
    required this.motherMobile,
  });

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      id: json['id'] ?? 0,
      childName: json['child_name'] ?? '',
      motherName: json['mother_name'] ?? '',
      motherMobile: json['mother_mobile'] ?? '',
    );
  }
}

class PlantStats {
  final int totalSchedules;
  final int completed;
  final int pending;
  final int overdue;
  final int completionPercentage;
  final String? nextDueDate;
  final int? daysRemaining;

  PlantStats({
    required this.totalSchedules,
    required this.completed,
    required this.pending,
    required this.overdue,
    required this.completionPercentage,
    this.nextDueDate,
    this.daysRemaining,
  });

  factory PlantStats.fromJson(Map<String, dynamic> json) {
    return PlantStats(
      totalSchedules: json['total_schedules'] ?? 0,
      completed: json['completed'] ?? 0,
      pending: json['pending'] ?? 0,
      overdue: json['overdue'] ?? 0,
      completionPercentage: json['completion_percentage'] ?? 0,
      nextDueDate: json['next_due_date'],
      daysRemaining: json['days_remaining'],
    );
  }
}

class TrackingHistory {
  final int scheduleId;
  final int weekNumber;
  final int monthNumber;
  final String dueDate;
  final String uploadStatus;
  final String? completedDate;
  final String? remarks;
  final Photo? photo;

  TrackingHistory({
    required this.scheduleId,
    required this.weekNumber,
    required this.monthNumber,
    required this.dueDate,
    required this.uploadStatus,
    this.completedDate,
    this.remarks,
    this.photo,
  });

  factory TrackingHistory.fromJson(Map<String, dynamic> json) {
    return TrackingHistory(
      scheduleId: json['schedule_id'] ?? 0,
      weekNumber: json['week_number'] ?? 0,
      monthNumber: json['month_number'] ?? 0,
      dueDate: json['due_date'] ?? '',
      uploadStatus: json['upload_status'] ?? '',
      completedDate: json['completed_date'],
      remarks: json['remarks'],
      photo: json['photo'] != null ? Photo.fromJson(json['photo']) : null,
    );
  }
}

class Photo {
  final int id;
  final String photoUrl;
  final String latitude;
  final String longitude;
  final String uploadDate;
  final String remarks;

  Photo({
    required this.id,
    required this.photoUrl,
    required this.latitude,
    required this.longitude,
    required this.uploadDate,
    required this.remarks,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'] ?? 0,
      photoUrl: json['photo_url'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      uploadDate: json['upload_date'] ?? '',
      remarks: json['remarks'] ?? '',
    );
  }
}

class TrackingHistoryMonthwise {
  final MonthwiseDetail month1;
  final MonthwiseDetail month2;
  final MonthwiseDetail month3;

  TrackingHistoryMonthwise({
    required this.month1,
    required this.month2,
    required this.month3,
  });

  factory TrackingHistoryMonthwise.fromJson(Map<String, dynamic> json) {
    return TrackingHistoryMonthwise(
      month1: MonthwiseDetail.fromJson(json['month1'] ?? {}),
      month2: MonthwiseDetail.fromJson(json['month2'] ?? {}),
      month3: MonthwiseDetail.fromJson(json['month3'] ?? {}),
    );
  }
}

class MonthwiseDetail {
  final String title;
  final String description;
  final List<WeekDetail> weeks;

  MonthwiseDetail({
    required this.title,
    required this.description,
    required this.weeks,
  });

  factory MonthwiseDetail.fromJson(Map<String, dynamic> json) {
    return MonthwiseDetail(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      weeks: json['weeks'] != null 
          ? (json['weeks'] as List).map((e) => WeekDetail.fromJson(e)).toList()
          : [],
    );
  }
}

class WeekDetail {
  final int scheduleId;
  final int weekNumber;
  final String weekTitle;
  final String dueDate;
  final String assignedDate;
  final String uploadStatus;
  final String? completedDate;
  final String? uploadedDate;
  final String? remarks;
  final Photo? photo;

  WeekDetail({
    required this.scheduleId,
    required this.weekNumber,
    required this.weekTitle,
    required this.dueDate,
    required this.assignedDate,
    required this.uploadStatus,
    this.completedDate,
    this.uploadedDate,
    this.remarks,
    this.photo,
  });

  factory WeekDetail.fromJson(Map<String, dynamic> json) {
    return WeekDetail(
      scheduleId: json['schedule_id'] ?? 0,
      weekNumber: json['week_number'] ?? 0,
      weekTitle: json['week_title'] ?? '',
      dueDate: json['due_date'] ?? '',
      assignedDate: json['assigned_date'] ?? '',
      uploadStatus: json['upload_status'] ?? '',
      completedDate: json['completed_date'],
      uploadedDate: json['uploaded_date'],
      remarks: json['remarks'],
      photo: json['photo'] != null ? Photo.fromJson(json['photo']) : null,
    );
  }
}
