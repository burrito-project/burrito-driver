<!-- markdownlint-disable MD033 MD042 -->

# Construcción de la aplicación del conductor del burrito

Para información más detallada, consulta
[la documentación oficial de Flutter](https://docs.flutter.dev/deployment/android#build-the-app-for-release).

<div class="warning">
Ten en cuenta que esta documentación es solo para Android. Aunque Flutter soporta completamente iOS, aún no se ha probado con este proyecto.

Hay un flujo de trabajo funcional llamado ios-compilation.yml en el directorio .github/workflows
que puedes consultar.
</div>

## Construcción del APK

Para construir APKs para múltiples arquitecturas (por ejemplo, ARM, ARM64, x86), utiliza el siguiente comando. Esto generará archivos APK separados para cada ABI (Interfaz Binaria de Aplicación), permitiendo a los usuarios descargar el APK adecuado para la arquitectura de su dispositivo:

```json
flutter build apk --split-per-abi
```

Los APKs se guardarán en el directorio `build/app/outputs/flutter-apk/`. Puedes encontrar los APKs generados en esa carpeta, listos para pruebas o distribución.

## Construir un paquete de la aplicación para la liberación

Además de construir los APKs, también es una buena práctica generar un Paquete de la Aplicación (.aab) para liberar la aplicación en la Google Play Store. El Paquete de la Aplicación contiene todo lo necesario para la distribución, y Google Play optimizará automáticamente la aplicación para diferentes configuraciones de dispositivos.

Para construir una versión de liberación del Paquete de la Aplicación, utiliza el siguiente comando:

```json
flutter build appbundle --release
```

Una vez que la construcción esté completa, el archivo .aab estará disponible en el directorio `build/app/outputs/bundle/release/`. Puedes subir este archivo a la Google Play Console o cualquier otra tienda de aplicaciones que soporte Paquetes de Aplicación.
