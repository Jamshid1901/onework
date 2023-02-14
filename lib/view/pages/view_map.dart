import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ViewMap extends StatefulWidget {
  const ViewMap({Key? key}) : super(key: key);

  @override
  State<ViewMap> createState() => _ViewMapState();
}

class _ViewMapState extends State<ViewMap> {
  MapType type = MapType.normal;
  BitmapDescriptor? myMarker;
  Set<Marker> setOfMarker = {};

  void setMarkerIcon() async {
    BitmapDescriptor myMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(25, 25)), 'assets/logo.png');
    BitmapDescriptor myMarker2 = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(25, 25)), 'assets/bg.png');
    setOfMarker.addAll({
      Marker(
          markerId: MarkerId("1"),
          draggable: true,
          consumeTapEvents: true,
          flat: true,
          icon: myMarker,
          position: LatLng(41.285416, 69.204007),
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("2"),
                  );
                });
          },
          onDrag: (location) {
            print("location: ${location.latitude}");
            print("location: ${location.longitude}");
          }),
      Marker(
          markerId: MarkerId("2"),
          draggable: true,
          consumeTapEvents: true,
          flat: true,
          icon: myMarker,
          position: LatLng(41.286254, 69.205696),
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("2"),
                  );
                });
          },
          onDrag: (location) {
            print("location: ${location.latitude}");
            print("location: ${location.longitude}");
          }),
    });
    setState(() {});
  }

  @override
  void initState() {
    setMarkerIcon();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: LayoutBuilder(
        builder: (context,v) {
          return GoogleMap(
            mapType: type,
            markers: setOfMarker,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            initialCameraPosition:
                CameraPosition(target: LatLng(41.285416, 69.204007), zoom: 17),
            onMapCreated: (GoogleMapController controller) {},
          );
        }
      ),
      floatingActionButton: Row(
        children: [
          FloatingActionButton.extended(
            onPressed: () {
              switch (type) {
                case MapType.normal:
                  type = MapType.hybrid;
                  break;
                case MapType.hybrid:
                  type = MapType.satellite;
                  break;
                case MapType.satellite:
                  type = MapType.terrain;
                  break;
                case MapType.terrain:
                  type = MapType.normal;
                  break;
                case MapType.none:
                  type = MapType.normal;
                  break;
              }

              setState(() {});
            },
            label: const Text('To the lake!'),
            icon: const Icon(Icons.directions_boat),
          ),
        ],
      ),
    );
  }
}
