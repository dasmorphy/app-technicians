import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:kontrol_app/config/constants/api_constants.dart';
import 'package:kontrol_app/config/constants/environments.dart';
import 'package:kontrol_app/config/dio/dio_client.dart';
import 'package:uuid/uuid.dart';

/// Modelo para la solicitud de movimiento
class MovementRequest {
  final DateTime movementDateTime;
  final List<String> motives;
  final List<String> projects;
  final String? projectOther;
  final String plate;
  final String initialKm;
  final String fuel;
  final String driver;
  final List<String> passengers;
  final String origin;
  final String destination;
  final String? observations;
  final List<File> photos;
  final String channel;
  final String externalTransactionId;

  MovementRequest({
    required this.movementDateTime,
    required this.motives,
    required this.projects,
    this.projectOther,
    required this.plate,
    required this.initialKm,
    required this.fuel,
    required this.driver,
    required this.passengers,
    required this.origin,
    required this.destination,
    this.observations,
    this.channel = 'TECHNICAL MOVIL',
    required this.photos,
    this.externalTransactionId = ''
  });

  /// Convertir a JSON para enviar al servidor
  Map<String, dynamic> toJson() {
    return {
      'movementDateTime': movementDateTime.toIso8601String(),
      'motives': motives,
      'projects': projects,
      'projectOther': projectOther,
      'plate': plate,
      'initialKm': initialKm,
      'fuel': fuel,
      'driver': driver,
      'passengers': passengers,
      'origin': origin,
      'destination': destination,
      'observations': observations,
      'photosCount': photos.length,
      'channel': channel,
      'external_transaction_id': externalTransactionId,
    };
  }
}

/// Servicio para manejar las solicitudes de movimiento
class MovementService {
  final Dio _dio = DioClient.instance;

  /// Enviar datos del movimiento con fotos al servidor
  Future<Map<String, dynamic>?> submitMovement(MovementRequest request) async {
    try {
      print('📦 Preparando envío de movimiento...');
      final requestWithUuid = MovementRequest(
        movementDateTime: request.movementDateTime,
        motives: request.motives,
        projects: request.projects,
        projectOther: request.projectOther,
        plate: request.plate,
        initialKm: request.initialKm,
        fuel: request.fuel,
        driver: request.driver,
        passengers: request.passengers,
        origin: request.origin,
        destination: request.destination,
        observations: request.observations,
        photos: request.photos,
        externalTransactionId: const Uuid().v4(),
      );

      final technicalJson = jsonEncode(requestWithUuid.toJson());
      final technicalBytes = utf8.encode(technicalJson);

      final formData = FormData();

      // Agregar logbook_entry
      formData.files.add(
        MapEntry(
          'technical_data',
          MultipartFile.fromBytes(
            technicalBytes,
            filename: 'technical_data.json',
            contentType: MediaType('application', 'json'),
          ),
        ),
      );

      // Agregar fotos si existen
      if (request.photos.isNotEmpty) {
        for (int i = 0; i < request.photos.length; i++) {
          final file = request.photos[i];
          formData.files.add(
            MapEntry(
              'initial_images',
              await MultipartFile.fromFile(
                file.path,
                filename: 'photo_$i.webp',
              ),
            ),
          );
        }
      }

      print('📤 Enviando solicitud a: ${Environments.baseUrl}${Environments.postTechnicalControl}');

      // Enviar solicitud
      final response = await _dio.post(
        Environments.postTechnicalControl,
        data: formData,
      );

      print('✅ Respuesta recibida: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Error en la respuesta del servidor: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ Error de Dio: ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ Error: $e');
      rethrow;
    }
  }

  /// Enviar solo los datos del movimiento sin fotos (alternativa simplificada)
  Future<Map<String, dynamic>?> submitMovementJson(MovementRequest request) async {
    try {
      print('📦 Preparando envío de movimiento (JSON)...');
      print('📤 Enviando solicitud a: ${Environments.baseUrl}${ApiConstants.movementsEndpoint}');

      final response = await _dio.post(
        ApiConstants.movementsEndpoint,
        data: request.toJson(),
      );

      print('✅ Respuesta recibida: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Error en la respuesta del servidor: ${response.statusCode}');
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
