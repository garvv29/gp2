class UploadedPhotosResponse {
  final bool success;
  final String message;
  final UploadedPhotosData data;

  UploadedPhotosResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UploadedPhotosResponse.fromJson(Map<String, dynamic> json) {
    return UploadedPhotosResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: UploadedPhotosData.fromJson(json['data'] ?? {}),
    );
  }
}

class UploadedPhotosData {
  final List<UploadedPhoto> photos;
  final PhotoPagination pagination;

  UploadedPhotosData({
    required this.photos,
    required this.pagination,
  });

  factory UploadedPhotosData.fromJson(Map<String, dynamic> json) {
    return UploadedPhotosData(
      photos: (json['photos'] as List<dynamic>?)
          ?.map((photo) => UploadedPhoto.fromJson(photo))
          .toList() ?? [],
      pagination: PhotoPagination.fromJson(json['pagination'] ?? {}),
    );
  }
}

class UploadedPhoto {
  final int id;
  final String photoUrl;
  final String fullUrl;
  final DateTime uploadDate;
  final String? notes;
  final PhotoAssignment assignment;
  final UploadedByUser uploadedBy;

  UploadedPhoto({
    required this.id,
    required this.photoUrl,
    required this.fullUrl,
    required this.uploadDate,
    this.notes,
    required this.assignment,
    required this.uploadedBy,
  });

  factory UploadedPhoto.fromJson(Map<String, dynamic> json) {
    return UploadedPhoto(
      id: json['id'] ?? 0,
      photoUrl: json['photo_url'] ?? '',
      fullUrl: json['full_url'] ?? '',
      uploadDate: json['upload_date'] != null 
          ? DateTime.parse(json['upload_date'])
          : DateTime.now(),
      notes: json['notes'],
      assignment: PhotoAssignment.fromJson(json['assignment'] ?? {}),
      uploadedBy: UploadedByUser.fromJson(json['uploadedBy'] ?? {}),
    );
  }
}

class PhotoAssignment {
  final int id;
  final PhotoChild child;
  final PhotoPlant plant;

  PhotoAssignment({
    required this.id,
    required this.child,
    required this.plant,
  });

  factory PhotoAssignment.fromJson(Map<String, dynamic> json) {
    return PhotoAssignment(
      id: json['id'] ?? 0,
      child: PhotoChild.fromJson(json['child'] ?? {}),
      plant: PhotoPlant.fromJson(json['plant'] ?? {}),
    );
  }
}

class PhotoChild {
  final int id;
  final String childName;
  final String motherName;
  final String motherMobile;
  final DateTime? dob;

  PhotoChild({
    required this.id,
    required this.childName,
    required this.motherName,
    required this.motherMobile,
    this.dob,
  });

  factory PhotoChild.fromJson(Map<String, dynamic> json) {
    return PhotoChild(
      id: json['id'] ?? 0,
      childName: json['child_name'] ?? '',
      motherName: json['mother_name'] ?? '',
      motherMobile: json['mother_mobile'] ?? '',
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
    );
  }
}

class PhotoPlant {
  final int id;
  final String name;

  PhotoPlant({
    required this.id,
    required this.name,
  });

  factory PhotoPlant.fromJson(Map<String, dynamic> json) {
    return PhotoPlant(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class UploadedByUser {
  final int id;
  final String name;
  final String userid;

  UploadedByUser({
    required this.id,
    required this.name,
    required this.userid,
  });

  factory UploadedByUser.fromJson(Map<String, dynamic> json) {
    return UploadedByUser(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      userid: json['userid'] ?? '',
    );
  }
}

class PhotoPagination {
  final int currentPage;
  final int totalPages;
  final int totalRecords;
  final int perPage;
  final bool hasNextPage;
  final bool hasPrevPage;

  PhotoPagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalRecords,
    required this.perPage,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory PhotoPagination.fromJson(Map<String, dynamic> json) {
    return PhotoPagination(
      currentPage: json['current_page'] ?? 1,
      totalPages: json['total_pages'] ?? 1,
      totalRecords: json['total_records'] ?? 0,
      perPage: json['per_page'] ?? 10,
      hasNextPage: json['has_next_page'] ?? false,
      hasPrevPage: json['has_prev_page'] ?? false,
    );
  }
}
