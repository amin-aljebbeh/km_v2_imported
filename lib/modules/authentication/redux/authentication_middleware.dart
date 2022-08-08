import 'package:kammun_app/modules/startup/redux/startup_action.dart';
import '../../../core/core_importer.dart';
import '../service/authentication_service.dart';
import '../view/blocked_user.dart';
import '../view/login_view.dart';
import '../view/otp_verification.dart';
import 'authentication_action.dart';

authenticationMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is VerifyCode) {
    store.dispatch(StartLoading());
    String token = await AuthenticationServices.verifyCode(
        code: action.verificationCode, userId: store.state.authenticationState.userId);
    if (token != 'null') {
      store.dispatch(LoggedInSuccessfully(token: token));
    } else {
      store.dispatch(StopLoading());
      store
          .dispatch(CatchError(errorMessage: 'رمز التفعيل الخاص بك غير صحيح', reason: 'رمز التفعيل الخاص بك غير صحيح'));
    }
  } else if (action is LoggedInSuccessfully) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userToken', action.token);
    store.dispatch(NoError());
    store.dispatch(FetchStartInformation());
  } else if (action is FetchVerificationCode) {
    try {
      store.dispatch(NoError());
      store.dispatch(StartLoading());
      bool result = await AuthenticationServices.fetchOtp(phoneNumber: action.phoneNumber);
      if (result) {
        store.dispatch(EnterNumber(phoneNumber: action.phoneNumber));
        store.dispatch(NoError());
        store.dispatch(StopLoading());
        store.dispatch(PushAndReplace(routeName: OTPVerification.routeName));
      } else {
        store.dispatch(StopLoading());
        store.dispatch(CatchError(
            errorMessage: ' يرجى المحاولة مرة أُخرى و التأكد من إتصالك بالإنترنت', reason: 'could not log in'));
      }
    } catch (e) {
      store.dispatch(StopLoading());
      store.dispatch(CatchError(errorMessage: 'حدث خطأ أثناء محاولة طلب الرمز', reason: 'could not log in'));
    }
  } else if (action is CheckIfUserLoggedIn) {
    String result = await AuthenticationServices.checkIfUserLoggedIn();
    if (result != 'null') {
      store.dispatch(LoggedInSuccessfully(token: result));
    } else {
      store.dispatch(UserNotLoggedIn());
      store.dispatch(PushAndReplace(routeName: LoginScreen.routeName));
    }
  } else if (action is BlockedUser) {
    store.dispatch(PushAndReplace(routeName: BlockedUserView.routeName));
  }
  next(action);
}
