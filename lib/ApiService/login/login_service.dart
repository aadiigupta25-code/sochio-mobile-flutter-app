import 'dart:developer';
import 'package:era_shop/ApiModel/login/LoginModel.dart';
import 'package:era_shop/ApiService/api_client.dart';
import 'package:era_shop/utiles/Theme/theme_service.dart';
import 'package:era_shop/utiles/api_url.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';

class LoginApi extends GetxService {
  final ApiClient _apiClient = ApiClient();

  Future<LoginModel> login({
    String? image,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required int loginType,
    required String fcmToken,
    required String identity,
  }) async {
    try {
      log("Attempting login with email: $email");

      final requestBody = {
        'image': image,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'loginType': loginType,
        'fcmToken': fcmToken,
        'identity': identity,
      };

      final response = await _apiClient.post(
        endpoint: Constant.userLogin,
        body: requestBody,
      );

      log("Login response: $response");

      if (response["status"] == true) {
        getStorage.write("isLogin", true);
        log("Login successful");
      }

      return LoginModel.fromJson(response);
    } catch (e) {
      log("Login error: $e");
      throw Exception('Login Failed: ${e.toString()}');
    }
  }
}
