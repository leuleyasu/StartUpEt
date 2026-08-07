class User {
  final String id;
  final String? name;
  final String? email;
  final String? role;
  final String? phone;
  final String? firstName;
  final String? lastName;
  final String? stakeholderId;
  final String? address;
  final String? image;
  final bool? twoStepAuthEnabled;
  final List<String> permissions;

  const User({
    required this.id,
    this.name,
    this.email,
    this.role,
    this.phone,
    this.firstName,
    this.lastName,
    this.stakeholderId,
    this.address,
    this.image,
    this.twoStepAuthEnabled,
    this.permissions = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data = json.containsKey('user') && json['user'] is Map<String, dynamic>
        ? json['user'] as Map<String, dynamic>
        : json;

    final String? firstName = data['firstName']?.toString();
    final String? lastName = data['lastName']?.toString();
    String? derivedName = data['name']?.toString();
    if ((derivedName == null || derivedName.isEmpty) && (firstName != null || lastName != null)) {
      derivedName = '${firstName ?? ''} ${lastName ?? ''}'.trim();
    }

    final permissionsRaw = data['permissions'];
    List<String> parsedPermissions = [];
    if (permissionsRaw is List) {
      parsedPermissions = permissionsRaw.map((e) => e.toString()).toList();
    }

    return User(
      id: (data['id'] ?? data['_id'] ?? 'user_${DateTime.now().millisecondsSinceEpoch}') as String,
      name: derivedName,
      email: data['email']?.toString(),
      role: data['role']?.toString(),
      phone: (data['phone'] ?? data['phoneNumber'])?.toString(),
      firstName: firstName,
      lastName: lastName,
      stakeholderId: data['stakeholderId']?.toString(),
      address: data['address']?.toString(),
      image: (data['image'] ?? data['avatarUrl'] ?? data['avatar'])?.toString(),
      twoStepAuthEnabled: data['twoStepAuthEnabled'] as bool?,
      permissions: parsedPermissions,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (role != null) 'role': role,
        if (phone != null) 'phone': phone,
        if (firstName != null) 'firstName': firstName,
        if (lastName != null) 'lastName': lastName,
        if (stakeholderId != null) 'stakeholderId': stakeholderId,
        if (address != null) 'address': address,
        if (image != null) 'image': image,
        if (twoStepAuthEnabled != null) 'twoStepAuthEnabled': twoStepAuthEnabled,
        if (permissions.isNotEmpty) 'permissions': permissions,
      };

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? phone,
    String? firstName,
    String? lastName,
    String? stakeholderId,
    String? address,
    String? image,
    bool? twoStepAuthEnabled,
    List<String>? permissions,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      stakeholderId: stakeholderId ?? this.stakeholderId,
      address: address ?? this.address,
      image: image ?? this.image,
      twoStepAuthEnabled: twoStepAuthEnabled ?? this.twoStepAuthEnabled,
      permissions: permissions ?? this.permissions,
    );
  }
}
