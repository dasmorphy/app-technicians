/// Constantes de configuración para la API
class ApiConstants {
  // Base URL de la API - Cambiar esta URL según tu servidor
  // static const String baseUrl = 'http://your-api.com/api';
  
  // Endpoints
  static const String movementsEndpoint = '/movements';
  static const String uploadPhotosEndpoint = '/movements/upload-photos';
  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}
