import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:burrito_driver_app/features/status/data/entities/server_response.dart';
import 'package:burrito_driver_app/features/status/data/entities/service_status.dart';

final dio = Dio(
  BaseOptions(
    // baseUrl: 'http://elenadb.live:6969',
    baseUrl: 'https://api.contigosanmarcos.com',
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
      '/driver',
      data: {
        'lt': latitude,
        'lg': longitude,
        'sts': status.asInt,
      },
      options: Options(
        headers: {
          'Authorization': 'te quiero burrito',
          'x-bus-id': 'burrito-001',
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
