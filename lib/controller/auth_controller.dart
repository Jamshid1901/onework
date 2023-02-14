import 'package:flutter/cupertino.dart';
import 'package:onework/domen/interface/auth_facade.dart';
import 'package:onework/domen/model/application_model.dart';
import 'package:onework/domen/model/edit_model.dart';
import 'package:onework/domen/model/login_model.dart';
import 'package:onework/domen/model/profile_model.dart';
import 'package:onework/domen/repository/auth_repo.dart';
import 'package:onework/domen/service/local_store.dart';

class AuthController extends ChangeNotifier {
  final AuthFacade authRepo = AuthRepo();
  ProfileModel? profile = ProfileModel();
  ApplicationModel? applicationModel = ApplicationModel();
  String? wrongPassword;
  String? imageUrl;
  bool isLoading = false;

  signUp({
    required String email,
    required String password,
    required String confirmPassword,
    required VoidCallback onSuccess,
  }) async {
    if (password == confirmPassword) {
      var res = await authRepo.signUp(email: email, password: password);
      if (res?.statusCode == 200) {
        onSuccess();
      }
    } else {
      wrongPassword = "Error Password";
      notifyListeners();
    }
  }

  login({
    required String email,
    required String password,
    required VoidCallback onSuccess,
  }) async {
    var res = await authRepo.login(email: email, password: password);
    if (res?.statusCode == 200) {
      var login = LoginModel.fromJson(res?.data);
      await LocalStore.setAccessToken(login.accessToken ?? "");
      await LocalStore.setRefreshToken(login.refreshToken ?? "");
      onSuccess();
    }
  }

  verifyEmail(
      {required String code,
      required String email,
      required VoidCallback onSuccess}) async {
    var res = await authRepo.verifyEmail(email: email, code: code);
    if (res != null) {
      await LocalStore.setAccessToken(res.token);
      await LocalStore.setRefreshToken(res.refreshToken!);
      onSuccess();
    }
  }

  logOut() {
    LocalStore.clearAll();
    authRepo.logout();
  }

  getUser(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    profile = await authRepo.getUser(context);
    isLoading = false;
    notifyListeners();
  }

  editUser(BuildContext context, EditUserModel newUser) async {
    isLoading = true;
    notifyListeners();
    profile = await authRepo.editUser(context, newUser);
    isLoading = false;
    notifyListeners();
  }

  getApplication(BuildContext context, int userId) async {
    isLoading = true;
    notifyListeners();
    applicationModel = await authRepo.getApplication(context, userId);
    isLoading = false;
    notifyListeners();
  }

  getUploading(BuildContext context, String imagePath) async {
    isLoading = true;
    notifyListeners();
    imageUrl = await authRepo.uploadImage(context, imagePath);
    isLoading = false;
    notifyListeners();
  }
}
