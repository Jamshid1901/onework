import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:onework/view/pages/profile_page.dart';
import 'package:onework/view/pages/register_page.dart';

import '../../domen/service/local_store.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    checkToken();
    super.initState();
  }

  checkToken() async {
    if (await LocalStore.getAccessToken() == null ||
        await LocalStore.getAccessToken() == "") {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const SignUp()), (route) => false);
      // if (LocalStore.getOnBoarding() == null) {
      //   // go OnBoarding
      // } else {
      //   // go sign up
      // }
      FlutterNativeSplash.remove();
    } else {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const ProfilePage()),
          (route) => false);
    }
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
