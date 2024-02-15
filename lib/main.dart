import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'dart:async';

import 'bloc/yandex_bloc.dart';


void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RouteDrawPage(),
    );
  }
}

class RouteDrawPage extends StatefulWidget {
  const RouteDrawPage({Key? key}) : super(key: key);

  @override
  State<RouteDrawPage> createState() => _RouteDrawPageState();
}

class _RouteDrawPageState extends State<RouteDrawPage> {
  Point destination = const Point(latitude: 41.341267, longitude: 69.163425);
  PolylineMapObject route = PolylineMapObject(
    mapId: MapObjectId('route'),
    polyline: Polyline(points: []),
  );
  late LocationBloc _locationBloc;
  late StreamSubscription<Point> _locationSubscription;
  Point _userLocation = const Point(latitude: 41.2858305, longitude: 69.2035464);

  YandexMapController? mapController;

  @override
  void initState() {
    super.initState();
    _locationBloc = LocationBloc();
    _locationSubscription = _locationBloc.userLocation.listen((Point location) {
      setState(() {
        _userLocation = location;
      });
    });
  }

  @override
  void dispose() {
    _locationSubscription.cancel();
    super.dispose();
  }

  Future<void> getRoute() async {
    final routeRequest = await YandexDriving.requestRoutes(
      points: [
        RequestPoint(
          point: _userLocation,
          requestPointType: RequestPointType.wayPoint,
        ),
        RequestPoint(
          point: destination,
          requestPointType: RequestPointType.wayPoint,
        ),
      ],
      drivingOptions: DrivingOptions(
        initialAzimuth: 0,
        routesCount: 5,
        avoidTolls: true,
      ),
    );
    final result = await routeRequest.result;
    if (result.routes != null && result.routes!.isNotEmpty) {
      setState(() {
        route = PolylineMapObject(
          mapId: MapObjectId('route'),
          strokeColor: Colors.red,
          strokeWidth: 3,
          polyline: Polyline(points: result.routes!.first.geometry),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: YandexMap(
        mapObjects: [
          CircleMapObject(
            mapId: MapObjectId('source'),
            fillColor: Colors.blue.withOpacity(.3),
            strokeColor: Colors.blue,
            circle: Circle(center: _userLocation, radius: 20),
          ),
          PlacemarkMapObject(
            mapId: MapObjectId('destination'),
            point: destination,
            icon: PlacemarkIcon.single(
              PlacemarkIconStyle(
                image: BitmapDescriptor.fromAssetImage(
                  'assets/images/profille.png',
                ),
                scale: 0.5,
              ),
            ),
          ),
          route,
        ],
        onCameraPositionChanged: (cameraPosition, reason, finished) {},
        onMapCreated: (controller) async {
          mapController = controller;
          await controller.moveCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: _userLocation, zoom: 12),
            ),
          );
          await getRoute();
        },
      ),
    );
  }
}
