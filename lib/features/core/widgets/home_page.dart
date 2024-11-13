import 'dart:async';
import 'package:burrito_driver_app/features/core/utils/battery.dart';
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

  static Stream<Position>? positionStream;
  static StreamSubscription<ServerResponse?>? positionStreamSubscription;

  late Stream<int> batteryStream;

  HomePageState() {
    batteryStream = () async* {
      while (true) {
        yield await battery.batteryLevel;
        await Future.delayed(const Duration(seconds: 10));
      }
    }();
  }

  @override
  void dispose() {
    responsesStream.drain();
    responsesStream = const Stream.empty();
    positionStreamSubscription?.cancel();
    super.dispose();
  }

  void startJourney() async {
    final result = await manageNeededPermissions(context);
    if (!result) return;

    setState(() {
      serviceStatus = BusServiceStatus.working;
    });

    positionStream = Geolocator.getPositionStream(
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
    );

    responsesStream = positionStream!.asyncMap<ServerResponse?>((pos) async {
      if (kDebugMode) {
        print('\n');
        print(pos.altitude);
        print(pos.latitude);
        print(pos.longitude);
        print(pos.speed);
      }
      if (serviceStatus.shoudlNotMakeRequests) return null;

      try {
        final response = await sendBusStatus(
          latitude: pos.latitude,
          longitude: pos.longitude,
          status: serviceStatus,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Posición actualizada'),
              backgroundColor: Colors.green,
              duration: Duration(milliseconds: 500),
            ),
          );
        }

        return ServerResponse(ms: response.ms);
      } catch (e, st) {
        debugPrint('Request error: $e $st');

        try {
          sendCrashReport(error: e.toString(), stackTrace: st);
        } catch (e, st) {
          debugPrint('Unable to send crash reports: $e $st');
        }

        if (mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
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

    positionStreamSubscription = responsesStream.listen((_) {});
  }

  void stopRequests() {
    positionStreamSubscription?.cancel();
    responsesStream.drain();
    responsesStream = const Stream.empty();

    ScaffoldMessenger.of(context).clearSnackBars();

    try {
      Future.delayed(const Duration(seconds: 1), () {
        sendBusStatus(
          latitude: 0,
          longitude: 0,
          status: BusServiceStatus.off,
        );
      });
    } catch (_) {}

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
        // Image.asset(
        //   'assets/img/burrito_stationary.png',
        // ),
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
                        fontSize: 28,
                        color: Colors.white,
                      ),
                    ),
                    // StreamBuilder(
                    //   stream: responsesStream,
                    //   builder: (context, snapshot) {
                    //     if (!serviceStatus.isStarted) {
                    //       return const SizedBox.shrink();
                    //     }
                    //     if (!snapshot.hasData) {
                    //       return const SizedBox.shrink();
                    //     }
                    //     final response = snapshot.data as ServerResponse;

                    //     return Text(
                    //       'Tiempo transcurrido: ${response.ms} ms',
                    //       style: const TextStyle(
                    //         color: Colors.white,
                    //         fontSize: 16,
                    //       ),
                    //     );
                    //   },
                    // ),
                    const SizedBox(height: 14),
                  ],
                ),
              ),
            ),
            // Background
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamBuilder(
                    stream: batteryStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              getBatteryIcon(snapshot.data),
                              size: 54,
                              color: Colors.grey,
                            ),
                            Text(
                              '${snapshot.data}%',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'monospace',
                                fontSize: 54,
                              ),
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  Text(
                    serviceStatus.isOff ? 'Burrito apagado' : 'Burrito en ruta',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 32,
                    ),
                  ),
                ],
              ),
            ),
            // Footer
            Container(
              color: const Color.fromARGB(255, 16, 16, 16),
              child: Padding(
                padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
                child: Column(
                  children: [
                    SizedBox(
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
                                backgroundColor:
                                    const Color.fromARGB(255, 48, 62, 65),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Iniciar Recorrido',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(height: 64),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
