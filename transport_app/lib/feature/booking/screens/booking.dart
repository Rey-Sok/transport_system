import 'package:flutter/material.dart';

class SelectCarPage extends StatefulWidget {
  const SelectCarPage({super.key});

  @override
  State<SelectCarPage> createState() => _SelectCarPageState();
}

class _SelectCarPageState extends State<SelectCarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Car Select Page"),
      ),
    );
  }
}
