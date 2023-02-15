import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class YandexMapPage extends StatefulWidget {
  const YandexMapPage({Key? key}) : super(key: key);

  @override
  State<YandexMapPage> createState() => _YandexMapPageState();
}

class _YandexMapPageState extends State<YandexMapPage> {
  late YandexMapController yandexMapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: YandexMap(
        onMapCreated: (YandexMapController controller) {
          yandexMapController = controller;
          yandexMapController.moveCamera(
            CameraUpdate.newCameraPosition(
              const CameraPosition(
                  target: Point(latitude: 41.285416, longitude: 69.204007)),
            ),
          );
        },
      ),
    );
  }
}
