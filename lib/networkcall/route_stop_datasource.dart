import 'dart:math';

import '../models/route_stop_model.dart';
import '../utils/app_constants.dart' show AppConstants;
import 'api_client.dart';

abstract class RouteStopDataSource {
  Future<List<RouteStop>> getRouteStops();
  Future<bool> bookRide(String stopId);
}


class RemoteRouteStopDataSource implements RouteStopDataSource {
  final ApiClient apiClient;

  RemoteRouteStopDataSource({required this.apiClient});

  @override
  Future<List<RouteStop>> getRouteStops() async {
    final response = await apiClient.getRouteStops();
    if (response.statusCode == 200) {
      return [
        RouteStop(
          id: '1',
          name: 'Main Street Station',
          time: '08:30 AM',
          status: 'On Time',
          isActive: true,
        ),
        RouteStop(
          id: '2',
          name: 'Central Park',
          time: '08:45 AM',
          status: 'On Time',
          isActive: true,
        ),
        RouteStop(
          id: '3',
          name: 'Downtown Plaza',
          time: '09:00 AM',
          status: 'Delayed by 5 min',
          isActive: true,
        ),
        RouteStop(
          id: '4',
          name: 'University Campus',
          time: '09:20 AM',
          status: 'On Time',
          isActive: true,
        ),
        RouteStop(
          id: '5',
          name: 'Riverside Terminal',
          time: '09:40 AM',
          status: 'Arrived',
          isActive: false,
        ),
      ];
    } else {
      throw Exception('Failed to load route stops');
    }
  }

  @override
  Future<bool> bookRide(String stopId) async {
    final response = await apiClient.bookRide(stopId);
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 400) {
      throw Exception('Booking failed: Invalid stop ID');
    } else if (response.statusCode == 500) {
      throw Exception('Server error');
    } else {
      throw Exception('Unexpected error');
    }
  }
}
