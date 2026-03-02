import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kontrol_app/config/dio/dio_client.dart';
import 'package:kontrol_app/service/catalogs_service.dart';
import 'package:kontrol_app/service/movement_service.dart';

final technicalServiceProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return CatalogsService(dio);
});

final movementServiceProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return MovementService(dio);
});