import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {

  bool petUpdates = true;
  bool adoptionStatus = true;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification Settings"),
        backgroundColor: Colors.deepPurple,
      ),

      body: Column(
        children: [

          SwitchListTile(
            title: const Text("Pet Updates"),
            value: petUpdates,
            onChanged: (value){
              setState(() {
                petUpdates = value;
              });
            },
          ),

          SwitchListTile(
            title: const Text("Adoption Status Updates"),
            value: adoptionStatus,
            onChanged: (value){
              setState(() {
                adoptionStatus = value;
              });
            },
          ),

        ],
      ),
    );
  }
}