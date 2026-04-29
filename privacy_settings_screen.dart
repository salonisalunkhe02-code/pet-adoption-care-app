import 'package:flutter/material.dart';

class PrivacySettingsScreen extends StatelessWidget {
  const PrivacySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Settings"),
        backgroundColor: Colors.deepPurple,
      ),

      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          "Your personal information is safe and only used for adoption verification.",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}