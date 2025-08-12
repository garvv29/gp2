class MotherPhotosData {
  final int totalPhotos;
  final List<MotherPhotoItem> photos;

  MotherPhotosData({
    required this.totalPhotos,
    required this.photos,
  });

  factory MotherPhotosData.fromJson(Map<String, dynamic> json) {
    return MotherPhotosData(
      totalPhotos: json['total_photos'] ?? 0,
      photos: (json['photos'] as List<dynamic>? ?? [])
          .map((e) => MotherPhotoItem.fromJson(e)).toList(),
    );
  }
}

class MotherPhotoItem {
  final int id;
  final String photoType;
  final String photoUrl;
  final String? originalFilename;
  final int? fileSize;
  final String uploadDate;
  final bool isVerified;
  final String? verifiedAt;
  final String? remarks;
  final String? childName;
  final String? childDob;

  MotherPhotoItem({
    required this.id,
    required this.photoType,
    required this.photoUrl,
    this.originalFilename,
    this.fileSize,
    required this.uploadDate,
    required this.isVerified,
    this.verifiedAt,
    this.remarks,
    this.childName,
    this.childDob,
  });

  factory MotherPhotoItem.fromJson(Map<String, dynamic> json) {
    return MotherPhotoItem(
      id: json['id'],
      photoType: json['photo_type'] ?? '',
      photoUrl: json['photo_url'] ?? '',
      originalFilename: json['original_filename'],
      fileSize: json['file_size'],
      uploadDate: json['upload_date'] ?? '',
      isVerified: json['is_verified'] ?? false,
      verifiedAt: json['verified_at'],
      remarks: json['remarks'],
      childName: json['child_name'],
      childDob: json['child_dob'],
    );
  }

  String get displayName {
    switch (photoType) {
      case 'certificate':
        return 'प्रमाण पत्र फोटो (जन्म प्रमाण/डिस्चार्ज)';
      case 'plant_distribution':
        return 'पौधा वितरण फोटो (माँ+बच्चा+पौधा)';
      case 'mother_with_child':
        return 'माँ और बच्चे की फोटो';
      case 'prescription':
        return 'प्रिस्क्रिप्शन/डिस्चार्ज';
      default:
        return photoType;
    }
  }

  String get formattedFileSize {
    if (fileSize == null) return 'Unknown';
    
    if (fileSize! < 1024) {
      return '${fileSize} bytes';
    } else if (fileSize! < 1024 * 1024) {
      return '${(fileSize! / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(fileSize! / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }
}
