import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> showLocationPermissionsModal(BuildContext context) async {
  if (context.mounted) {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Permisos de ubicación'),
          content: RichText(
            text: const TextSpan(
              children: [
                TextSpan(text: 'En la pestaña de '),
                TextSpan(
                  text: 'Permisos > Ubicación',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: ', activa la ubicación '),
                TextSpan(
                  text: 'en todo momento.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await Geolocator.openAppSettings();
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Abrir configuración'),
            ),
          ],
        );
      },
    );
  }
}

Future<void> showNotificationsPermissionsModal(BuildContext context) async {
  if (context.mounted) {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Permisos de notificación'),
          content: RichText(
            text: const TextSpan(
              children: [
                TextSpan(text: 'En la pestaña de '),
                TextSpan(
                  text: 'Permisos > Notificaciones',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: ', activa las notificaciones.'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await Geolocator.openAppSettings();
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Abrir configuración'),
            ),
          ],
        );
      },
    );
  }
}

Future<bool> manageNeededPermissions(BuildContext context) async {
  final locationPermissions = await Permission.locationAlways.status;
  final notificationPermissions = await Permission.notification.status;

  if (locationPermissions.isGranted && notificationPermissions.isGranted) {
    return true;
  }

  final locationResult = await Permission.locationAlways.request();

  if (locationResult.isPermanentlyDenied || locationResult.isDenied) {
    if (context.mounted) {
      await showLocationPermissionsModal(context);
    }
    return false;
  }

  final notificationResult = await Permission.notification.request();

  if (notificationResult.isPermanentlyDenied) {
    if (context.mounted) {
      await showNotificationsPermissionsModal(context);
    }
    return false;
  }

  return false;
}
