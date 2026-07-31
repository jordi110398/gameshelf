class Profile {
  final String id;
  final String nickname;
  final String email;
  final String? avatarUrl;
  final String? bio;

  const Profile({
    required this.id,
    required this.nickname,
    required this.email,
    this.avatarUrl,
    this.bio,
  });

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map["id"],
      nickname: map["nickname"],
      email: map["email"],
      avatarUrl: map["avatar_url"],
      bio: map["bio"],
    );
  }
}