import 'package:dio/dio.dart';
import 'package:kontrol_app/config/constants/api_constants.dart';
import 'package:kontrol_app/config/constants/environments.dart';
import 'package:uuid/uuid.dart';

/// Cliente HTTP configurado con Dio
class DioClient {
  static final Dio _dio = Dio();
  
  static Dio get instance {
    _dio.options.baseUrl = Environments.baseUrl;
    _dio.options.connectTimeout = ApiConstants.connectTimeout;
    _dio.options.receiveTimeout = ApiConstants.receiveTimeout;
    _dio.options.sendTimeout = ApiConstants.sendTimeout;
    
    // Headers por defecto
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    // Interceptor para logging (solo en debug)
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // 👇 SOLO para GET
          if (options.method == 'GET') {
            options.headers.addAll({
              'externalTransactionId': Uuid().v4(),
              'channel': 'TECHNICAL_MOVIL',
            });
          }

          print('📤 REQUEST: ${options.method} ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('✅ RESPONSE: ${response.statusCode} ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (error, handler) {
          print('❌ ERROR: ${error.message}');
          return handler.next(error);
        },
      ),
    );
    
    return _dio;
  }
}
