class LoginResponse {
  final String token;
  final String refreshToken;
  final ApiUser user;

  LoginResponse({
    required this.token,
    required this.refreshToken,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return LoginResponse(
      token: data['token'] ?? '',
      refreshToken: data['refreshToken'] ?? '',
      user: ApiUser.fromJson(data['user'] ?? {}),
    );
  }
}

class ApiUser {
  final int id;
  final String userid;
  final String name;
  final String mobile;
  final String? email;
  final Role role;
  final int? districtId;
  final int? blockId;
  final int? villageId;
  final String? hospitalName;
  final String? lastLogin;
  final bool? isFirstLogin;

  ApiUser({
    required this.id,
    required this.userid,
    required this.name,
    required this.mobile,
    required this.role,
    this.email,
    this.districtId,
    this.blockId,
    this.villageId,
    this.hospitalName,
    this.lastLogin,
    this.isFirstLogin,
  });

  factory ApiUser.fromJson(Map<String, dynamic> json) {
    return ApiUser(
      id: json['id'],
      userid: json['userid'],
      name: json['name'],
      mobile: json['mobile'],
      email: json['email'],
      role: Role.fromJson(json['role']),
      districtId: json['district_id'],
      blockId: json['block_id'],
      villageId: json['village_id'],
      hospitalName: json['hospital_name'],
      lastLogin: json['last_login'],
      isFirstLogin: json['isFirstLogin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userid': userid,
      'name': name,
      'mobile': mobile,
      'email': email,
      'role': role.toJson(),
      'district_id': districtId,
      'block_id': blockId,
      'village_id': villageId,
      'hospital_name': hospitalName,
      'last_login': lastLogin,
      'isFirstLogin': isFirstLogin,
    };
  }
}

class Role {
  final String name;
  final List<String> permissions;

  Role({
    required this.name,
    required this.permissions,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    List<String> perms = [];
    if (json['permissions'] is String) {
      // Permissions is a JSON string, so decode it
      try {
        perms = List<String>.from((json['permissions'] as String)
            .replaceAll('[', '')
            .replaceAll(']', '')
            .replaceAll('"', '')
            .split(',')
            .map((e) => e.trim()));
      } catch (_) {}
    } else if (json['permissions'] is List) {
      perms = List<String>.from(json['permissions'] ?? []);
    }
    return Role(
      name: json['name'],
      permissions: perms,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'permissions': permissions,
    };
  }
}