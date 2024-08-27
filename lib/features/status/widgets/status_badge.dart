import 'package:burrito_driver_app/features/status/data/entities/service_status.dart';
import 'package:flutter/material.dart';

class BurritoStatusBadge extends StatelessWidget {
  final BusServiceStatus status;
  static const badgeWidth = 100.0;
  static const badgeHeight = 32.0;
  static const fontSize = 16.0;
  static const grayColor = Color.fromARGB(255, 110, 110, 110);

  const BurritoStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case BusServiceStatus.working:
        return Container(
          height: badgeHeight,
          width: badgeWidth,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(4),
          ),
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
          height: badgeHeight,
          width: badgeWidth,
          decoration: BoxDecoration(
            color: grayColor,
            borderRadius: BorderRadius.circular(4),
          ),
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
          height: badgeHeight,
          width: badgeWidth,
          decoration: BoxDecoration(
            color: grayColor,
            borderRadius: BorderRadius.circular(4),
          ),
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
