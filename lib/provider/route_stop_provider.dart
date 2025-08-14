import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:fpdart/fpdart.dart';

import '../models/route_stop_model.dart';
import '../networkcall/api_client.dart';
import '../networkcall/failures.dart';
import '../networkcall/route_stop_datasource.dart';
import '../networkcall/route_stop_repository.dart';


final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(client: http.Client(),useMocks: true);
});


final routeStopDataSourceProvider = Provider<RouteStopDataSource>((ref) {
  return RemoteRouteStopDataSource(apiClient: ref.read(apiClientProvider));
});

final routeStopRepositoryProvider = Provider<RouteStopRepository>((ref) {
  return RouteStopRepository(ref.read(routeStopDataSourceProvider));
});

final routeStopsProvider = FutureProvider.autoDispose<Either<Failure, List<RouteStop>>>((ref) async {
  final repository = ref.read(routeStopRepositoryProvider);
  return await repository.getRouteStops();
});

class BookingNotifier extends StateNotifier<BookingState> {
  final RouteStopRepository _repository;

  BookingNotifier(this._repository) : super(BookingInitial());

  Future<void> bookRide(String stopId) async {
    state = BookingLoading(stopId);
    final result = await _repository.bookRide(stopId);

    state = result.fold(
          (failure) => BookingError(message: failure.message),
          (success) => success
          ? BookingSuccess(stopId: stopId)
          : BookingError(message: 'Booking failed'),
    );
  }

  void reset() => state = BookingInitial();
}

final bookingProvider = StateNotifierProvider.autoDispose<BookingNotifier, BookingState>((ref) {
  return BookingNotifier(ref.read(routeStopRepositoryProvider));
});

sealed class BookingState {
  const BookingState();
}

class BookingInitial extends BookingState {
  const BookingInitial();
}


class BookingLoading extends BookingState {
  final String stopId;
  const BookingLoading(this.stopId);
}


class BookingSuccess extends BookingState {
  final String stopId;
  const BookingSuccess({required this.stopId});
}

class BookingError extends BookingState {
  final String message;
  const BookingError({required this.message});
}