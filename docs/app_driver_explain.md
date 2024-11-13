# How this app works

## Background location service

This app uses a background location service to continuously track the position
of the bus, even when the app is in the background or when the screen is off.
This service runs silently, ensuring that the bus-s location is sent to the
server without requiring the user to have the app open.

## Sending the location to the API

The app periodically sends the bus's GPS coordinates to a server. This is done
through an API endpoint, which the app hits in the background.

## Simple button to start or end the service

The app includes a simple button that allows users to start or stop the
background location service. When the service is started, the app will begin
sending location updates to the server. When stopped, the app will no longer
track or send location data, effectively ending the location tracking for the
bus.

## Change the state of the burrito

The app allows changing the state of the bus, referred to as the "burrito,"
between different operational statuses. These statuses represent the current
condition of the bus:

- **En ruta ("In route"):** The bus is on its way to its destination.
- **Fuera de servicio ("Out of service"):** The bus is not operational or
unavailable.
- **En descanso ("At rest"):** The bus is temporarily stopped or idle.
- **Accidente ("Accident"):** The bus has been involved in an accident.
- **Error ("Error"):** There is an issue with the bus or its location data.
- **Cargando ("Loading"):** The bus is being loaded or is in preparation.
- **Desconocido ("Unknown"):** The bus status is not known.
