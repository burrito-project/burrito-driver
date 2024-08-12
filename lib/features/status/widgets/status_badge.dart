import 'package:burrito_driver_app/features/status/data/entities/service_status.dart';
import 'package:flutter/material.dart';

class BurritoStatusBadge extends StatelessWidget {
  final BusServiceStatus status;
  static const badgeWidth = 90.0;
  static const badgeHeight = 24.0;
  static const fontSize = 14.0;
  static const grayColor = Color.fromARGB(255, 110, 110, 110);

  const BurritoStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case BusServiceStatus.working:
        return Container(
          color: Colors.red,
          height: badgeHeight,
          width: badgeWidth,
          child: const Center(
            child: Text(
              'LIVE',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
              ),
            ),
          ),
        );
      case BusServiceStatus.loading:
        return Container(
          color: grayColor,
          height: badgeHeight,
          width: badgeWidth,
          child: const SizedBox(
            height: 12,
            width: 12,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ),
        );
      case BusServiceStatus.off:
        return Container(
          color: grayColor,
          height: badgeHeight,
          width: badgeWidth,
          child: const Center(
            child: Text(
              'APAGADO',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
              ),
            ),
          ),
        );
      default:
        return Container();
    }
  }
}
