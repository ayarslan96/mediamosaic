import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String username;
  final String displayName;
  final String? bio;
  final String? avatarUrl;
  final DateTime joinedAt;

  const User({
    required this.id,
    required this.username,
    required this.displayName,
    this.bio,
    this.avatarUrl,
    required this.joinedAt,
  });

  @override
  List<Object?> get props => [id, username, displayName, bio, avatarUrl, joinedAt];

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      displayName: json['display_name'] as String,
      bio: json['bio'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      joinedAt: DateTime.parse(json['joined_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'display_name': displayName,
      'bio': bio,
      'avatar_url': avatarUrl,
      'joined_at': joinedAt.toIso8601String(),
    };
  }

  User copyWith({
    int? id,
    String? username,
    String? displayName,
    String? bio,
    String? avatarUrl,
    DateTime? joinedAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
} 