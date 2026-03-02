import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kontrol_app/presentation/providers/technical-kontrol/technical_service_provider.dart';
import 'package:kontrol_app/service/technical_repository_service.dart';


//Este repositorio es inmutable ya que se esta usando Provider
//Su objetivo es proporcionar a todos los demas providers la informacion necesaria para consultar el datasourceimpl
final technicalRepositoryProvider = Provider((ref) {
  final service = ref.watch(technicalServiceProvider);
  final movementService = ref.watch(movementServiceProvider);
  return TechnicalRepository(service, movementService);
});