import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:onework/domen/interface/auth_facade.dart';
import 'package:onework/domen/model/application_model.dart';
import 'package:onework/domen/model/edit_model.dart';
import 'package:onework/domen/model/login_model.dart';
import 'package:onework/domen/model/profile_model.dart';
import 'package:onework/domen/model/rout_model.dart';
import 'package:onework/domen/repository/auth_repo.dart';
import 'package:onework/domen/service/local_store.dart';

class AuthController extends ChangeNotifier {
  final AuthFacade authRepo = AuthRepo();
  ProfileModel? profile = ProfileModel();
  ApplicationModel? applicationModel = ApplicationModel();
  String? wrongPassword;
  String? imageUrl;
  String? searchText;
  bool isLoading = false;
  List<LatLng> list = [];



  search(String searchText){
    this.searchText = searchText;
    notifyListeners();
  }

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

  getRout(BuildContext context, LatLng start, LatLng end) async {
    DrawRouting? routing =
        await authRepo.getRout(context: context, start: start, end: end);

    List ls = routing?.features[0].geometry.coordinates ?? [];
    for (int i = 0; i < ls.length; i++) {
      list.add(LatLng(ls[i][1], ls[i][0]));
    }
    notifyListeners();
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
