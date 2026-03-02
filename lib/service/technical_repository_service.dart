import 'package:kontrol_app/presentation/models/technical_request.dart';
import 'package:kontrol_app/service/catalogs_service.dart';
import 'package:kontrol_app/service/movement_service.dart';

class TechnicalRepository {
  final CatalogsService service;
  final MovementService servicePost;

  TechnicalRepository(this.service, this.servicePost);


  Future<List<dynamic>> getProjects() {
    return service.getProjects();
  }

  Future<List<dynamic>> getAllTechnical() {
    return service.getAllTechnical();
  }

  Future<List<dynamic>> getLicensesVehicles() {
    return service.getLicensesVehicles();
  }

  Future<List<dynamic>> getLevelGasoline() {
    return service.getLevelGasoline();
  }


  Future<List<dynamic>> getCopilot() {
    return service.getCopilot();
  }

  Future<List<dynamic>> getAllReasons() {
    return service.getAllReasons();
  }

  Future<List<dynamic>> getDriversVehicles() {
    return service.getDriversVehicles();
  }

  Future<Map<String, dynamic>?> submitMovement(TechnicalRequest request) async {
    return servicePost.submitMovement(request);
  }
}