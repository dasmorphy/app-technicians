import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environments {
  static String baseUrl = dotenv.env['ZENTINEL_BASE_URL'] ?? 'No hay api key';
  static String postTechnicalControl = dotenv.env['API_POST_TECHNICAL_CONTROL'] ?? 'No hay api key';
  static String getAllDrivers = dotenv.env['API_GET_ALL_DRIVERS'] ?? 'No hay api key';
  static String getAllLicenses = dotenv.env['API_GET_ALL_LICENSES'] ?? 'No hay api key';
  static String getAllLevelGasoline = dotenv.env['API_GET_ALL_GASOLINE'] ?? 'No hay api key';
  static String getAllReasons = dotenv.env['API_GET_ALL_REASONS'] ?? 'No hay api key';
  static String getAllCopilots = dotenv.env['API_GET_ALL_COPILOTS'] ?? 'No hay api key';

}