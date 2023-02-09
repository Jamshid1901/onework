import 'package:flutter/material.dart';
import 'package:onework/controller/auth_controller.dart';
import 'package:onework/view/pages/register_page.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthController>().getUser();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthController>();
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("id : ${state.profile?.id ?? 0}"),
          Text("role : ${state.profile?.role ?? ""}"),
          Text("image_url : ${state.profile?.imageUrl ?? ""}"),
          ElevatedButton(onPressed: () {

          }, child: const Text("Edit Profile")),
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
