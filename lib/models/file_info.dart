enum FileCategory {
  businessLicense('BUSINESS_LICENSE'),
  articlesOfIncorporation('ARTICLES_OF_INCORPORATION'),
  pitchDeck('PITCH_DECK'),
  financialStatement('FINANCIAL_STATEMENT'),
  profileImage('PROFILE_IMAGE'),
  certificate('CERTIFICATE'),
  investorDocument('INVESTOR_DOCUMENT'),
  taxRegistration('TAX_REGISTRATION'),
  publicAsset('PUBLIC_ASSET'),
  other('OTHER');

  final String value;
  const FileCategory(this.value);

  static FileCategory fromString(String? val) {
    if (val == null) return FileCategory.other;
    return FileCategory.values.firstWhere(
      (e) => e.value.toUpperCase() == val.toUpperCase(),
      orElse: () => FileCategory.other,
    );
  }
}

class FileInfo {
  final String id;
  final String? name;
  final String? originalName;
  final String? storedName;
  final String? url;
  final int? size;
  final String? mimeType;
  final String? category;
  final bool? isPublic;
  final String? storagePath;
  final String? uploadedBy;
  final String? entityType;
  final String? entityId;
  final Map<String, dynamic>? metadata;
  final String? uploadedAt;
  final String? createdAt;
  final String? updatedAt;
  final String? status;

  const FileInfo({
    required this.id,
    this.name,
    this.originalName,
    this.storedName,
    this.url,
    this.size,
    this.mimeType,
    this.category,
    this.isPublic,
    this.storagePath,
    this.uploadedBy,
    this.entityType,
    this.entityId,
    this.metadata,
    this.uploadedAt,
    this.createdAt,
    this.updatedAt,
    this.status,
  });

  factory FileInfo.fromJson(Map<String, dynamic> json) {
    final origName = (json['originalName'] ?? json['name']) as String?;
    return FileInfo(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      name: origName,
      originalName: origName,
      storedName: json['storedName'] as String?,
      url: (json['url'] ?? json['downloadUrl']) as String?,
      size: (json['size'] as num?)?.toInt(),
      mimeType: (json['mimeType'] ?? json['contentType']) as String?,
      category: json['category']?.toString(),
      isPublic: json['isPublic'] as bool?,
      storagePath: json['storagePath'] as String?,
      uploadedBy: json['uploadedBy'] as String?,
      entityType: json['entityType'] as String?,
      entityId: json['entityId'] as String?,
      metadata: json['metadata'] is Map<String, dynamic>
          ? json['metadata'] as Map<String, dynamic>
          : null,
      uploadedAt: (json['uploadedAt'] ?? json['createdAt']) as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    if (name != null) 'name': name,
    if (originalName != null) 'originalName': originalName,
    if (storedName != null) 'storedName': storedName,
    if (url != null) 'url': url,
    if (size != null) 'size': size,
    if (mimeType != null) 'mimeType': mimeType,
    if (category != null) 'category': category,
    if (isPublic != null) 'isPublic': isPublic,
    if (storagePath != null) 'storagePath': storagePath,
    if (uploadedBy != null) 'uploadedBy': uploadedBy,
    if (entityType != null) 'entityType': entityType,
    if (entityId != null) 'entityId': entityId,
    if (metadata != null) 'metadata': metadata,
    if (uploadedAt != null) 'uploadedAt': uploadedAt,
    if (createdAt != null) 'createdAt': createdAt,
    if (updatedAt != null) 'updatedAt': updatedAt,
    if (status != null) 'status': status,
  };
}
