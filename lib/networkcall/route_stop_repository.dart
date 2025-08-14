import 'package:quick_booking/networkcall/route_stop_datasource.dart';
import '../models/route_stop_model.dart';
import 'failures.dart';
import 'package:fpdart/fpdart.dart';

class RouteStopRepository {
  final RouteStopDataSource dataSource;

  RouteStopRepository(this.dataSource);

  Future<Either<Failure, List<RouteStop>>> getRouteStops() async {
    try {
      final stops = await dataSource.getRouteStops();
      return Right(stops);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, bool>> bookRide(String stopId) async {
    try {
      final success = await dataSource.bookRide(stopId);
      return Right(success);
    } catch (e) {
      return Left(BookingFailure(e.toString()));
    }
  }
}