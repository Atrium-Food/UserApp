import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/signup_model.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthRepo({@required this.dioClient, @required this.sharedPreferences});

  Future<ApiResponse> registration(SignUpModel signUpModel) async {
    try {
      Response response = await dioClient.post(
        AppConstants.REGISTER_URI,
        data: signUpModel.toJson(),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> login({String email, String password}) async {
    try {
      Response response = await dioClient.post(
        AppConstants.LOGIN_URI,
        data: {"email": email, "password": password},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print(e.toString());
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> googleSignIn() async {
    try {
      User _user;
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount
          .authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken
      );
      UserCredential authResult = await _auth.signInWithCredential(credential);
      _user = authResult.user;
      User currentUser = await _auth.currentUser;

      // String _token = googleSignInAuthentication.accessToken;
      String _token = await currentUser.getIdToken(true);
      print("Google Token: $_token");
      // while (_token.length > 0) {
      //   int startTokenLength =
      //   (_token.length >= 500 ? 500 : _token.length);
      //   print("TokenPart: " + _token.substring(0, startTokenLength));
      //   int lastTokenLength = _token.length;
      //   _token =
      //       _token.substring(startTokenLength, lastTokenLength);
      // }

      Response response = await dioClient.post(
        AppConstants.GOOGLE_AUTH_URI,
        data: {"firebase_token": _token},
      );
      return ApiResponse.withSuccess(response);

    } catch (e) {
      print(e.toString());
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }

  }

  // Future<ApiResponse> loginGoogle() async {
  //   String _token = await googleSignIn();
  //   try {
  //     Response response = await dioClient.post(
  //       AppConstants.GET_GOOGLE_ACCOUNT,
  //       data: {"token": _token},
  //     );
  //     return ApiResponse.withSuccess(response);
  //   } catch (e) {
  //     print(e.toString());
  //     return ApiResponse.withError(ApiErrorHandler.getMessage(e));
  //   }
  // }

  Future otpAuth() async {
    
  }

  Future<ApiResponse> updateToken() async {
    try {
      String _deviceToken;
      if (!Platform.isAndroid) {
        NotificationSettings settings =
            await FirebaseMessaging.instance.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );
        if (settings.authorizationStatus == AuthorizationStatus.authorized) {
          _deviceToken = await _saveDeviceToken();
        }
      } else {
        _deviceToken = await _saveDeviceToken();
      }
      FirebaseMessaging.instance.subscribeToTopic(AppConstants.TOPIC);
      Response response = await dioClient.post(
        AppConstants.TOKEN_URI,
        data: {"_method": "put", "cm_firebase_token": _deviceToken},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<String> _saveDeviceToken() async {
    String _deviceToken = await FirebaseMessaging.instance.getToken();
    if (_deviceToken != null) {
      print('--------Device Token---------- ' + _deviceToken);
    }
    return _deviceToken;
  }

  //otp login
  Future<ApiResponse> otpLogin(String number) async {
    try {
      Response response =
          await dioClient.post(AppConstants.OTPLOGIN, data: {"number": number});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // for forgot password
  Future<ApiResponse> forgetPassword(String email) async {
    try {
      Response response = await dioClient
          .post(AppConstants.FORGET_PASSWORD_URI, data: {"email": email});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> verifyToken(String email, String token) async {
    try {
      Response response = await dioClient.post(AppConstants.VERIFY_TOKEN_URI,
          data: {"email": email, "reset_token": token});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> resetPassword(
      String resetToken, String password, String confirmPassword) async {
    try {
      Response response = await dioClient.post(
        AppConstants.RESET_PASSWORD_URI,
        data: {
          "_method": "put",
          "reset_token": resetToken,
          "password": password,
          "confirm_password": confirmPassword
        },
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // for verify phone number
  Future<ApiResponse> checkEmail(String email) async {
    try {
      Response response = await dioClient
          .post(AppConstants.CHECK_EMAIL_URI, data: {"email": email});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> verifyEmail(String email, String token) async {
    try {
      Response response = await dioClient.post(AppConstants.VERIFY_EMAIL_URI,
          data: {"email": email, "token": token});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // for  user token
  Future<void> saveUserToken(String token) async {
    dioClient.token = token;
    dioClient.dio.options.headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };
    try {
      await sharedPreferences.setString(AppConstants.TOKEN, token);
    } catch (e) {
      print(e.toString());
    }
  }

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.TOKEN) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.TOKEN);
  }

  Future<bool> clearSharedData() async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.TOPIC);
    await sharedPreferences.remove(AppConstants.TOKEN);
    await sharedPreferences.remove(AppConstants.CART_LIST);
    await sharedPreferences.remove(AppConstants.USER_ADDRESS);
    await sharedPreferences.remove(AppConstants.SEARCH_ADDRESS);
    return true;
  }

  // for  Remember Email
  Future<void> saveUserNumberAndPassword(String number, String password) async {
    try {
      await sharedPreferences.setString(AppConstants.USER_PASSWORD, password);
      await sharedPreferences.setString(AppConstants.USER_NUMBER, number);
    } catch (e) {
      throw e;
    }
  }

  String getUserNumber() {
    return sharedPreferences.getString(AppConstants.USER_NUMBER) ?? "";
  }

  String getUserPassword() {
    return sharedPreferences.getString(AppConstants.USER_PASSWORD) ?? "";
  }

  Future<bool> clearUserNumberAndPassword() async {
    await sharedPreferences.remove(AppConstants.USER_PASSWORD);
    return await sharedPreferences.remove(AppConstants.USER_NUMBER);
  }
}
