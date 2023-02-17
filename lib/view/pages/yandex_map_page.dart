import 'dart:math';

import 'package:flutter/material.dart';
import 'package:onework/controller/auth_controller.dart';
import 'package:provider/provider.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class YandexMapPage extends StatefulWidget {
  const YandexMapPage({Key? key}) : super(key: key);

  @override
  State<YandexMapPage> createState() => _YandexMapPageState();
}

class _YandexMapPageState extends State<YandexMapPage> {
  late YandexMapController yandexMapController;
  List<MapObject> listOfMarker = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          YandexMap(
            mapObjects: [...listOfMarker],
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
          SafeArea(
            child: Container(
              // ignore: prefer_const_constructors
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
                    decoration: const InputDecoration(
                      hintText: "Search",
                    ),
                  ),
                  (context.watch<AuthController>().searchText?.isNotEmpty ??
                          false)
                      ? FutureBuilder(
                          future: YandexSearch.searchByText(
                              searchText:
                                  context.watch<AuthController>().searchText ??
                                      "",
                              geometry: Geometry.fromBoundingBox(
                                  const BoundingBox(
                                      northEast: Point(
                                          longitude: 55.9289172707,
                                          latitude: 37.1449940049),
                                      southWest: Point(
                                          longitude: 73.055417108,
                                          latitude: 45.5868043076))),
                              searchOptions: const SearchOptions(
                                searchType: SearchType.none,
                                geometry: true,
                              )).result,
                          builder: (context, value) {
                            if (value.hasData) {
                              return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: value.data?.items?.length ?? 0,
                                  itemBuilder: (context2, index) {
                                    return GestureDetector(
                                      onTap: () async {
                                        FocusScope.of(context).unfocus();
                                        listOfMarker.add(PlacemarkMapObject(
                                          mapId: const MapObjectId("start"),
                                          point: const Point(
                                              latitude: 41.285416,
                                              longitude: 69.204007),
                                          icon: PlacemarkIcon.single(
                                            PlacemarkIconStyle(
                                              image: BitmapDescriptor
                                                  .fromAssetImage(
                                                      "assets/map.webp"),
                                              scale: 0.4,
                                            ),
                                          ),
                                          opacity: 1,
                                        ));
                                        listOfMarker.add(PlacemarkMapObject(
                                          mapId: const MapObjectId("end"),
                                          point: value.data?.items?[index]
                                                  .geometry.first.point ??
                                              const Point(
                                                  latitude: 42.285416,
                                                  longitude: 69.204007),
                                          icon: PlacemarkIcon.single(
                                            PlacemarkIconStyle(
                                              image: BitmapDescriptor
                                                  .fromAssetImage(
                                                      "assets/map.webp"),
                                              scale: 0.4,
                                            ),
                                          ),
                                          opacity: 1,
                                        ));
                                        var res = await YandexDriving
                                                .requestRoutes(points: [
                                          const RequestPoint(
                                              point: Point(
                                                  latitude: 41.285416,
                                                  longitude: 69.204007),
                                              requestPointType:
                                                  RequestPointType.wayPoint),
                                          RequestPoint(
                                              point: value.data?.items?[index]
                                                      .geometry.first.point ??
                                                  const Point(
                                                      latitude: 42.285416,
                                                      longitude: 69.204007),
                                              requestPointType:
                                                  RequestPointType.wayPoint)
                                        ], drivingOptions: DrivingOptions())
                                            .result;
                                        res.routes?.asMap().forEach((index,element) {
                                          listOfMarker.add(
                                            PolylineMapObject(
                                                mapId: MapObjectId(
                                                    "id$index"),
                                                polyline: Polyline(
                                                    points: element.geometry),
                                                strokeColor: Colors.primaries[
                                                    Random().nextInt(Colors
                                                        .primaries.length)],
                                                outlineColor: Colors.teal),
                                          );
                                        });
                                        // ignore: use_build_context_synchronously
                                        context
                                            .read<AuthController>()
                                            .search("");
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                            "${value.data?.items?[index].name}, ${value.data?.items?[index].businessMetadata?.address.formattedAddress ?? ""}"),
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
      ),
    );
  }
}
