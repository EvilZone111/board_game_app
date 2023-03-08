import 'dart:async';

import 'package:board_game_app/instruments/components/custom_button.dart';
import 'package:board_game_app/instruments/constants.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'search_address_screen.dart';
import '../../../instruments/helpers.dart';

class MapPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return _ReverseSearchExample();
  }
}

class _ReverseSearchExample extends StatefulWidget {

  @override
  _ReverseSearchExampleState createState() => _ReverseSearchExampleState();
}

class _ReverseSearchExampleState extends State<_ReverseSearchExample> {
  // String? result;
  Map<String, String> addressAndCity = {};
  late YandexMapController controller;
  late final List<MapObject> mapObjects = [];
  final MapObjectId cameraMapObjectId = const MapObjectId('camera_placemark');
  bool isMoving=false;
  late Point myLocation;


  Future<Point> getLocation() async{
    Location location = Location();
    await location.getCurrentLocation();
    Point point = Point(latitude: location.latitude, longitude: location.longitude);
    return point;
  }

  Future<Map<String, String>> _search() async {
    final cameraPosition = await controller.getCameraPosition();

    final resultWithSession = YandexSearch.searchByPoint(
      point: cameraPosition.target,
      zoom: cameraPosition.zoom.toInt(),
      searchOptions: const SearchOptions(
        searchType: SearchType.geo,
        geometry: false,
      ),
    );

    var result = await resultWithSession.result;
    Map<String, String> values = {};
    values['address'] = getFormattedAddress(result.items![0].toponymMetadata!.address);
    values['city'] = result.items![0].toponymMetadata!.address.addressComponents[SearchComponentKind.locality]!;
    // return getFormattedAddress(result.items![0].toponymMetadata!.address);
    return values;
  }

  void goToSearchAddressPage(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchAddressPage(myLocation: myLocation),
        )
    );
    if(result!=null) {
      // final cameraPosition = await controller.getScreenPoint(result);
      await controller.moveCamera(
          CameraUpdate.newCameraPosition(CameraPosition(
              target: result, zoom: 15))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const mapHeight = 600.0;
    const markerSize = 80.0;
    const animation = MapAnimation(type: MapAnimationType.smooth, duration: 0.1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Выбрать место проведения'),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: mapHeight,
        child: FutureBuilder(
          // future: myLocation,
          future: getLocation(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.data == null) {
              //return SizedBox.shrink();
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              myLocation = snapshot.data;
              mapObjects.add(
                PlacemarkMapObject(
                  mapId: cameraMapObjectId,
                  point: myLocation,
                ),
              );
              return Stack(
                children: [
                  YandexMap(
                    mapObjects: mapObjects,
                    onCameraPositionChanged: (CameraPosition cameraPosition,
                        CameraUpdateReason _, bool __) async {
                      final placeMarkMapObject = mapObjects
                          .firstWhere((el) =>
                      el.mapId == cameraMapObjectId) as PlacemarkMapObject;

                      setState(() {
                        mapObjects[mapObjects.indexOf(placeMarkMapObject)] =
                            placeMarkMapObject.copyWith(
                                point: cameraPosition.target
                            );
                      });
                    },
                    onMapCreated: (
                        YandexMapController yandexMapController) async {
                      final placeMarkMapObject = mapObjects
                          .firstWhere((el) =>
                      el.mapId == cameraMapObjectId) as PlacemarkMapObject;
                      controller = yandexMapController;
                      await controller.moveCamera(
                          CameraUpdate.newCameraPosition(CameraPosition(
                              target: placeMarkMapObject.point, zoom: 17))
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: kDefaultPagePadding,
                      child: FutureBuilder(
                        future: _search(),
                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          if(snapshot.data!=null){
                            addressAndCity=snapshot.data;
                          }
                          return Text(
                            snapshot.connectionState != ConnectionState.done
                                ? 'Идёт поиск...'
                                : snapshot.data==null ? '' : snapshot.data['address'],
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          );
                        },
                      ),
                    ),
                  ),
                  const Align(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: markerSize*3/4),
                      child:  Image(
                        image: AssetImage('assets/images/place.png'),
                        width: markerSize,
                        height: markerSize,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ScaleButton(
                            text: '+',
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            onTap: () async {
                              await controller.moveCamera(CameraUpdate.zoomIn(), animation: animation);
                            },
                            isAlignedBottom: true,
                          ),
                          ScaleButton(
                            text: '-',
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            onTap: () async {
                              await controller.moveCamera(CameraUpdate.zoomOut(), animation: animation);
                            },
                            isAlignedBottom: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: kDefaultBackgroundColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: kDefaultPagePadding,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            kHorizontalSizedBoxDivider,
                            CustomButton(
                              onPressed: (){
                                if(addressAndCity!=null) {
                                  Navigator.pop(context, addressAndCity);
                                }
                              },
                              text: 'Выбрать этот адрес',
                              color: const Color(0xFF090909),
                              textColor: Colors.white,
                            ),
                            kHorizontalSizedBoxDivider,
                            CustomButton(
                              onPressed: (){
                                goToSearchAddressPage(context);
                              },
                              text: 'Ввести вручную',
                              color: Colors.white,
                              textColor: Colors.black,
                            ),
                            kHorizontalSizedBoxDivider,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}


class ScaleButton extends StatelessWidget {

  final String text;
  final BorderRadius borderRadius;
  final VoidCallback onTap;
  final bool isAlignedBottom;
  ScaleButton({
    required this.text,
    required this.borderRadius,
    required this.onTap,
    required this.isAlignedBottom,
  });

  static const size=45.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: size+2,
          height: size+1,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: Colors.black.withOpacity(0.1),
          ),
        ),
        Positioned(
          left: 1.0,
          bottom: isAlignedBottom? 0.0 : 1.0,
          top: isAlignedBottom? 1.0 : 0.0,
          child: TextButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius,
              ),
              minimumSize: const Size(size, size),
              padding: EdgeInsets.zero,
              elevation: 0.0,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

