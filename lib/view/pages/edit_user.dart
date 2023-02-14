import 'package:flutter/material.dart';
import 'package:onework/controller/auth_controller.dart';
import 'package:onework/domen/model/edit_model.dart';
import 'package:provider/provider.dart';

class EditUserPage extends StatefulWidget {
  final int userId;

  const EditUserPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final TextEditingController firstName = TextEditingController();
  final TextEditingController bio = TextEditingController();
  final TextEditingController country = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController imageUrl = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthController>().getApplication(context, widget.userId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthController>();
    firstName.text =  state.applicationModel?.firstName ?? "";
    bio.text =  state.applicationModel?.bio ?? "";
    country.text = state.applicationModel?.country ?? "";
    lastName.text =  state.applicationModel?.lastName ?? "";
    imageUrl.text =  state.applicationModel?.imageUrl ?? "";
    phoneNumber.text =  state.applicationModel?.phoneNumber ?? "";
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextFormField(
                    controller: firstName,
                    decoration: InputDecoration(labelText: "first name"),
                  ),
                  TextFormField(
                    controller: bio,
                    decoration: InputDecoration(labelText: "bio"),
                  ),
                  TextFormField(
                    controller: country,
                    decoration: InputDecoration(labelText: "country"),
                  ),
                  TextFormField(
                    controller: lastName,
                    decoration: InputDecoration(labelText: "last name"),
                  ),
                  TextFormField(
                    controller: imageUrl,
                    decoration: InputDecoration(labelText: "image url"),
                  ),
                  TextFormField(
                    controller: phoneNumber,
                    decoration: InputDecoration(labelText: "phone_number"),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        context.read<AuthController>().editUser(
                            context,
                            EditUserModel(
                              city: state.applicationModel?.city ?? "",
                              dateOfBirth:
                                  state.applicationModel?.dateOfBirth ?? "",
                              invisibleAge:
                                  state.applicationModel?.invisibleAge ?? false,
                              speciality:
                                  state.applicationModel?.speciality ?? "",
                              id: state.applicationModel?.id ?? 0,
                              firstName: firstName.text,
                              lastName: lastName.text,
                              phoneNumber: phoneNumber.text,
                              bio: bio.text,
                              country: country.text,
                              imageUrl: imageUrl.text,
                            ));
                      },
                      child: Text("Save"))
                ],
              ),
      ),
    );
  }
}
