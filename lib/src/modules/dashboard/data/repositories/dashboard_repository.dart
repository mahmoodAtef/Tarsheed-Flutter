import 'package:dartz/dartz.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/report.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/room.dart';

class DashboardRepository {
  /// add room , update room , delete room , add device , update device , delete device

  // report
  Future<Either<Exception, Report>> getUsageReport() {
    // TODO: implement getUsageReport
    throw UnimplementedError();
  }

  Future<Either<Exception, Room>> addRoom(
      {required String name, required String description}) {
    // TODO: implement addRoom
    throw UnimplementedError();
  }

  Future<Either<Exception, Unit>> updateRoom(
      {required String name, required String description}) {
    // TODO: implement updateRoom
    throw UnimplementedError();
  }

  Future<Either<Exception, Unit>> deleteRoom(String roomId) {
    // TODO: implement deleteRoom
    throw UnimplementedError();
  }
}
