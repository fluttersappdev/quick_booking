import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/route_stop_model.dart' show RouteStop;
import '../networkcall/route_stop_datasource.dart' show MockRouteStopDataSource, RouteStopDataSource;
import '../networkcall/route_stop_repository.dart' show RouteStopRepository;

final routeStopDataSourceProvider = Provider<RouteStopDataSource>((ref) {
  return MockRouteStopDataSource();
});

final routeStopRepositoryProvider = Provider<RouteStopRepository>((ref) {
  return RouteStopRepository(ref.read(routeStopDataSourceProvider));
});

final routeStopsProvider = FutureProvider<List<RouteStop>>((ref) async {
  return await ref.read(routeStopRepositoryProvider).getRouteStops();
});

final bookingProvider = StateNotifierProvider<BookingNotifier, BookingState>((ref) {
  return BookingNotifier(ref.read(routeStopRepositoryProvider));
});

class BookingNotifier extends StateNotifier<BookingState> {
  final RouteStopRepository _repository;

  BookingNotifier(this._repository) : super(BookingInitial());

  Future<void> bookRide(String stopId) async {
    state = BookingLoading();
    try {
      final success = await _repository.bookRide(stopId);
      if (success) {
        state = BookingSuccess(stopId: stopId);
      } else {
        state = BookingError(message: 'Booking failed. Please try again.');
      }
    } catch (e) {
      state = BookingError(message: e.toString());
    }
  }

  void reset() {
    state = BookingInitial();
  }
}

abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingSuccess extends BookingState {
  final String stopId;

  BookingSuccess({required this.stopId});
}

class BookingError extends BookingState {
  final String message;

  BookingError({required this.message});
}