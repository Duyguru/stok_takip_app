import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initFCM();
  runApp(const MyApp());
}

Future<void> _initFCM() async {
  try {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      await ApiService.sendFcmToken(fcmToken);
    }
  } catch (e) {
    // Token alınamazsa sessizce geç
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stok Takip',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
