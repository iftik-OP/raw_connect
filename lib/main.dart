import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:raw_connect/Pages/homePage.dart';
import 'package:raw_connect/Providers/providers.dart';
import 'Pages/kycPendingPage.dart';
import 'Pages/loginScreen.dart';

@pragma('vm:entry-point')
Future<void> _furebaseMessagingBackgroundHandler(message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance
      // Your personal reCaptcha public key goes here:
      .activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
  );
  final fcmToken = await FirebaseMessaging.instance.getToken();
  FirebaseMessaging.onBackgroundMessage(_furebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  final Widget initialScreen;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;

  if (user != null) {
    // User has successfully logged in, proceed to update the database
    // You can access user details like user.uid, user.displayName, user.email, etc.
    // and update the Firestore database accordingly
    FirebaseFirestore.instance
        .collection('Users')
        .doc(user.phoneNumber)
        .update({
      'fcmtoken': fcmToken,
      // Add any additional data you want to store
    });
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('Users')
        .doc(user.phoneNumber)
        .get();
    bool isVerified = snapshot.data()!['Verified'];
    if (isVerified) {
      initialScreen = homePage();
    } else {
      initialScreen = kycPendingPage();
    }
    FirebaseFirestore.instance
        .collection('Admins')
        .doc(user.phoneNumber)
        .update({
      // 'Name': user.displayName,
      'Phone': user.phoneNumber,
      'fcmtoken': fcmToken,
      // Add any additional data you want to store
    });
  } else {
    initialScreen = loginScreen();
  }
  runApp(MyApp(initialScreen: initialScreen));
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;
  const MyApp({super.key, required this.initialScreen});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RAW Connect',
      theme: ThemeData(
        iconTheme: IconThemeData(color: Colors.white),
        fontFamily: GoogleFonts.poppins().fontFamily,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffD45251)),
        useMaterial3: true,
      ),
      home: initialScreen,
    );
  }
}
