import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:onework/domen/model/application_model.dart';
import 'package:onework/domen/model/edit_model.dart';
import 'package:onework/domen/model/profile_model.dart';

import '../model/token_model.dart';

abstract class AuthFacade {
  Future<Response?> signUp({required String email, required String password});

  Future<Response?> login({required String email, required String password});

  Future<TokenModel?> verifyEmail({required String email, required String code});

  Future logout();

  Future<TokenModel?> refreshToken(BuildContext context);

  Future<ProfileModel?> getUser(BuildContext context);

  Future<ApplicationModel?> getApplication(BuildContext context,int userId);

  Future editUser(BuildContext context,EditUserModel newUser);

  Future uploadImage(BuildContext context,String imagePath);

}
