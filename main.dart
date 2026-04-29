import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/dashboard.dart';
import 'screens/favorites_screen.dart'; 
import 'screens/profile_screen.dart';
import 'screens/admin_panel_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/care_reminder_screen.dart';
import 'screens/pet_care_tips_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  /// ⭐ Stripe Initialization
  Stripe.publishableKey = "pk_test_51TGNRs9Hhx0W71MAoWO6wqb5VZcKLEDum7R89LkPuaa1Gk4QIaCkXFU9n6WAOVsuGs3rMwVIIC9DhuxL7orKrQMc00RQPvb4lB";

  tz.initializeTimeZones();

  /// 🔔 Initialize notifications
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings settings =
      InitializationSettings(android: androidSettings);

  await flutterLocalNotificationsPlugin.initialize(settings);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  /// allows other screens to access theme
  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool isDarkMode = false;

  /// function to toggle theme
  void toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pet Adoption & Care',

      /// ⭐ Theme switching
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),

      initialRoute: '/login',

      routes: {
        '/signup': (context) => const SignupScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const Dashboard(),
        '/favorites': (context) => const FavoritesScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/admin': (context) => const AdminPanelScreen(),
        '/payment': (context) => PaymentScreen(
  petName: "Demo Pet",
  petPrice: 2000,
),
        '/careReminder': (context) => const CareReminderScreen(),
        
      },
    );
  }
}