import 'package:flutter/material.dart';

class PetCareTipsScreen extends StatelessWidget {
  const PetCareTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pet Care Tips"),
        backgroundColor: Colors.orange,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [

          ListTile(
            leading: Icon(Icons.pets),
            title: Text("Feed your pet healthy food"),
          ),

          ListTile(
            leading: Icon(Icons.water_drop),
            title: Text("Always provide clean water"),
          ),

          ListTile(
            leading: Icon(Icons.local_hospital),
            title: Text("Regular vet checkups"),
          ),

          ListTile(
            leading: Icon(Icons.directions_run),
            title: Text("Daily exercise for pets"),
          ),

        ],
      ),
    );
  }
}