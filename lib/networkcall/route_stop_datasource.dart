import 'dart:math';

import '../models/route_stop_model.dart';
import '../utils/app_constants.dart' show AppConstants;

abstract class RouteStopDataSource {
  Future<List<RouteStop>> getRouteStops();
  Future<bool> bookRide(String stopId);
}

class MockRouteStopDataSource implements RouteStopDataSource {
  @override
  Future<List<RouteStop>> getRouteStops() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));

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
  }

  @override
  Future<bool> bookRide(String stopId) async {
    await Future.delayed(const Duration(seconds:1));

    final random = Random().nextDouble(); // Generates number between 0.0 and 1.0
    if (random < 0.5) {
      throw Exception('Booking failed. Please try again.');
    }

    return true;
  }
}