import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:raw_connect/Components/meetingRoomBookingCard.dart';

class bookingsPage extends StatefulWidget {
  final meetingRoomName;
  const bookingsPage({super.key, required this.meetingRoomName});

  @override
  State<bookingsPage> createState() => _bookingsPageState();
}

final user = FirebaseAuth.instance.currentUser;

class _bookingsPageState extends State<bookingsPage> {
  String todaysDate = '';
  late int todayDate;
  late DateTime selectedDate;

  void initializeFirebase() async {
    // todayDate = int.parse(todaysDate);
    await Firebase.initializeApp();
    // List<int> booked = [];
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc('${user!.phoneNumber}')
        .collection('${widget.meetingRoomName} Bookings')
        .doc('${selectedDate.day}${selectedDate.month}${selectedDate.year}')
        .get();
  }

  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    todaysDate = '${selectedDate.day}${selectedDate.month}${selectedDate.year}';

    initializeFirebase();
    todayDate = int.parse(todaysDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Color(0xffD45251),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Bookings',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
                  ),
                  Image.asset(
                    'Assets/office vector.jpg',
                    height: 150,
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Center(
                child: Text(
                  'Your Bookings',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Users')
                              .doc('${user!.phoneNumber}')
                              .collection('${widget.meetingRoomName} Bookings')
                              .where('docId', isGreaterThanOrEqualTo: todayDate)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            }

                            final List<DocumentSnapshot> documents =
                                snapshot.data!.docs;

                            if (documents.isEmpty) {
                              return const Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Center(
                                    child: Text('No Bookings'),
                                  ),
                                  SizedBox(
                                    height: 50,
                                  )
                                ],
                              );
                            }

                            return SingleChildScrollView(
                              child: Column(
                                children: documents.map((document) {
                                  final Date = document['Date'];
                                  final roomName = document['Meeting Room'];
                                  final bookedBool = document['bookdBool'];

                                  int id = int.parse(document.id);

                                  return MeetingRoomBookingContainer(
                                      roomName: roomName,
                                      date: Date,
                                      availableTimeSlots: bookedBool);
                                }).toList(),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
