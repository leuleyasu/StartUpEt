class FileInfo {
  final String id;
  final String? name;
  final String? url;
  final int? size;
  final String? mimeType;
  final String? uploadedAt;
  final String? status;

  const FileInfo({
    required this.id,
    this.name,
    this.url,
    this.size,
    this.mimeType,
    this.uploadedAt,
    this.status,
  });

  factory FileInfo.fromJson(Map<String, dynamic> json) => FileInfo(
    id: json['id'] as String,
    name: json['name'] as String?,
    url: json['url'] as String?,
    size: json['size'] as int?,
    mimeType: json['mimeType'] as String?,
    uploadedAt: json['uploadedAt'] as String?,
    status: json['status'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    if (name != null) 'name': name,
    if (url != null) 'url': url,
    if (size != null) 'size': size,
    if (mimeType != null) 'mimeType': mimeType,
    if (uploadedAt != null) 'uploadedAt': uploadedAt,
    if (status != null) 'status': status,
  };
}
