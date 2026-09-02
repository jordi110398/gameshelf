class Profile {
  final String id;
  final String nickname;
  final String? avatarUrl;
  final String? bio;
  final DateTime? createdAt;

  // Només ve informat quan el perfil és el de l'usuari autenticat
  // (profiles_public, usat per veure altres usuaris, no exposa l'email).
  final String? email;

  const Profile({
    required this.id,
    required this.nickname,
    this.avatarUrl,
    this.bio,
    this.createdAt,
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
      'email': email,
    };
  }
}
