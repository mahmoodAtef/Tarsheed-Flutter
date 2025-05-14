import 'package:dartz/dartz.dart';
import 'package:tarsheed/src/modules/automation/data/models/automation.dart';
import 'package:tarsheed/src/modules/automation/data/services/automation_services.dart';

class AutomationRepository {
  final BaseAutomationServices baseAutomationServices;

  AutomationRepository(this.baseAutomationServices);

  Future<Either<Exception, List<Automation>>> getAutomations() {
    return baseAutomationServices.getAutomations();
  }

  Future<Either<Exception, Automation>> addAutomation(Automation automation) {
    return baseAutomationServices.addAutomation(automation);
  }

  Future<Either<Exception, Automation>> updateAutomation(
      Automation automation) {
    return baseAutomationServices.updateAutomation(automation);
  }

  Future<Either<Exception, Unit>> deleteAutomation(String id) {
    return baseAutomationServices.deleteAutomation(id);
  }

  Future<Either<Exception, Unit>> changeAutomationStatus(String id) {
    return baseAutomationServices.changeAutomationStatus(id);
  }
}
