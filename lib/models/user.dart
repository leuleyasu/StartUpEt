class User {
  final String id;
  final String? name;
  final String? email;
  final String? role;
  final String? phone;

  const User({required this.id, this.name, this.email, this.role, this.phone});

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as String,
    name: json['name'] as String?,
    email: json['email'] as String?,
    role: json['role'] as String?,
    phone: json['phone'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    if (name != null) 'name': name,
    if (email != null) 'email': email,
    if (role != null) 'role': role,
    if (phone != null) 'phone': phone,
  };
}
