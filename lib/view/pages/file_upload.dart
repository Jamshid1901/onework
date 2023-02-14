import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onework/controller/auth_controller.dart';
import 'package:provider/provider.dart';

class FileUpload extends StatefulWidget {
  const FileUpload({Key? key}) : super(key: key);

  @override
  State<FileUpload> createState() => _FileUploadState();
}

class _FileUploadState extends State<FileUpload> {
  final ImagePicker _picker = ImagePicker();
  late XFile? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Consumer(builder: (context, AuthController controller, child) {
            return Container(
              width: 400,
              height: 400,
              child: controller.imageUrl == null
                  ? Text("No Image")
                  : Image.network(controller.imageUrl ?? ""),
            );
          }),
          ElevatedButton(
              onPressed: () async {
                image = await _picker.pickImage(source: ImageSource.camera);
                print("xfile: ${image?.path}");
              },
              child: Text("Camera")),
          ElevatedButton(
              onPressed: () async {
                image = await _picker.pickImage(source: ImageSource.gallery);
                print("xfile: ${image?.path}");
              },
              child: Text("Photo")),
          ElevatedButton(
              onPressed: () async {
                final List<XFile>? images = await _picker.pickMultiImage();
                images?.forEach((e) {
                  print(e.path);
                });
              },
              child: Text("Multi Image Photo")),
          ElevatedButton(
              onPressed: () async {
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles();

                if (result != null) {
                  PlatformFile file = result.files.first;

                  print(file.name);
                  print(file.bytes);
                  print(file.size);
                  print(file.extension);
                  print(file.path);
                } else {
                  // User canceled the picker
                }
              },
              child: Text("File")),
          Consumer(builder: (context, AuthController controller, child) {
            return ElevatedButton(
                onPressed: () {
                  controller.getUploading(context, image?.path ?? "");
                },
                child: controller.isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text("Uploading"));
          })
        ],
      ),
    );
  }
}
