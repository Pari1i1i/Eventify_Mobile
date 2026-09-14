class UserModel {
  final int id;
  final String name;
  final String email;
  final String role; // 'customer', 'organizer', 'admin'
  final String? phone;
  final String? avatarUrl;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.avatarUrl,
    this.createdAt,
  });

  bool get isCustomer => role.toLowerCase() == 'customer';
  bool get isOrganizer => role.toLowerCase() == 'organizer' || role.toLowerCase() == 'panitia';
  bool get isAdmin => role.toLowerCase() == 'admin';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final roleRaw = json['role_name']?.toString() ?? json['role']?.toString() ?? 'customer';

    return UserModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? json['customer_name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: roleRaw.toLowerCase(),
      phone: json['phone']?.toString(),
      avatarUrl: json['avatar_url']?.toString() ?? json['avatar']?.toString(),
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'role_name': role,
      'phone': phone,
      'avatar_url': avatarUrl,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? role,
    String? phone,
    String? avatarUrl,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class AuthResponse {
  final String token;
  final UserModel user;

  AuthResponse({
    required this.token,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic> ? json['data'] : json;
    final token = data['token']?.toString() ?? json['token']?.toString() ?? '';
    final userMap = (data['user'] is Map<String, dynamic>)
        ? data['user'] as Map<String, dynamic>
        : (data['profile'] is Map<String, dynamic>)
            ? data['profile'] as Map<String, dynamic>
            : data;

    return AuthResponse(
      token: token,
      user: UserModel.fromJson(userMap),
    );
  }
}
