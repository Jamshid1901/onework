import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:onework/domen/interface/auth_facade.dart';
import 'package:onework/domen/model/edit_model.dart';
import 'package:onework/domen/model/profile_model.dart';
import 'package:onework/domen/model/token_model.dart';
import 'package:onework/domen/service/dio_service.dart';
import 'package:onework/domen/service/local_store.dart';
import 'package:onework/view/pages/register_page.dart';

import '../model/application_model.dart';

class AuthRepo implements AuthFacade {
  DioService dio = DioService();

  @override
  Future<Response?> signUp(
      {required String email, required String password}) async {
    try {
      var res = await dio.client().post(
        "/auth/sign-up",
        data: {"email": email, "password": password, "user_type": "applicant"},
      );
      return res;
    } catch (e) {
      debugPrint("Sign Up Error : $e");
      return null;
    }
  }

  @override
  Future<TokenModel?> verifyEmail(
      {required String email, required String code}) async {
    try {
      var res = await dio.client().post(
        "/auth/verify",
        data: {
          "email": email,
          "code": code,
        },
      );
      return TokenModel.fromJson(res.data);
    } catch (e) {
      debugPrint("Verify Error : $e");
      return null;
    }
  }

  @override
  Future logout() async {
    try {
      final token = await LocalStore.getAccessToken();
      await dio.client(token: token).post(
            "/auth/logout",
          );
      return null;
    } catch (e) {
      debugPrint(":Log out Error : $e");
      return null;
    }
  }

  @override
  Future<Response?> login(
      {required String email, required String password}) async {
    try {
      var res = await dio.client().post(
        "/auth/login",
        data: {"email": email, "password": password, "user_type": "applicant"},
      );
      return res;
    } catch (e) {
      debugPrint("Login Error : $e");
      return null;
    }
  }

  @override
  Future<ProfileModel?> getUser(BuildContext context) async {
    try {
      final token = await LocalStore.getAccessToken();
      var res = await dio.client(token: token).get(
            "/api/profile",
          );
      return ProfileModel.fromJson(res.data);
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        var res = await refreshToken(context);
        if (res != null) {
          // ignore: use_build_context_synchronously
          await getUser(context);
        }
      }
    }
    return null;
  }

  @override
  Future<TokenModel?> refreshToken(BuildContext context) async {
    try {
      final refreshToken = await LocalStore.getRefreshToken();
      print("refreshToken: $refreshToken");
      var res = await dio.client().post(
        "/token/refresh",
        data: {
          "refresh_token": refreshToken,
        },
      );

      var tokenModel = TokenModel.fromJson(res.data);
      await LocalStore.setAccessToken(tokenModel.token);
      return tokenModel;
    } on DioError catch (e) {
      if (e.response?.statusCode == 404) {
        LocalStore.clearAll();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const SignUp()),
            (route) => false);
      }
      debugPrint("Get Profile Error : $e");
      return null;
    }
  }

  @override
  Future editUser(BuildContext context, EditUserModel newUser) async {
    try {
      final token = await LocalStore.getAccessToken();
      var res = await dio
          .client(token: token)
          .put("/applicants/${newUser.id}", data: newUser.toJson());
      return null;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        var res = await refreshToken(context);
        if (res != null) {
          // ignore: use_build_context_synchronously
          await editUser(context, newUser);
        }
      }
    }
    return null;
  }

  @override
  Future<ApplicationModel?> getApplication(
      BuildContext context, int userId) async {
    try {
      final token = await LocalStore.getAccessToken();
      var res = await dio.client(token: token).get(
            "/applicants/4",
          );
      return ApplicationModel.fromJson(res.data);
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        var res = await refreshToken(context);
        if (res != null) {
          // ignore: use_build_context_synchronously
          await getApplication(context, userId);
        }
      }
    }
    return null;
  }

  @override
  Future uploadImage(BuildContext context, String imagePath) async {
    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(imagePath),
      "type": "restaurant/logo",
      "name": "James"
    });
    try {
      var res = await dio
          .client()
          .post("/api/v1/dashboard/galleries?image", data: formData);
      print("res : ${res.data["data"]["title"]}");
      return res.data["data"]["title"];
    } on DioError catch (e) {
      print("error : $e");
    }
    return null;
  }
}
