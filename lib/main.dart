import 'package:flutter/material.dart';
import 'package:burrito_driver_app/features/core/widgets/home_page.dart';

void main() {
  runApp(const DriverApp());
}

class DriverApp extends StatelessWidget {
  const DriverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Burrito Driver',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        hintColor: Colors.blueAccent,
        fontFamily: 'Roboto',
      ),
      home: const Scaffold(
        primary: true,
        // backgroundColor: Color(0xffc6d1e1),
        backgroundColor: Color.fromARGB(255, 28, 28, 28),
        body: SafeArea(
          child: HomePage(),
        ),
      ),
    );
  }
}
