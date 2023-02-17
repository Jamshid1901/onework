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
    print("object : ${listOfMarker.length}");
    listOfMarker.forEach((element) {
      print("object1: ${element.mapId}");
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          YandexMap(
            mapObjects: [
              PlacemarkMapObject(
                mapId: const MapObjectId("1"),
                point: const Point(latitude: 41.285416, longitude: 69.204007),
                icon: PlacemarkIcon.single(
                  PlacemarkIconStyle(
                    image: BitmapDescriptor.fromAssetImage("assets/map.webp"),
                    scale: 0.5,
                  ),
                ),
              ),
              ...listOfMarker
            ],
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
                                              Point(
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
                                        context
                                            .read<AuthController>()
                                            .search("");
                                        yandexMapController.notifyListeners();
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
