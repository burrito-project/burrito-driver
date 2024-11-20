# Cómo funciona la aplicación del conductor

## Servicio de ubicación en segundo plano

Esta aplicación utiliza un servicio de ubicación en segundo plano para realizar un seguimiento continuo de la posición
del autobús, incluso cuando la aplicación está en segundo plano o cuando la pantalla está apagada.
Este servicio se ejecuta de forma silenciosa, asegurando que la ubicación del autobús se envíe al
servidor sin necesidad de que el usuario tenga la aplicación abierta.

## Enviar la ubicación a la API

La aplicación envía periódicamente las coordenadas GPS del autobús a un servidor. Esto se hace
a través de un endpoint de la API, que la aplicación consulta en segundo plano.

## Enviar la batería del teléfono

Al mismo tiempo que la aplicación envía una coordenada al servidor, también envía el
estado de la batería del teléfono.

## Botón simple para iniciar o finalizar el servicio

La aplicación incluye un botón simple que permite a los usuarios iniciar o detener el
servicio de ubicación en segundo plano. Cuando el servicio está iniciado, la aplicación comenzará
a enviar actualizaciones de ubicación al servidor. Cuando se detiene, la aplicación dejará de
hacer un seguimiento o enviar datos de ubicación, lo que finaliza el seguimiento de ubicación para el
autobús.

## Cambiar el estado del burrito

La aplicación permite cambiar el estado del autobús, denominado "burrito,"
entre diferentes estados operacionales. Estos estados representan la condición actual
del autobús:

- **En ruta ("In route"):** El autobús está en camino a su destino.
- **Fuera de servicio ("Out of service"):** El autobús no está operativo o no está disponible.
- **En descanso ("At rest"):** El autobús está temporalmente detenido o inactivo.
- **Accidente ("Accident"):** El autobús ha estado involucrado en un accidente.
- **Error ("Error"):** Hay un problema con el autobús o con los datos de su ubicación.
- **Cargando ("Loading"):** El autobús está siendo cargado o está en preparación.
- **Desconocido ("Unknown"):** El estado del autobús no es conocido.
