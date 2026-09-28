class UserProfileModel {
  final String id;
  final String email;
  final String name;
  final String phone;
  final String? avatarUrl;
  final String bio;
  final String address;
  final String city;
  final String role;
  final DateTime? createdAt;
  final int listingsCount;
  final int favoritesCount;

  UserProfileModel({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    this.avatarUrl,
    required this.bio,
    required this.address,
    required this.city,
    required this.role,
    this.createdAt,
    this.listingsCount = 0,
    this.favoritesCount = 0,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    final stats = json['stats'] as Map<String, dynamic>? ?? {};

    return UserProfileModel(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      avatarUrl: json['avatarUrl'] ?? json['avatar_url'],
      bio: json['bio'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? 'Khulna',
      role: json['role'] ?? 'user',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : (json['created_at'] != null
              ? DateTime.tryParse(json['created_at'].toString())
              : null),
      listingsCount: (stats['listingsCount'] as num?)?.toInt() ?? 0,
      favoritesCount: (stats['favoritesCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'avatarUrl': avatarUrl,
      'bio': bio,
      'address': address,
      'city': city,
      'role': role,
      'stats': {
        'listingsCount': listingsCount,
        'favoritesCount': favoritesCount,
      },
    };
  }
}
