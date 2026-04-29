import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class CareReminderScreen extends StatefulWidget {
  const CareReminderScreen({super.key});

  @override
  State<CareReminderScreen> createState() => _CareReminderScreenState();
}

class _CareReminderScreenState extends State<CareReminderScreen> {
  DateTime? selectedDateTime;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    await flutterLocalNotificationsPlugin.initialize(settings);

    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> pickDateTime() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    setState(() {
      selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  // ✅ FIXED REMINDER FUNCTION
  Future<void> scheduleNotification() async {
    if (selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select date and time first")),
      );
      return;
    }

    final now = DateTime.now();
    final difference = selectedDateTime!.difference(now);

    if (difference.isNegative) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please choose a future time")),
      );
      return;
    }

    Future.delayed(difference, () async {
      await flutterLocalNotificationsPlugin.show(
        0,
        "Pet Care Reminder 🐾",
        "It's time to take care of your pet ❤️",
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'care_channel',
            'Care Reminder',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Reminder Set ✅"),
        content: const Text("Your pet care reminder has been scheduled."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  // TEST BUTTON (keep for checking notifications)
  Future<void> testNotification() async {
    await flutterLocalNotificationsPlugin.show(
      1,
      "Pet Care Reminder 🐾",
      "Time to take care of your pet ❤️",
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel',
          'Test Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Care Reminder"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff667eea), Color(0xff764ba2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.pets, size: 60, color: Colors.deepPurple),

                  const SizedBox(height: 10),

                  const Text(
                    "Set Pet Care Reminder",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton.icon(
                    onPressed: pickDateTime,
                    icon: const Icon(Icons.calendar_today),
                    label: const Text("Select Date & Time"),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    selectedDateTime == null
                        ? "No date selected"
                        : "${selectedDateTime!.day}/${selectedDateTime!.month}/${selectedDateTime!.year}  ${selectedDateTime!.hour}:${selectedDateTime!.minute}",
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 25),

                  ElevatedButton.icon(
                    onPressed: scheduleNotification,
                    icon: const Icon(Icons.alarm),
                    label: const Text("Set Reminder"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                    ),
                  ),

                  const SizedBox(height: 20),

                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}