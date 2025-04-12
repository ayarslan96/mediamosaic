import 'package:equatable/equatable.dart';

enum MediaType {
  news,
  video,
  meme,
  tweet,
}

extension MediaTypeExtension on MediaType {
  String get name {
    switch (this) {
      case MediaType.news:
        return 'News';
      case MediaType.video:
        return 'Video';
      case MediaType.meme:
        return 'Meme';
      case MediaType.tweet:
        return 'Tweet';
    }
  }

  String get value {
    return toString().split('.').last;
  }

  static MediaType fromString(String value) {
    return MediaType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => MediaType.news,
    );
  }
}

class MediaContent extends Equatable {
  final int id;
  final String title;
  final String? summary;
  final String? imageUrl;
  final MediaType type;
  final DateTime publishedAt;
  final String? sourceName;
  final String? sourceUrl;
  final int likes;
  final int comments;
  final int shares;
  final bool isFavorite;
  final List<String> categories;

  const MediaContent({
    required this.id,
    required this.title,
    this.summary,
    this.imageUrl,
    required this.type,
    required this.publishedAt,
    this.sourceName,
    this.sourceUrl,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    this.isFavorite = false,
    this.categories = const [],
  });

  @override
  List<Object?> get props => [
        id,
        title,
        summary,
        imageUrl,
        type,
        publishedAt,
        sourceName,
        sourceUrl,
        likes,
        comments,
        shares,
        isFavorite,
        categories,
      ];

  factory MediaContent.fromJson(Map<String, dynamic> json) {
    return MediaContent(
      id: json['id'],
      title: json['title'],
      summary: json['summary'],
      imageUrl: json['imageUrl'],
      type: MediaType.values.firstWhere(
        (e) => e.toString() == 'MediaType.${json['type']}',
        orElse: () => MediaType.news,
      ),
      publishedAt: DateTime.parse(json['publishedAt']),
      sourceName: json['sourceName'],
      sourceUrl: json['sourceUrl'],
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      shares: json['shares'] ?? 0,
      isFavorite: json['isFavorite'] ?? false,
      categories: List<String>.from(json['categories'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'summary': summary,
      'imageUrl': imageUrl,
      'type': type.toString().split('.').last,
      'publishedAt': publishedAt.toIso8601String(),
      'sourceName': sourceName,
      'sourceUrl': sourceUrl,
      'likes': likes,
      'comments': comments,
      'shares': shares,
      'isFavorite': isFavorite,
      'categories': categories,
    };
  }

  MediaContent copyWith({
    int? id,
    String? title,
    String? summary,
    String? imageUrl,
    MediaType? type,
    DateTime? publishedAt,
    String? sourceName,
    String? sourceUrl,
    int? likes,
    int? comments,
    int? shares,
    bool? isFavorite,
    List<String>? categories,
  }) {
    return MediaContent(
      id: id ?? this.id,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      publishedAt: publishedAt ?? this.publishedAt,
      sourceName: sourceName ?? this.sourceName,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      isFavorite: isFavorite ?? this.isFavorite,
      categories: categories ?? this.categories,
    );
  }
} 