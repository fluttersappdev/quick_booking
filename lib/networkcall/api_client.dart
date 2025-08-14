import 'package:http/http.dart' as http;

class ApiClient {
  final http.Client client;
  final String baseUrl;
  final bool useMocks;

  ApiClient({
    required this.client,
    this.baseUrl = 'https://api.example.com',
    this.useMocks = false,
  });

  Future<http.Response> bookRide(String stopId) async {
    if (useMocks) {
      await Future.delayed(const Duration(seconds: 1));
      if (DateTime.now().millisecond % 2 == 0) {
        return http.Response('{"success": true}', 200);
      } else {
        return http.Response('{"error": "Booking failed"}', 400);
      }
    }

    return client.post(
      Uri.parse('$baseUrl/bookings'),
      body: {'stop_id': stopId},
    );
  }

  Future<http.Response> getRouteStops() async {
    if (useMocks) {
      await Future.delayed(const Duration(milliseconds: 800));
      return http.Response('''
        [
          {"id": "1", "name": "Main Street", "time": "08:30 AM", "status": "On Time", "isActive": true},
          {"id": "2", "name": "Central Park", "time": "08:45 AM", "status": "On Time", "isActive": true},
          {"id": "3", "name": "Downtown", "time": "09:00 AM", "status": "Delayed by 5 min", "isActive": true},
          {"id": "4", "name": "University", "time": "09:20 AM", "status": "On Time", "isActive": true},
          {"id": "5", "name": "Riverside", "time": "09:40 AM", "status": "Arrived", "isActive": false}
        ]
      ''', 200);
    }

    return client.get(Uri.parse('$baseUrl/route-stops'));
  }
}