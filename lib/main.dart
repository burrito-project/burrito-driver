import 'package:burrito_driver_app/start/inicio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DriverApp());
}

class DriverApp extends StatelessWidget {
  const DriverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Burrito Driver App',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        hintColor: Colors.blueAccent,
        fontFamily: 'Roboto',
      ),
      home: const Scaffold(
        primary: true,
        backgroundColor: Color(0xffc6d1e1),
        body: SafeArea(
          child: HomePage(),
        ),
      ),
    );
  }
}
