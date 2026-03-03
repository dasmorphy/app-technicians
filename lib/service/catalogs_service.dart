import 'package:dio/dio.dart';
import 'package:kontrol_app/config/constants/environments.dart';
import 'package:kontrol_app/presentation/models/technical_control.dart';

class CatalogsService {
  final Dio dio;

  CatalogsService(this.dio);

  Future<List<Map<String, dynamic>>> getDriversVehicles() async {
    try {
      print(
        '📤 Enviando solicitud a: ${Environments.baseUrl}${Environments.getAllDrivers}',
      );

      // Enviar solicitud
      final response = await dio.get(Environments.getAllDrivers);

      print('✅ Respuesta recibida: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      } else {
        throw Exception(
          'Error en la respuesta del servidor: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      print('❌ Error de Dio: ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ Error: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getLicensesVehicles() async {
    try {
      print(
        '📤 Enviando solicitud a: ${Environments.baseUrl}${Environments.getAllLicenses}',
      );

      // Enviar solicitud
      final response = await dio.get(Environments.getAllLicenses);

      print('✅ Respuesta recibida: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      } else {
        throw Exception(
          'Error en la respuesta del servidor: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      print('❌ Error de Dio: ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ Error: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getLevelGasoline() async {
    try {
      print(
        '📤 Enviando solicitud a: ${Environments.baseUrl}${Environments.getAllLevelGasoline}',
      );

      // Enviar solicitud
      final response = await dio.get(Environments.getAllLevelGasoline);

      print('✅ Respuesta recibida: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      } else {
        throw Exception(
          'Error en la respuesta del servidor: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      print('❌ Error de Dio: ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ Error: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getAllReasons() async {
    try {
      print(
        '📤 Enviando solicitud a: ${Environments.baseUrl}${Environments.getAllReasons}',
      );

      // Enviar solicitud
      final response = await dio.get(Environments.getAllReasons);

      print('✅ Respuesta recibida: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      } else {
        throw Exception(
          'Error en la respuesta del servidor: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      print('❌ Error de Dio: ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ Error: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getCopilot() async {
    try {
      print(
        '📤 Enviando solicitud a: ${Environments.baseUrl}${Environments.getAllCopilots}',
      );

      // Enviar solicitud
      final response = await dio.get(Environments.getAllCopilots);

      print('✅ Respuesta recibida: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      } else {
        throw Exception(
          'Error en la respuesta del servidor: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      print('❌ Error de Dio: ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ Error: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getProjects() async {
    try {
      print(
        '📤 Enviando solicitud a: ${Environments.baseUrl}${Environments.getAllProjects}',
      );

      // Enviar solicitud
      final response = await dio.get(Environments.getAllProjects);

      print('✅ Respuesta recibida: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      } else {
        throw Exception(
          'Error en la respuesta del servidor: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      print('❌ Error de Dio: ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ Error: $e');
      rethrow;
    }
  }

  Future<List<TechnicalControl>> getAllTechnical() async {
    try {
      print(
        '📤 Enviando solicitud a: ${Environments.baseUrl}/rest/technical-control-api/v1.0/get/all-technical-control',
      );

      // Enviar solicitud
      final response = await dio.get('/rest/technical-control-api/v1.0/get/all-technical-control');

      print('✅ Respuesta recibida: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List techControlsJson = response.data['data'];
        print(techControlsJson);
        return techControlsJson.map((json) => TechnicalControl.fromJson(json)).toList();
      } else {
        throw Exception(
          'Error en la respuesta del servidor: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      print('❌ Error de Dio: ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ Error: $e');
      rethrow;
    }
  }
}
