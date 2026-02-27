import 'package:dio/dio.dart';
import 'package:kontrol_app/config/constants/environments.dart';
import 'package:kontrol_app/config/dio/dio_client.dart';

class CatalogsService {
  final Dio _dio = DioClient.instance;


  Future<List<Map<String, dynamic>>> getDriversVehicles() async {
    try {
      print(
        '📤 Enviando solicitud a: ${Environments.baseUrl}${Environments.getAllDrivers}',
      );

      // Enviar solicitud
      final response = await _dio.get(Environments.getAllDrivers);

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
}
