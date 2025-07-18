class User {
  final String id;
  final String phone;
  final String role;
  final String name;
  final DateTime createdAt;

  User({
    required this.id,
    required this.phone,
    required this.role,
    required this.name,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // If the json is an ApiUser (from login), map it to User
    if (json.containsKey('userid') && json.containsKey('mobile')) {
      return User(
        id: json['userid'].toString(),
        phone: json['mobile'].toString(),
        role: json['role'] is String ? json['role'] : (json['role']?['name'] ?? ''),
        name: json['name'],
        createdAt: DateTime.now(), // fallback, as login doesn't provide created_at
      );
    }
    // Standard User json
    return User(
      id: json['id'].toString(),
      phone: json['phone'].toString(),
      role: json['role'] is String ? json['role'] : (json['role']?['name'] ?? ''),
      name: json['name'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'role': role,
      'name': name,
      'created_at': createdAt.toIso8601String(),
    };
  }
}