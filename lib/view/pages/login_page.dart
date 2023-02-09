import 'package:flutter/material.dart';
import 'package:onework/controller/auth_controller.dart';
import 'package:onework/view/pages/profile_page.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController password = TextEditingController();
  late TextEditingController email;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    email = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    password.dispose();
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextFormField(
                controller: email,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (s) {
                  final bool emailValid = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(s ?? "");

                  if (s?.isEmpty ?? true) {
                    return "Email kirting";
                  } else if (!emailValid) {
                    return "Email togri kiriting";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: password,
                decoration: const InputDecoration(labelText: "Password"),
                validator: (s) {
                  if (s?.isEmpty ?? true) {
                    return "Password toliqmas";
                  }
                  return null;
                },
              ),
              ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      context.read<AuthController>().login(
                          email: email.text,
                          password: password.text,
                          onSuccess: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => const ProfilePage()));
                          });
                    }
                  },
                  child: const Text("Sign Up"))
            ],
          ),
        ),
      ),
    );
  }
}
