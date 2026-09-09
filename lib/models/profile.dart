import 'package:gameshelf/models/shelf_style.dart';

class Profile {
  final String id;
  final String nickname;
  final String? avatarUrl;
  final String? bio;
  final DateTime? createdAt;
  final ShelfLightStyle shelfLightStyle;
  final ShelfWoodColor shelfWoodColor;
  final Set<ShelfDecoration> shelfDecorations;
  final ShelfCoverStyle shelfCoverStyle;

  // Només ve informat quan el perfil és el de l'usuari autenticat
  // (profiles_public, usat per veure altres usuaris, no exposa l'email
  // ni l'idioma -- són preferències personals, no públiques).
  final String? email;
  final String? language;

  const Profile({
    required this.id,
    required this.nickname,
    this.avatarUrl,
    this.bio,
    this.createdAt,
    this.shelfLightStyle = ShelfLightStyle.neon,
    this.shelfWoodColor = ShelfWoodColor.walnut,
    this.shelfDecorations = const {},
    this.shelfCoverStyle = ShelfCoverStyle.cartridge,
    this.email,
    this.language,
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
      shelfDecorations: shelfDecorationsFromDb(
        map['shelf_decorations'] as List<dynamic>?,
      ),
      shelfCoverStyle: ShelfCoverStyleX.fromDb(
        map['shelf_cover_style'] as String?,
      ),
      email: map['email'] as String?,
      language: map['language'] as String?,
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
      'shelf_decorations': shelfDecorations.databaseValues,
      'shelf_cover_style': shelfCoverStyle.databaseValue,
      'email': email,
      'language': language,
    };
  }

  Profile copyWith({
    String? nickname,
    String? avatarUrl,
    String? bio,
    ShelfLightStyle? shelfLightStyle,
    ShelfWoodColor? shelfWoodColor,
    Set<ShelfDecoration>? shelfDecorations,
    ShelfCoverStyle? shelfCoverStyle,
    String? language,
  }) {
    return Profile(
      id: id,
      nickname: nickname ?? this.nickname,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      createdAt: createdAt,
      shelfLightStyle: shelfLightStyle ?? this.shelfLightStyle,
      shelfWoodColor: shelfWoodColor ?? this.shelfWoodColor,
      shelfDecorations: shelfDecorations ?? this.shelfDecorations,
      shelfCoverStyle: shelfCoverStyle ?? this.shelfCoverStyle,
      email: email,
      language: language ?? this.language,
    );
  }
}
