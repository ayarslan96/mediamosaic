import 'package:equatable/equatable.dart';
import 'media_content_model.dart';

class UserPreferences extends Equatable {
  final int id;
  final int userId;
  final List<String> categories;
  final List<MediaType> mediaTypes;
  final List<String> topics;
  final String? usageTime;

  const UserPreferences({
    required this.id,
    required this.userId,
    required this.categories,
    required this.mediaTypes,
    this.topics = const [],
    this.usageTime,
  });

  @override
  List<Object?> get props => [id, userId, categories, mediaTypes, topics, usageTime];

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      categories: List<String>.from(json['categories'] as List),
      mediaTypes: (json['media_types'] as List)
          .map((type) => MediaTypeExtension.fromString(type as String))
          .toList(),
      topics: json['topics'] != null ? List<String>.from(json['topics'] as List) : const [],
      usageTime: json['usage_time'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'categories': categories,
      'media_types': mediaTypes.map((type) => type.value).toList(),
      'topics': topics,
      'usage_time': usageTime,
    };
  }

  UserPreferences copyWith({
    int? id,
    int? userId,
    List<String>? categories,
    List<MediaType>? mediaTypes,
    List<String>? topics,
    String? usageTime,
  }) {
    return UserPreferences(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      categories: categories ?? this.categories,
      mediaTypes: mediaTypes ?? this.mediaTypes,
      topics: topics ?? this.topics,
      usageTime: usageTime ?? this.usageTime,
    );
  }
} 