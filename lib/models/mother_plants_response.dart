class MotherPlantsResponse {
  final bool success;
  final String message;
  final MotherPlantsData data;

  MotherPlantsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory MotherPlantsResponse.fromJson(Map<String, dynamic> json) {
    return MotherPlantsResponse(
      success: json['success'],
      message: json['message'],
      data: MotherPlantsData.fromJson(json['data']),
    );
  }
}

class MotherPlantsData {
  final String motherName;
  final PlantSummary plantSummary;
  final OverallSummary overallSummary;

  MotherPlantsData({
    required this.motherName,
    required this.plantSummary,
    required this.overallSummary,
  });

  factory MotherPlantsData.fromJson(Map<String, dynamic> json) {
    return MotherPlantsData(
      motherName: json['mother_name'],
      plantSummary: PlantSummary.fromJson(json['plant_summary']),
      overallSummary: OverallSummary.fromJson(json['overall_summary']),
    );
  }
}

class PlantSummary {
  final int totalPlantsAssigned;
  final List<MotherPlantCard> plants;

  PlantSummary({
    required this.totalPlantsAssigned,
    required this.plants,
  });

  factory PlantSummary.fromJson(Map<String, dynamic> json) {
    return PlantSummary(
      totalPlantsAssigned: json['total_plants_assigned'],
      plants: (json['plants'] as List)
          .map((e) => MotherPlantCard.fromJson(e))
          .toList(),
    );
  }
}

class OverallSummary {
  final int totalPhotosRequired;
  final int totalPhotosUploaded;
  final int totalPhotosPending;
  final int totalPhotosOverdue;
  final int overallCompletionPercentage;

  OverallSummary({
    required this.totalPhotosRequired,
    required this.totalPhotosUploaded,
    required this.totalPhotosPending,
    required this.totalPhotosOverdue,
    required this.overallCompletionPercentage,
  });

  factory OverallSummary.fromJson(Map<String, dynamic> json) {
    return OverallSummary(
      totalPhotosRequired: json['total_photos_required'],
      totalPhotosUploaded: json['total_photos_uploaded'],
      totalPhotosPending: json['total_photos_pending'],
      totalPhotosOverdue: json['total_photos_overdue'],
      overallCompletionPercentage: json['overall_completion_percentage'],
    );
  }
}

class MotherPlantCard {
  final int assignmentId;
  final PlantInfo plant;
  final String assignedDate;
  final OverallProgress overallProgress;
  final DetailedProgress detailedProgress;
  final NextUpload? nextUpload;
  final ScheduleInfo scheduleInfo;
  final String status;

  MotherPlantCard({
    required this.assignmentId,
    required this.plant,
    required this.assignedDate,
    required this.overallProgress,
    required this.detailedProgress,
    this.nextUpload,
    required this.scheduleInfo,
    required this.status,
  });

  factory MotherPlantCard.fromJson(Map<String, dynamic> json) {
    return MotherPlantCard(
      assignmentId: json['assignment_id'],
      plant: PlantInfo.fromJson(json['plant']),
      assignedDate: json['assigned_date'],
      overallProgress: OverallProgress.fromJson(json['overall_progress']),
      detailedProgress: DetailedProgress.fromJson(json['detailed_progress']),
      nextUpload: json['next_upload'] != null ? NextUpload.fromJson(json['next_upload']) : null,
      scheduleInfo: ScheduleInfo.fromJson(json['schedule_info']),
      status: json['status'],
    );
  }
}

class PlantInfo {
  final int id;
  final String name;
  final String species;
  final String localName;

  PlantInfo({
    required this.id,
    required this.name,
    required this.species,
    required this.localName,
  });

  factory PlantInfo.fromJson(Map<String, dynamic> json) {
    return PlantInfo(
      id: json['id'],
      name: json['name'],
      species: json['species'],
      localName: json['local_name'],
    );
  }
}

class OverallProgress {
  final int totalPhotosRequired;
  final int photosUploaded;
  final int photosPending;
  final int photosOverdue;
  final int completionPercentage;

  OverallProgress({
    required this.totalPhotosRequired,
    required this.photosUploaded,
    required this.photosPending,
    required this.photosOverdue,
    required this.completionPercentage,
  });

  factory OverallProgress.fromJson(Map<String, dynamic> json) {
    return OverallProgress(
      totalPhotosRequired: json['total_photos_required'],
      photosUploaded: json['photos_uploaded'],
      photosPending: json['photos_pending'],
      photosOverdue: json['photos_overdue'],
      completionPercentage: json['completion_percentage'],
    );
  }
}

class DetailedProgress {
  final MonthProgress month1Progress;
  final MonthProgress month2Progress;
  final MonthProgress month3Progress;

  DetailedProgress({
    required this.month1Progress,
    required this.month2Progress,
    required this.month3Progress,
  });

  factory DetailedProgress.fromJson(Map<String, dynamic> json) {
    return DetailedProgress(
      month1Progress: MonthProgress.fromJson(json['month1_progress']),
      month2Progress: MonthProgress.fromJson(json['month2_progress']),
      month3Progress: MonthProgress.fromJson(json['month3_progress']),
    );
  }
}

class MonthProgress {
  final int totalRequired;
  final int uploaded;
  final int pending;
  final int overdue;

  MonthProgress({
    required this.totalRequired,
    required this.uploaded,
    required this.pending,
    required this.overdue,
  });

  factory MonthProgress.fromJson(Map<String, dynamic> json) {
    return MonthProgress(
      totalRequired: json['total_required'],
      uploaded: json['uploaded'],
      pending: json['pending'],
      overdue: json['overdue'],
    );
  }
}

class NextUpload {
  final String dueDate;
  final int weekNumber;
  final int monthNumber;
  final int daysRemaining;
  final bool isOverdue;

  NextUpload({
    required this.dueDate,
    required this.weekNumber,
    required this.monthNumber,
    required this.daysRemaining,
    required this.isOverdue,
  });

  factory NextUpload.fromJson(Map<String, dynamic> json) {
    return NextUpload(
      dueDate: json['due_date'],
      weekNumber: json['week_number'],
      monthNumber: json['month_number'],
      daysRemaining: json['days_remaining'],
      isOverdue: json['is_overdue'],
    );
  }
}

class ScheduleInfo {
  final String month1;
  final String month2;
  final String month3;
  final String totalDuration;

  ScheduleInfo({
    required this.month1,
    required this.month2,
    required this.month3,
    required this.totalDuration,
  });

  factory ScheduleInfo.fromJson(Map<String, dynamic> json) {
    return ScheduleInfo(
      month1: json['month1'],
      month2: json['month2'],
      month3: json['month3'],
      totalDuration: json['total_duration'],
    );
  }
}
