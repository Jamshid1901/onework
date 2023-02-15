import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:onework/controller/auth_controller.dart';
import 'package:onework/domen/service/marker_image_cropper.dart';
import 'package:osm_nominatim/osm_nominatim.dart';
import 'package:provider/provider.dart';

class ViewMap extends StatefulWidget {
  const ViewMap({Key? key}) : super(key: key);

  @override
  State<ViewMap> createState() => _ViewMapState();
}

class _ViewMapState extends State<ViewMap> {
  MapType type = MapType.normal;
  BitmapDescriptor? myMarker;
  Set<Marker> setOfMarker = {};
  late Position position;
  late Place? place;
  final MarkerImageCropper markerImageCropper = MarkerImageCropper();
  late GoogleMapController mapController;

  void setMarkerIcon() async {
    var myMarker = await markerImageCropper.resizeAndCircle(
        "https://marketing.uz/uploads/works/covers/8bd79c07ebc2619902f950153e9d40d6.jpg",
        120);
    var myMarker2 = await markerImageCropper.resizeAndCircle(
        "https://mir-s3-cdn-cf.behance.net/projects/404/7a1cf9128084039.614eecd27342d.png",
        120);
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
                    title: Text("1"),
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
          icon: myMarker2,
          position: LatLng(41.406254, 69.205696),
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
      body: LayoutBuilder(builder: (context, v) {
        return Stack(
          children: [
            GoogleMap(
              mapType: type,
              markers: setOfMarker,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              polylines: {
                Polyline(
                  polylineId: PolylineId("1"),
                  points: context.watch<AuthController>().list,
                  color: Colors.red,
                )
              },
              initialCameraPosition: CameraPosition(
                  target: LatLng(41.285416, 69.204007), zoom: 17),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
            ),
            SafeArea(
              child: Container(
                margin: EdgeInsets.only(top: 16, right: 24, left: 24),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      onChanged: (s) {
                        context.read<AuthController>().search(s);
                      },
                      decoration: InputDecoration(
                        hintText: "Search",
                      ),
                    ),
                    (context.watch<AuthController>().searchText?.isNotEmpty ??
                            false)
                        ? FutureBuilder(
                            future: Nominatim.searchByName(
                              query: context.watch<AuthController>().searchText,
                              limit: 5,
                              addressDetails: true,
                              extraTags: true,
                              nameDetails: true,
                            ),
                            builder: (context, value) {
                              if (value.hasData) {
                                return ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: value.data?.length ?? 0,
                                    itemBuilder: (context2, index) {
                                      return GestureDetector(
                                        onTap: () async {
                                          FocusScope.of(context).unfocus();
                                          context
                                              .read<AuthController>()
                                              .search("");
                                          position = await context
                                              .read<AuthController>()
                                              .determinePosition();
                                          place = value.data?[index];
                                          mapController.animateCamera(
                                            CameraUpdate.newCameraPosition(
                                              CameraPosition(
                                                  target: LatLng(
                                                      position.latitude,
                                                      position.longitude),
                                                  zoom: 18),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(
                                              value.data?[index].displayName ??
                                                  ""),
                                        ),
                                      );
                                    });
                              } else if (value.hasError) {
                                return Text(value.error.toString());
                              } else {
                                return const CircularProgressIndicator();
                              }
                            })
                        : const SizedBox.shrink()
                  ],
                ),
              ),
            )
          ],
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          context.read<AuthController>().getRout(
              context,
              LatLng(position.latitude, position.longitude),
              LatLng(place?.lat ?? 0, place?.lon ?? 0));
          // Position position =
          //     await context.read<AuthController>().determinePosition();
          // mapController.animateCamera(
          //   CameraUpdate.newCameraPosition(
          //     CameraPosition(
          //         target: LatLng(position.latitude, position.longitude),
          //         zoom: 15),
          //   ),
          // );

          // mapController.moveCamera(CameraUpdate.newCameraPosition(
          //     CameraPosition(target: LatLng(41.285416, 69.404007), zoom: 15)));

          // switch (type) {
          //   case MapType.normal:
          //     type = MapType.hybrid;
          //     break;
          //   case MapType.hybrid:
          //     type = MapType.satellite;
          //     break;
          //   case MapType.satellite:
          //     type = MapType.terrain;
          //     break;
          //   case MapType.terrain:
          //     type = MapType.normal;
          //     break;
          //   case MapType.none:
          //     type = MapType.normal;
          //     break;
          // }
          //
          // setState(() {});
        },
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }
}
