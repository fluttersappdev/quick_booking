import 'package:quick_booking/networkcall/route_stop_datasource.dart';

import '../models/route_stop_model.dart';

class RouteStopRepository {
  final RouteStopDataSource dataSource;

  RouteStopRepository(this.dataSource);

  Future<List<RouteStop>> getRouteStops() async {
    return await dataSource.getRouteStops();
  }

  Future<bool> bookRide(String stopId) async {
    return await dataSource.bookRide(stopId);
  }
}