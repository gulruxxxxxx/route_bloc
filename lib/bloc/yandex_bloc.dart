import 'package:yandex_mapkit/yandex_mapkit.dart';

class LocationBloc {
  Stream<Point> get userLocation async* {
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      yield Point(
          latitude: 41.2858305 + (DateTime.now().second * 0.0001),
          longitude: 69.2035464);
    }
  }
}