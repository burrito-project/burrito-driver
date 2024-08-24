import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:burrito_driver_app/features/status/data/entities/server_response.dart';
import 'package:burrito_driver_app/features/status/data/entities/service_status.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: 'api.contigosanmarcos.com/status',
    connectTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ),
);

Future<ServerResponse> sendBusStatus({
  required double latitude,
  required double longitude,
  required BusServiceStatus status,
}) async {
  try {
    final startTime = DateTime.now();

    await dio.post(
      '/status',
      data: {
        'lt': latitude,
        'lg': longitude,
        'sts': status.asInt,
      },
      options: Options(
        headers: {
          'Authorization': 'te quiero burrito',
        },
      ),
    );

    return ServerResponse(
      ms: DateTime.now().difference(startTime).inMilliseconds,
    );
  } catch (e, st) {
    debugPrint('Error en POST request: $e $st');
    rethrow;
  }
}
