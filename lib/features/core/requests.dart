import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:burrito_driver_app/features/status/data/entities/server_response.dart';
import 'package:burrito_driver_app/features/status/data/entities/service_status.dart';

const kBurritoName = 'burrito-001';

final dio = Dio(
  BaseOptions(
    // baseUrl: 'https://api.contigosanmarcos.com',
    baseUrl: 'http://192.168.1.92:6969',
    connectTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'burrito_prod_K8ZVf5g3XS6x2TcjdyDztkbvh4CQHrF7',
      'x-bus-id': kBurritoName,
    },
  ),
);

Future<ServerResponse> sendBusStatus({
  required double latitude,
  required double longitude,
  required BusServiceStatus status,
}) async {
  try {
    final startTime = DateTime.now();

    await dio.post('/driver', data: {
      'lt': latitude,
      'lg': longitude,
      'sts': status.asInt,
    });

    return ServerResponse(
      ms: DateTime.now().difference(startTime).inMilliseconds,
    );
  } catch (e, st) {
    debugPrint('Error en POST request: $e $st');
    rethrow;
  }
}

Future<void> sendCrashReport({
  required String error,
  required StackTrace stackTrace,
}) async {
  try {
    await dio.post(
      '/analytics/crash_reports',
      data: {
        'error': error.toString(),
        'stacktrace': stackTrace.toString(),
      },
    );
  } catch (e, st) {
    debugPrint('Error en POST request: $e $st');
    rethrow;
  }
}
