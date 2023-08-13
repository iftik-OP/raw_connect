import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:raw_connect/Pages/homePage.dart';
import 'package:raw_connect/Pages/kycFormPage.dart';

import 'kycPendingPage.dart';

class loadingPage extends StatefulWidget {
  const loadingPage({super.key});

  @override
  State<loadingPage> createState() => _loadingPageState();
}

class _loadingPageState extends State<loadingPage> {
  @override
  void initState() {
    super.initState();
    // Call your function here
    checkExistingUser();
  }

  void checkExistingUser() {
    final user = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.phoneNumber);

    print('Phone: ${FirebaseAuth.instance.currentUser!.phoneNumber}');

    user.get().then((docSnapshot) {
      if (docSnapshot.exists) {
        if (docSnapshot['Verified']) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: ((context) => homePage()),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: ((context) => kycPendingPage()),
            ),
          );
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => kycFormPage()),
        );
      }
    });
  }

  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: CircularProgressIndicator(),
    ));
  }
}
