import 'package:dartz/dartz.dart';
import 'package:tarsheed/src/core/apis/dio_helper.dart';
import 'package:tarsheed/src/core/apis/end_points.dart';
import 'package:tarsheed/src/modules/dashboard/automation/data/models/automation.dart';

abstract class BaseAutomationServices {
  Future<Either<Exception, List<Automation>>> getAutomations();
  Future<Either<Exception, Automation>> addAutomation(Automation automation);
  Future<Either<Exception, Automation>> updateAutomation(Automation automation);
  Future<Either<Exception, Unit>> deleteAutomation(String id);
  Future<Either<Exception, Unit>> changeAutomationStatus(String id);
}

class AutomationRemoteServices implements BaseAutomationServices {
  @override
  Future<Either<Exception, Automation>> addAutomation(
      Automation automation) async {
    try {
      var response = await DioHelper.postData(
        path: EndPoints.addAutomation,
        data: automation.toJson(),
      );
      String id = response.data['id'];
      return Right(automation.copyWith(id: id));
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, Unit>> changeAutomationStatus(String id) async {
    try {
      await DioHelper.postData(
        path: EndPoints.changeAutomationStatus + id,
        query: {"id": id},
      );
      return Right(unit);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, Unit>> deleteAutomation(String id) async {
    try {
      await DioHelper.deleteData(
        path: EndPoints.deleteAutomation + id,
      );
      return Right(
        unit,
      );
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, List<Automation>>> getAutomations() async {
    try {
      var response = await DioHelper.getData(
        path: EndPoints.getAutomations,
      );
      List<Automation> automations = (response.data["automations"] as List)
          .map((e) => Automation.fromJson(e))
          .toList();
      return Right(
        automations,
      );
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, Automation>> updateAutomation(
      Automation automation) async {
    try {
      var response = await DioHelper.putData(
        path: EndPoints.updateAutomation,
        data: automation.toJson(),
      );
      return Right(automation);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
