class Plant {
  final String id;
  final String motherId;
  final int plantNumber;
  final DateTime assignedDate;
  final String? lastUploadDate;
  final String status;

  Plant({
    required this.id,
    required this.motherId,
    required this.plantNumber,
    required this.assignedDate,
    this.lastUploadDate,
    this.status = 'active',
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'],
      motherId: json['mother_id'],
      plantNumber: json['plant_number'],
      assignedDate: DateTime.parse(json['assigned_date']),
      lastUploadDate: json['last_upload_date'],
      status: json['status'] ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mother_id': motherId,
      'plant_number': plantNumber,
      'assigned_date': assignedDate.toIso8601String(),
      'last_upload_date': lastUploadDate,
      'status': status,
    };
  }
}