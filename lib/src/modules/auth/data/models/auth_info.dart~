class AuthInfo {
  final String accessToken;
  final String userId;

  const AuthInfo({required this.accessToken, required this.userId});

  factory AuthInfo.fromJson(Map<String, dynamic> json) {
    return AuthInfo(
      accessToken: json['token'],
      userId: json['id'] ?? "",
    );
  }
  Map<String, dynamic> toJson() => {'token': accessToken, 'id': userId};
}
