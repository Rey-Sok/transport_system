import 'package:flutter/material.dart';
import 'package:transport_app/feature/home/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CamRide App',
      home: const HomePage(),
    );
  }
}
