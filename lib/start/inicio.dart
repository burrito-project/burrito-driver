import 'package:burrito_driver_app/ending/final.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class BotonSolicitudes extends StatefulWidget {
  const BotonSolicitudes({super.key});

  @override
  BotonSolicitudesState createState() => BotonSolicitudesState();
}

class BotonSolicitudesState extends State<BotonSolicitudes> {
  Timer? _timer;
  bool _isRunning = false;
  int _selectedStatus = 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Function to start periodic requests
  void _startRequests() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!_isRunning) {
        timer.cancel();
      } else {
        await _hacerSolicitudes();
      }
    });
  }

  // Function to stop periodic requests
  void _stopRequests() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  // Function to make the POST request
  Future<void> _hacerSolicitudes() async {
    Position? position;
    try {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
    } catch (e) {
      debugPrint('Error al obtener la ubicación: $e');
    }

    if (position != null) {
      final urlPost = Uri.parse('http://elenadb.live:6969/status');

      try {
        final postData = {
          'lt': position.latitude,
          'lg': position.longitude,
          'sts': _selectedStatus,
        };

        final response = await http.post(
          urlPost,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'te quiero burrito',
          },
          body: jsonEncode(postData),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Solicitud enviada correctamente'),
                backgroundColor: Colors.green,
                duration: Duration(milliseconds: 500),
              ),
            );
          }
        } else {
          debugPrint('Error en POST request: ${response.statusCode}');
        }
      } catch (e, st) {
        debugPrint('Excepción atrapada: $e $st');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error en la solicitud: $e'),
              backgroundColor: Colors.red,
              duration: const Duration(milliseconds: 500),
            ),
          );
        }
      }
    }
  }

  void _navigateToStatusButton() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StatusButton(
          onStop: _stopRequests,
          currentStatus: _selectedStatus,
          onStatusChanged: (newStatus) async {
            setState(() {
              _selectedStatus = newStatus;
            });
            await _hacerSolicitudes(); // Realiza la solicitud POST inmediatamente
          },
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedStatus = result;
        _isRunning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Burrito Driver App',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Koulen',
                  ),
                ),
                SizedBox(height: screenHeight * 0.1),
                Image.asset(
                  'assets/img/real_burrito_icon.png',
                  width: screenWidth * 0.8,
                  height: screenWidth * 0.8,
                ),
                SizedBox(height: screenHeight * 0.1),
              ],
            ),
            Center(
              child: SizedBox(
                width: screenWidth * 0.9,
                height: screenHeight * 0.08,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isRunning = true;
                      _startRequests();
                    });
                    _navigateToStatusButton();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 37, 37, 37),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Iniciar Recorrido',
                    style: TextStyle(fontSize: screenHeight * 0.03),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
          ],
        ),
      ),
    );
  }
}
