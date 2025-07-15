import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final String token;
  final String? refreshToken;
  final String? userId;
  final String? username;

  const AuthUser({
    required this.token,
    this.refreshToken,
    this.userId,
    this.username,
  });

  AuthUser copyWith({
    String? token,
    String? refreshToken,
    String? userId,
    String? username,
  }) {
    return AuthUser(
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      userId: userId ?? this.userId,
      username: username ?? this.username,
    );
  }

  @override
  List<Object?> get props => [token, refreshToken, userId, username];
}