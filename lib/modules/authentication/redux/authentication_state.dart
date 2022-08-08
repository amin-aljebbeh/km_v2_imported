import 'package:meta/meta.dart';

@immutable
class AuthenticationState {
  final bool isLoggedIn;
  final bool reSendCode;
  final bool blockedUser;
  final String phoneNumber;
  final String token;
  final int userId;

  const AuthenticationState(
      {this.userId, this.blockedUser, this.reSendCode, this.token, this.phoneNumber, this.isLoggedIn});

  factory AuthenticationState.initial() {
    return const AuthenticationState(
        isLoggedIn: false, token: 'null', phoneNumber: '', reSendCode: false, blockedUser: false, userId: 0);
  }

  AuthenticationState copyWith(
      {bool isLoggedIn, String token, String phoneNumber, bool reSendCode, bool blockedUser, int userId}) {
    return AuthenticationState(
      token: token ?? this.token,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      reSendCode: reSendCode ?? this.reSendCode,
      blockedUser: blockedUser ?? this.blockedUser,
      userId: userId ?? this.userId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthenticationState &&
          runtimeType == other.runtimeType &&
          token == other.token &&
          isLoggedIn == other.isLoggedIn &&
          phoneNumber == other.phoneNumber &&
          reSendCode == other.reSendCode &&
          blockedUser == other.blockedUser &&
          userId == other.userId;

  @override
  int get hashCode => super.hashCode;
}
