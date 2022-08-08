class EnterNumber {
  final String phoneNumber;

  EnterNumber({this.phoneNumber});
}

class ReSendCode {
  final bool reSend;

  ReSendCode({this.reSend});
}

class LoggedInSuccessfully {
  final String token;

  LoggedInSuccessfully({this.token});
}

class FetchVerificationCode {
  final String phoneNumber;

  FetchVerificationCode({this.phoneNumber});
}

class VerifyCode {
  final String verificationCode;

  VerifyCode({this.verificationCode});
}

class CodeVerified {}

class FakeCode {
  final String message = 'رمز التفعيل الخاص بك غير صحيح';
}

class CheckIfUserLoggedIn {}

class UserNotLoggedIn {}

class BlockedUser {}

class SetUserId {
  final int userId;

  SetUserId({this.userId});
}

class SetToken {
  final String token;

  SetToken({this.token});
}
