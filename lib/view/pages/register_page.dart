import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:onework/controller/auth_controller.dart';
import 'package:onework/view/pages/login_page.dart';
import 'package:provider/provider.dart';

import 'confirm_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
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
        title: Text("edit_profile".tr()),
        actions: [
          IconButton(
              onPressed: () {
                context.setLocale(Locale('en', 'US'));

              },
              icon: const Text("En")),
          IconButton(
              onPressed: () {
                context.setLocale(Locale('de', 'DE'));
              },
              icon: const Text("De"))
        ],
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
              TextFormField(
                controller: confirmPassword,
                decoration:
                    const InputDecoration(labelText: "Password Confirmation"),
                validator: (s) {
                  if (s?.isEmpty ?? true) {
                    return "Password Confirmation toliqmas";
                  } else if (password.text != s) {
                    return "Password Confirmation bir xil emas";
                  }
                  return null;
                },
              ),
              context.watch<AuthController>().wrongPassword != null
                  ? Text(context.watch<AuthController>().wrongPassword ?? "")
                  : const SizedBox.shrink(),
              ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      context.read<AuthController>().signUp(
                          email: email.text,
                          password: password.text,
                          confirmPassword: confirmPassword.text,
                          onSuccess: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => ConfirmationPage(
                                      email: email.text,
                                    )));
                          });
                    }
                  },
                  child: Text("sign_up".tr())),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const LoginPage()));
                  },
                  child: const Text("Login"))
            ],
          ),
        ),
      ),
    );
  }
}
