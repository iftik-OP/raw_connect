import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:raw_connect/Pages/loginScreen.dart';

class profilePage extends StatefulWidget {
  const profilePage({super.key});

  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  void initializeFirebase() async {
    // todayDate = int.parse(todaysDate);
    await Firebase.initializeApp();
    // List<int> booked = [];
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('Users')
        .doc(auth.currentUser!.phoneNumber)
        .get();
  }

  void initState() {
    initializeFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Color(0xffD45251),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('Assets/Profile.jpg'),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              auth.currentUser!.displayName.toString(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                'Edit Profile',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xffD45251),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              auth.currentUser!.email.toString(),
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              auth.currentUser!.phoneNumber.toString(),
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Location',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Days left',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                auth.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => loginScreen()),
                  ),
                );
              },
              child: Text(
                'Logout',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xffD45251)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
