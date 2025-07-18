class Upload {
  final String id;
  final String plantId;
  final String imageUrl;
  final DateTime uploadDate;
  final String status;
  final String? awwReview;
  final String? motherName;

  Upload({
    required this.id,
    required this.plantId,
    required this.imageUrl,
    required this.uploadDate,
    required this.status,
    this.awwReview,
    this.motherName,
  });

  factory Upload.fromJson(Map<String, dynamic> json) {
    return Upload(
      id: json['id'],
      plantId: json['plant_id'],
      imageUrl: json['image_url'],
      uploadDate: DateTime.parse(json['upload_date']),
      status: json['status'],
      awwReview: json['aww_review'],
      motherName: json['mother_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plant_id': plantId,
      'image_url': imageUrl,
      'upload_date': uploadDate.toIso8601String(),
      'status': status,
      'aww_review': awwReview,
      'mother_name': motherName,
    };
  }
}
