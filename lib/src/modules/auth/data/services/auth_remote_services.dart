import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tarsheed/src/core/apis/api.dart';
import 'package:tarsheed/src/core/apis/dio_helper.dart';
import 'package:tarsheed/src/core/apis/end_points.dart';
import 'package:tarsheed/src/core/error/custom_exceptions/auth_exceptions.dart';
import 'package:tarsheed/src/modules/auth/data/models/auth_info.dart';
import 'package:tarsheed/src/modules/auth/data/models/email_and_password_registration_form.dart';

abstract class BaseAuthRemoteServices {
  Future<Either<Exception, AuthInfo>> registerWithEmailAndPassword(
      {required EmailAndPasswordRegistrationForm registrationForm});
  Future<Either<Exception, Unit>> verifyEmail(
      {required String code, required String verificationId});
  Future<Either<Exception, Unit>> confirmForgotPasswordCode(
      {required String code, required String verificationId});

  Future<Either<Exception, AuthInfo>> loginWithEmailAndPassword(
      {required String email, required String password});

  Future<Either<Exception, String>> resendEmailVerificationCode();
  Future<Either<Exception, String>> forgetPassword({required String email});
  Future<Either<Exception, Unit>> resetPassword(
    String newPassword,
  );
  Future<Either<Exception, AuthInfo>> loginWithGoogle();
  Future<Either<Exception, AuthInfo>> loginWithFacebook();

  Future<Either<Exception, Unit>> updatePassword(
      String oldPassword, String newPassword);
}

class AuthRemoteServices extends BaseAuthRemoteServices {
  @override
  Future<Either<Exception, AuthInfo>> registerWithEmailAndPassword(
      {required EmailAndPasswordRegistrationForm registrationForm}) async {
    try {
      var response = await DioHelper.postData(
          path: EndPoints.register, data: registrationForm.toJson());
      return Right(AuthInfo.fromJson(response.data["data"]));
    } on Exception catch (e) {
      return Left(_classifyException(e,
          process: "registering with email and password"));
    }
  }

  @override
  Future<Either<Exception, Unit>> verifyEmail(
      {required String code, required String verificationId}) async {
    try {
      var response = await DioHelper.postData(
          path: EndPoints.verify, data: {"id": verificationId, "code": code});

      return Right(unit);
    } on Exception catch (e) {
      return Left(_classifyException(e, process: "verifying email with code"));
    }
  }

  @override
  Future<Either<Exception, String>> resendEmailVerificationCode() async {
    try {
      var response = await DioHelper.postData(
          path: EndPoints.resendCode + ApiManager.userId!,
          query: {"userId": ApiManager.userId});
      var id = response.data["id"];

      return Right(id);
    } on Exception catch (e) {
      return Left(
          _classifyException(e, process: "resending email verification code"));
    }
  }

  @override
  Future<Either<Exception, AuthInfo>> loginWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      var response = await DioHelper.postData(
          path: EndPoints.login, data: {"email": email, "password": password});
      return Right(AuthInfo.fromJson(response.data));
    } on Exception catch (e) {
      return Left(
          _classifyException(e, process: "logging in with email and password"));
    }
  }

  @override
  Future<Either<Exception, String>> forgetPassword(
      {required String email}) async {
    try {
      var response = await DioHelper.postData(
          path: EndPoints.forgetPassword, data: {"email": email});
      String id = response.data["id"];
      return Right(id);
    } on Exception catch (e) {
      return Left(_classifyException(e, process: "forgetting password"));
    }
  }

  @override
  Future<Either<Exception, Unit>> confirmForgotPasswordCode(
      {required String code, required String verificationId}) async {
    try {
      await DioHelper.postData(
          path: EndPoints.confirmForgotPasswordCode,
          data: {
            "code": code,
            "id": verificationId, //
          });
      return Right(unit);
    } on Exception catch (e) {
      return Left(
          _classifyException(e, process: "confirming forgot password code"));
    }
  }

  @override
  Future<Either<Exception, Unit>> resetPassword(String newPassword) async {
    try {
      await DioHelper.patchData(
          path: EndPoints.resetPassword,
          data: {"id": ApiManager.userId!, "new_password": newPassword});
      return Right(unit);
    } on Exception catch (e) {
      return Left(_classifyException(e, process: "resetting password"));
    }
  }

  @override
  Future<Either<Exception, Unit>> updatePassword(
      String oldPassword, String newPassword) async {
    try {
      await DioHelper.putData(
          path: EndPoints.updatePassword(ApiManager.userId!),
          data: {"old_password": oldPassword, "new_password": newPassword});
      return Right(unit);
    } on Exception catch (e) {
      return Left(_classifyException(e));
    }
  }

  @override
  Future<Either<Exception, AuthInfo>> loginWithFacebook() async {
    try {
      var accessToken = _getFacebookAccessToken();
      var response = await DioHelper.postData(
          path: EndPoints.facebookLogin, query: {"Authorization": accessToken});
      return Right(AuthInfo.fromJson(response.data));
    } on Exception catch (e) {
      return Left(_classifyException(e));
    }
  }

  Future<String> _getFacebookAccessToken() async {
    // TODO: implement loginWithFacebook
    throw UnimplementedError();
  }

  @override
  Future<Either<Exception, AuthInfo>> loginWithGoogle() async {
    try {
      var accessToken = await _getGoogleAccessToken();
      var response = await DioHelper.postData(
          path: EndPoints.googleLogin, query: {"Authorization": accessToken});
      return Right(AuthInfo.fromJson(response.data));
    } on Exception catch (e) {
      return Left(_classifyException(e));
    }
  }

  Future<String> _getGoogleAccessToken() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    if (googleSignIn.currentUser != null) {
      await googleSignIn.signOut();
    }
    var googleUser = await googleSignIn.signIn();
    var googleAuth = await googleUser?.authentication;
    var accessToken = googleAuth?.accessToken;
    return accessToken!;
  }

  _classifyException(Exception exception, {String? process}) {
    {
      if (exception is DioException) {
        AuthException authException = AuthException(
            requestOptions: exception.requestOptions,
            response: exception.response);
        return authException;
      }
      return exception;
    }
  }
  /*

  Future<User> signInWithFacebook() async {
    //? to generate sha1 code in CMD ---> gradlew signingReport
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);
    final LoginResult loginResult = await FacebookAuth.instance.login(
      nonce: nonce,
    );
    OAuthCredential facebookAuthCredential;

    if (Platform.isIOS) {
      switch (loginResult.accessToken!.type) {
        case AccessTokenType.classic:
          final token = loginResult.accessToken as ClassicToken;
          facebookAuthCredential = FacebookAuthProvider.credential(
            token.authenticationToken!,
          );
          break;
        case AccessTokenType.limited:
          final token = loginResult.accessToken as LimitedToken;
          facebookAuthCredential = OAuthCredential(
            providerId: 'facebook.com',
            signInMethod: 'oauth',
            idToken: token.tokenString,
            rawNonce: rawNonce,
          );
          break;
      }
    } else {
      facebookAuthCredential = FacebookAuthProvider.credential(
        loginResult.accessToken!.tokenString,
      );
    }

    return (await FirebaseAuth.instance.signInWithCredential(
      facebookAuthCredential,
    ))
        .user!;
  }

   */
}
/*


 */
