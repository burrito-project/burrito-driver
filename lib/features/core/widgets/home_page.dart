import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:burrito_driver_app/features/core/requests.dart';
import 'package:burrito_driver_app/features/core/utils/permissions.dart';
import 'package:burrito_driver_app/features/status/change_status_button.dart';
import 'package:burrito_driver_app/features/status/widgets/status_badge.dart';
import 'package:burrito_driver_app/features/status/data/entities/service_status.dart';
import 'package:burrito_driver_app/features/status/data/entities/server_response.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  BusServiceStatus serviceStatus = BusServiceStatus.off;
  Stream<ServerResponse?> responsesStream = const Stream.empty();

  @override
  void dispose() {
    responsesStream.drain();
    super.dispose();
  }

  void startJourney() async {
    final result = await manageNeededPermissions(context);
    if (!result) return;

    setState(() {
      serviceStatus = BusServiceStatus.working;
    });

    responsesStream = Geolocator.getPositionStream(
      locationSettings: AndroidSettings(
        intervalDuration: const Duration(seconds: 1),
        accuracy: LocationAccuracy.high,
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationText: 'Enviando ubicación actual de la ruta del burrito',
          notificationTitle: 'Burrito funcionando',
          enableWakeLock: true,
          notificationIcon: AndroidResource(name: 'mipmap/ic_launcher'),
          notificationChannelName: 'Tracking en segundo plano',
        ),
      ),
    ).asyncMap<ServerResponse?>((pos) async {
      if (serviceStatus.shoudlNotMakeRequests) return null;

      if (kDebugMode) {
        print('\n');
        print(pos.altitude);
        print(pos.latitude);
        print(pos.longitude);
        print(pos.speed);
      }

      try {
        final response = await sendBusStatus(
          latitude: pos.latitude,
          longitude: pos.longitude,
          status: serviceStatus,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Solicitud enviada correctamente'),
              backgroundColor: Colors.green,
              duration: Duration(milliseconds: 500),
            ),
          );
        }
        return ServerResponse(ms: response.ms);
      } catch (e, st) {
        debugPrint('Request error: $e $st');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error en la solicitud: $e'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
        rethrow;
      }
    });
  }

  void stopRequests() {
    responsesStream = const Stream.empty();

    setState(() {
      serviceStatus = BusServiceStatus.off;
    });
  }

  void onStatusChanged(BusServiceStatus newStatus) {
    setState(() {
      serviceStatus = newStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/img/burrito_stationary.png',
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 16, 16, 16),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    BurritoStatusBadge(status: serviceStatus),
                    const SizedBox(height: 8),
                    const Text(
                      'Burrito conductor',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    StreamBuilder(
                      stream: responsesStream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const SizedBox.shrink();
                        }
                        final response = snapshot.data as ServerResponse;

                        return Text(
                          'Tiempo transcurrido: ${response.ms} ms',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 14),
                  ],
                ),
              ),
            ),
            const Expanded(child: SizedBox.expand()),
            Container(
              color: const Color.fromARGB(255, 16, 16, 16),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 16,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 72,
                  child: serviceStatus.isStarted
                      ? ChangeStatusButton(
                          onStop: stopRequests,
                          currentStatus: serviceStatus,
                          onStatusChanged: onStatusChanged,
                        )
                      : ElevatedButton(
                          onPressed: startJourney,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xFF262F31),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Iniciar Recorrido',
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
