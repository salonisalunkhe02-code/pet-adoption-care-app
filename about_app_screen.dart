import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("About App"),
        backgroundColor: Colors.deepPurple,
      ),

      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [

            Text(
              "Pet Adoption App",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "This app helps users adopt pets and provide them a loving home.",
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 20),

            Text("Version 1.0")

          ],
        ),
      ),
    );
  }
}