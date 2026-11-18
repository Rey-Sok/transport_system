import 'package:flutter/material.dart';
import 'package:transport_app/feature/home/screens/welcome.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CamRide App',
      debugShowCheckedModeBanner: false,

      home: const WelcomePage()
    );
  }
}