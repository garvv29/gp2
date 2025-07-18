class PlantMonitoring {
  final String id;
  final String plantId;
  final String motherId;
  final String plantName;
  final DateTime assignedDate;
  final List<MonitoringPeriod> monitoringPeriods;
  final String status; // 'active', 'completed', 'pending'

  PlantMonitoring({
    required this.id,
    required this.plantId,
    required this.motherId,
    required this.plantName,
    required this.assignedDate,
    required this.monitoringPeriods,
    required this.status,
  });

  factory PlantMonitoring.fromJson(Map<String, dynamic> json) {
    return PlantMonitoring(
      id: json['id'],
      plantId: json['plantId'],
      motherId: json['motherId'],
      plantName: json['plantName'],
      assignedDate: DateTime.parse(json['assignedDate']),
      monitoringPeriods: (json['monitoringPeriods'] as List)
          .map((period) => MonitoringPeriod.fromJson(period))
          .toList(),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plantId': plantId,
      'motherId': motherId,
      'plantName': plantName,
      'assignedDate': assignedDate.toIso8601String(),
      'monitoringPeriods': monitoringPeriods.map((period) => period.toJson()).toList(),
      'status': status,
    };
  }

  PlantMonitoring copyWith({
    String? id,
    String? plantId,
    String? motherId,
    String? plantName,
    DateTime? assignedDate,
    List<MonitoringPeriod>? monitoringPeriods,
    String? status,
  }) {
    return PlantMonitoring(
      id: id ?? this.id,
      plantId: plantId ?? this.plantId,
      motherId: motherId ?? this.motherId,
      plantName: plantName ?? this.plantName,
      assignedDate: assignedDate ?? this.assignedDate,
      monitoringPeriods: monitoringPeriods ?? this.monitoringPeriods,
      status: status ?? this.status,
    );
  }
}

class MonitoringPeriod {
  final String id;
  final int monthNumber; // 1, 2, or 3
  final String periodName; // "पहला महीना", "दूसरा महीना", "तीसरा महीना"
  final List<MonitoringUpload> uploads;
  final String status; // 'pending', 'in_progress', 'completed'

  MonitoringPeriod({
    required this.id,
    required this.monthNumber,
    required this.periodName,
    required this.uploads,
    required this.status,
  });

  factory MonitoringPeriod.fromJson(Map<String, dynamic> json) {
    return MonitoringPeriod(
      id: json['id'],
      monthNumber: json['monthNumber'],
      periodName: json['periodName'],
      uploads: (json['uploads'] as List)
          .map((upload) => MonitoringUpload.fromJson(upload))
          .toList(),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'monthNumber': monthNumber,
      'periodName': periodName,
      'uploads': uploads.map((upload) => upload.toJson()).toList(),
      'status': status,
    };
  }
}

class MonitoringUpload {
  final String id;
  final String uploadTitle; // "पहला सप्ताह", "दूसरा सप्ताह", etc.
  final DateTime dueDate;
  final DateTime? uploadDate;
  final String? photoPath;
  final String? description;
  final String status; // 'pending', 'uploaded', 'overdue'

  MonitoringUpload({
    required this.id,
    required this.uploadTitle,
    required this.dueDate,
    this.uploadDate,
    this.photoPath,
    this.description,
    required this.status,
  });

  factory MonitoringUpload.fromJson(Map<String, dynamic> json) {
    return MonitoringUpload(
      id: json['id'],
      uploadTitle: json['uploadTitle'],
      dueDate: DateTime.parse(json['dueDate']),
      uploadDate: json['uploadDate'] != null ? DateTime.parse(json['uploadDate']) : null,
      photoPath: json['photoPath'],
      description: json['description'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uploadTitle': uploadTitle,
      'dueDate': dueDate.toIso8601String(),
      'uploadDate': uploadDate?.toIso8601String(),
      'photoPath': photoPath,
      'description': description,
      'status': status,
    };
  }

  MonitoringUpload copyWith({
    String? id,
    String? uploadTitle,
    DateTime? dueDate,
    DateTime? uploadDate,
    String? photoPath,
    String? description,
    String? status,
  }) {
    return MonitoringUpload(
      id: id ?? this.id,
      uploadTitle: uploadTitle ?? this.uploadTitle,
      dueDate: dueDate ?? this.dueDate,
      uploadDate: uploadDate ?? this.uploadDate,
      photoPath: photoPath ?? this.photoPath,
      description: description ?? this.description,
      status: status ?? this.status,
    );
  }
} 