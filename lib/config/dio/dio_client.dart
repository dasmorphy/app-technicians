import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kontrol_app/config/constants/api_constants.dart';
import 'package:kontrol_app/config/constants/environments.dart';
import 'package:uuid/uuid.dart';

/// Cliente HTTP configurado con Dio
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  dio.options.baseUrl = Environments.baseUrl;
  dio.options.connectTimeout = ApiConstants.connectTimeout;
  dio.options.receiveTimeout = ApiConstants.receiveTimeout;
  dio.options.sendTimeout = ApiConstants.sendTimeout;

  dio.options.headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        if (options.method == 'GET') {
          options.headers.addAll({
            'externalTransactionId': const Uuid().v4(),
            'channel': 'TECHNICAL_MOVIL',
          });
        }

        print('📤 ${options.method} ${options.path}');
        handler.next(options);
      },
      onResponse: (response, handler) {
        print('✅ ${response.statusCode} ${response.requestOptions.path}');
        handler.next(response);
      },
      onError: (error, handler) {
        print('❌ ${error.message}');
        handler.next(error);
      },
    ),
  );

  return dio;
});
