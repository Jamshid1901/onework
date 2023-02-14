import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:onework/controller/auth_controller.dart';
import 'package:onework/domen/service/local_store.dart';
import 'package:onework/view/pages/register_page.dart';
import 'package:provider/provider.dart';

import 'edit_user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<AuthController>().getUser(context);
      var refreshToken = await LocalStore.getRefreshToken();
      print("refreshToken : $refreshToken");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthController>();
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.add))],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("id : ${state.profile?.id ?? 0}"),
                Text("role : ${state.profile?.role ?? ""}"),
                Text("image_url : ${state.profile?.imageUrl ?? ""}"),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => EditUserPage(
                                    userId: state.profile?.id ?? 0,
                                  )));
                    },
                    child: Text("edit_profile".trim())),
                ElevatedButton(
                    onPressed: () {
                      context.read<AuthController>().logOut();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const SignUp()),
                          (route) => false);
                    },
                    child: const Text("Logout"))
              ],
            ),
    );
  }
}
