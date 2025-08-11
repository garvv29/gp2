class MitaninDashboardResponse {
  final bool success;
  final String message;
  final MitaninDashboardData data;

  MitaninDashboardResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory MitaninDashboardResponse.fromJson(Map<String, dynamic> json) {
    return MitaninDashboardResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: MitaninDashboardData.fromJson(json['data'] ?? {}),
    );
  }
}

class MitaninDashboardData {
  final MitaninCounters counters;
  final int hospitalId;
  final MitaninInfo mitaninInfo;

  MitaninDashboardData({
    required this.counters,
    required this.hospitalId,
    required this.mitaninInfo,
  });

  factory MitaninDashboardData.fromJson(Map<String, dynamic> json) {
    return MitaninDashboardData(
      counters: MitaninCounters.fromJson(json['counters'] ?? {}),
      hospitalId: json['hospital_id'] ?? 0,
      mitaninInfo: MitaninInfo.fromJson(json['mitanin_info'] ?? {}),
    );
  }
}

class MitaninCounters {
  final int totalUploadedPhotos;
  final int totalMothers;
  // Keep old fields for backward compatibility
  final int totalPendingVerification;
  final int totalVerificationPhotos;

  MitaninCounters({
    required this.totalUploadedPhotos,
    required this.totalMothers,
    this.totalPendingVerification = 0,
    this.totalVerificationPhotos = 0,
  });

  factory MitaninCounters.fromJson(Map<String, dynamic> json) {
    return MitaninCounters(
      totalUploadedPhotos: json['total_uploaded_photos'] ?? json['total_verification_photos'] ?? 0,
      totalMothers: json['total_mothers'] ?? 0,
      totalPendingVerification: json['total_pending_verification'] ?? 0,
      totalVerificationPhotos: json['total_verification_photos'] ?? 0,
    );
  }
}

class MitaninInfo {
  final int id;
  final String name;
  final String userid;

  MitaninInfo({
    required this.id,
    required this.name,
    required this.userid,
  });

  factory MitaninInfo.fromJson(Map<String, dynamic> json) {
    return MitaninInfo(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      userid: json['userid'] ?? '',
    );
  }
}
