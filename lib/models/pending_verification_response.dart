class PendingVerificationResponse {
  final bool success;
  final String message;
  final PendingVerificationData data;

  PendingVerificationResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PendingVerificationResponse.fromJson(Map<String, dynamic> json) {
    return PendingVerificationResponse(
      success: json['success'],
      message: json['message'],
      data: PendingVerificationData.fromJson(json['data']),
    );
  }
}

class PendingVerificationData {
  final List<PendingPhoto> photos;
  final VerificationPagination pagination;

  PendingVerificationData({
    required this.photos,
    required this.pagination,
  });

  factory PendingVerificationData.fromJson(Map<String, dynamic> json) {
    return PendingVerificationData(
      photos: (json['photos'] as List)
          .map((e) => PendingPhoto.fromJson(e))
          .toList(),
      pagination: VerificationPagination.fromJson(json['pagination']),
    );
  }
}

class PendingPhoto {
  final int id;
  final int assignmentId;
  final String photoUrl;
  final String latitude;
  final String longitude;
  final String uploadDate;
  final int uploadedBy;
  final int weekNumber;
  final String growthStage;
  final String healthStatus;
  final String notes;
  final bool isVerified;
  final String createdAt;
  final String updatedAt;
  final PhotoAssignment assignment;
  final UploadedBy uploadedByUser;
  final String fullUrl;

  PendingPhoto({
    required this.id,
    required this.assignmentId,
    required this.photoUrl,
    required this.latitude,
    required this.longitude,
    required this.uploadDate,
    required this.uploadedBy,
    required this.weekNumber,
    required this.growthStage,
    required this.healthStatus,
    required this.notes,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
    required this.assignment,
    required this.uploadedByUser,
    required this.fullUrl,
  });

  factory PendingPhoto.fromJson(Map<String, dynamic> json) {
    return PendingPhoto(
      id: json['id'],
      assignmentId: json['assignment_id'],
      photoUrl: json['photo_url'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      uploadDate: json['upload_date'],
      uploadedBy: json['uploaded_by'],
      weekNumber: json['week_number'],
      growthStage: json['growth_stage'],
      healthStatus: json['health_status'],
      notes: json['notes'],
      isVerified: json['is_verified'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      assignment: PhotoAssignment.fromJson(json['assignment']),
      uploadedByUser: UploadedBy.fromJson(json['uploadedBy']),
      fullUrl: json['full_url'],
    );
  }
}

class PhotoAssignment {
  final int id;
  final int childId;
  final int plantId;
  final String assignedDate;
  final String status;
  final int assignedBy;
  final String? completionDate;
  final String? notes;
  final String createdAt;
  final String updatedAt;
  final AssignmentChild child;
  final AssignmentPlant plant;

  PhotoAssignment({
    required this.id,
    required this.childId,
    required this.plantId,
    required this.assignedDate,
    required this.status,
    required this.assignedBy,
    this.completionDate,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.child,
    required this.plant,
  });

  factory PhotoAssignment.fromJson(Map<String, dynamic> json) {
    return PhotoAssignment(
      id: json['id'],
      childId: json['child_id'],
      plantId: json['plant_id'],
      assignedDate: json['assigned_date'],
      status: json['status'],
      assignedBy: json['assigned_by'],
      completionDate: json['completion_date'],
      notes: json['notes'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      child: AssignmentChild.fromJson(json['child']),
      plant: AssignmentPlant.fromJson(json['plant']),
    );
  }
}

class AssignmentChild {
  final int id;
  final String childName;
  final String motherName;
  final String motherMobile;
  final String dob;

  AssignmentChild({
    required this.id,
    required this.childName,
    required this.motherName,
    required this.motherMobile,
    required this.dob,
  });

  factory AssignmentChild.fromJson(Map<String, dynamic> json) {
    return AssignmentChild(
      id: json['id'],
      childName: json['child_name'],
      motherName: json['mother_name'],
      motherMobile: json['mother_mobile'],
      dob: json['dob'],
    );
  }
}

class AssignmentPlant {
  final int id;
  final String name;

  AssignmentPlant({
    required this.id,
    required this.name,
  });

  factory AssignmentPlant.fromJson(Map<String, dynamic> json) {
    return AssignmentPlant(
      id: json['id'],
      name: json['name'],
    );
  }
}

class UploadedBy {
  final int id;
  final String name;
  final String userid;

  UploadedBy({
    required this.id,
    required this.name,
    required this.userid,
  });

  factory UploadedBy.fromJson(Map<String, dynamic> json) {
    return UploadedBy(
      id: json['id'],
      name: json['name'],
      userid: json['userid'],
    );
  }
}

class VerificationPagination {
  final int currentPage;
  final int totalPages;
  final int totalRecords;
  final int perPage;
  final bool hasNextPage;
  final bool hasPrevPage;

  VerificationPagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalRecords,
    required this.perPage,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory VerificationPagination.fromJson(Map<String, dynamic> json) {
    return VerificationPagination(
      currentPage: json['current_page'],
      totalPages: json['total_pages'],
      totalRecords: json['total_records'],
      perPage: json['per_page'],
      hasNextPage: json['has_next_page'],
      hasPrevPage: json['has_prev_page'],
    );
  }
}
