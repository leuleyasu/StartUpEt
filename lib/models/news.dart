class News {
  final String id;
  final String title;
  final String? content;
  final String? author;
  final String? publishedAt;
  final String? imageUrl;
  final String? status;

  const News({
    required this.id,
    required this.title,
    this.content,
    this.author,
    this.publishedAt,
    this.imageUrl,
    this.status,
  });

  factory News.fromJson(Map<String, dynamic> json) => News(
    id: json['id'] as String,
    title: json['title'] as String,
    content: json['content'] as String?,
    author: json['author'] as String?,
    publishedAt: json['publishedAt'] as String?,
    imageUrl: json['imageUrl'] as String?,
    status: json['status'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    if (content != null) 'content': content,
    if (author != null) 'author': author,
    if (publishedAt != null) 'publishedAt': publishedAt,
    if (imageUrl != null) 'imageUrl': imageUrl,
    if (status != null) 'status': status,
  };
}
