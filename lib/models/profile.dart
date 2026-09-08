import 'package:gameshelf/models/shelf_style.dart';

class Profile {
  final String id;
  final String nickname;
  final String? avatarUrl;
  final String? bio;
  final DateTime? createdAt;
  final ShelfLightStyle shelfLightStyle;
  final ShelfWoodColor shelfWoodColor;

  // Només ve informat quan el perfil és el de l'usuari autenticat
  // (profiles_public, usat per veure altres usuaris, no exposa l'email).
  final String? email;

  const Profile({
    required this.id,
    required this.nickname,
    this.avatarUrl,
    this.bio,
    this.createdAt,
    this.shelfLightStyle = ShelfLightStyle.neon,
    this.shelfWoodColor = ShelfWoodColor.walnut,
    this.email,
  });

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'] as String,
      nickname: map['nickname'] as String,
      avatarUrl: map['avatar_url'] as String?,
      bio: map['bio'] as String?,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      shelfLightStyle: ShelfLightStyleX.fromDb(
        map['shelf_light_style'] as String?,
      ),
      shelfWoodColor: ShelfWoodColorX.fromDb(
        map['shelf_wood_color'] as String?,
      ),
      email: map['email'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nickname': nickname,
      'avatar_url': avatarUrl,
      'bio': bio,
      'created_at': createdAt?.toIso8601String(),
      'shelf_light_style': shelfLightStyle.databaseValue,
      'shelf_wood_color': shelfWoodColor.databaseValue,
      'email': email,
    };
  }

  Profile copyWith({
    String? nickname,
    String? avatarUrl,
    String? bio,
    ShelfLightStyle? shelfLightStyle,
    ShelfWoodColor? shelfWoodColor,
  }) {
    return Profile(
      id: id,
      nickname: nickname ?? this.nickname,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      createdAt: createdAt,
      shelfLightStyle: shelfLightStyle ?? this.shelfLightStyle,
      shelfWoodColor: shelfWoodColor ?? this.shelfWoodColor,
      email: email,
    );
  }
}
