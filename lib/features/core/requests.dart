import 'package:battery_plus/battery_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:burrito_driver_app/features/status/data/entities/server_response.dart';
import 'package:burrito_driver_app/features/status/data/entities/service_status.dart';

const kBurritoName = 'burrito-001';

final dio = Dio(
  BaseOptions(
    baseUrl: 'https://api.burritosanmarcos.com',
    // baseUrl: 'http://192.168.1.92:6969',
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

var battery = Battery();
int batteryLevel = 0;

int batteryCount = 0;

Future<ServerResponse> sendBusStatus({
  required double latitude,
  required double longitude,
  required BusServiceStatus status,
}) async {
  try {
    final startTime = DateTime.now();
    batteryCount++;

    if (batteryLevel == 0 || batteryCount % 20 == 0) {
      batteryLevel = await battery.batteryLevel;
    }

    await dio.post('/driver', data: {
      'lt': latitude,
      'lg': longitude,
      'sts': status.asInt,
      'bat': batteryLevel,
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
