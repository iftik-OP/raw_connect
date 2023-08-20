import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:raw_connect/Pages/bookingsPage.dart';

class selectSlotPage extends StatefulWidget {
  final meetingRoomName;
  const selectSlotPage({super.key, required this.meetingRoomName});

  @override
  State<selectSlotPage> createState() => _selectSlotPageState();
}

class HourlySlot {
  final String startTime;
  final String endTime;

  HourlySlot({required this.startTime, required this.endTime});
}

final user = FirebaseAuth.instance.currentUser;

class _selectSlotPageState extends State<selectSlotPage> {
  late DateTime selectedDate;
  String todaysDate = '';
  late int todayDate;
  List<bool> isSelected = List.generate(24, (_) => false);
  List<bool> isBooked = List.generate(24, (_) => false);
  List<bool> isBookedUser = List.generate(24, (_) => false);
  List<String> bookingSlots = [];
  final Color slotColor = Color.fromARGB(223, 94, 199, 52);

  List<HourlySlot> hourlySlots = [
    HourlySlot(startTime: '09:00 AM', endTime: '09:30 AM'),
    HourlySlot(startTime: '09:30 AM', endTime: '10:00 AM'),
    HourlySlot(startTime: '10:00 AM', endTime: '10:30 AM'),
    HourlySlot(startTime: '10:30 AM', endTime: '11:00 AM'),
    HourlySlot(startTime: '11:00 AM', endTime: '11:30 AM'),
    HourlySlot(startTime: '11:30 AM', endTime: '12:00 PM'),
    HourlySlot(startTime: '12:00 PM', endTime: '12:30 PM'),
    HourlySlot(startTime: '12:30 PM', endTime: '01:00 PM'),
    HourlySlot(startTime: '01:00 PM', endTime: '01:30 PM'),
    HourlySlot(startTime: '01:30 PM', endTime: '02:00 PM'),
    HourlySlot(startTime: '02:00 PM', endTime: '02:30 PM'),
    HourlySlot(startTime: '02:30 PM', endTime: '03:00 PM'),
    HourlySlot(startTime: '03:00 PM', endTime: '03:30 PM'),
    HourlySlot(startTime: '03:30 PM', endTime: '04:00 PM'),
    HourlySlot(startTime: '04:00 PM', endTime: '04:30 PM'),
    HourlySlot(startTime: '04:30 PM', endTime: '05:00 PM'),
    HourlySlot(startTime: '05:00 PM', endTime: '05:30 PM'),
    HourlySlot(startTime: '05:30 PM', endTime: '06:00 PM'),
    HourlySlot(startTime: '06:00 PM', endTime: '06:30 PM'),
    HourlySlot(startTime: '06:30 PM', endTime: '07:00 PM'),
    HourlySlot(startTime: '07:00 PM', endTime: '07:30 PM'),
    HourlySlot(startTime: '07:30 PM', endTime: '08:00 PM'),
    HourlySlot(startTime: '08:00 PM', endTime: '08:30 PM'),
    HourlySlot(startTime: '08:30 PM', endTime: '09:00 PM')
  ];

  void initializeFirebase() async {
    // todayDate = int.parse(todaysDate);
    await Firebase.initializeApp();
    // List<int> booked = [];
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('Meeting Room')
        .doc('Bookings')
        .collection('${widget.meetingRoomName}')
        .doc('${selectedDate.day}${selectedDate.month}${selectedDate.year}')
        .get();

    setState(() {
      isBooked = List<bool>.from(documentSnapshot['bookdBool']);
      // isSelected = isBooked;
      print(isBooked);
    });

    DocumentSnapshot documentSnapshot2 = await FirebaseFirestore.instance
        .collection('Users')
        .doc('${user!.phoneNumber}')
        .collection('${widget.meetingRoomName} Bookings')
        .doc('${selectedDate.day}${selectedDate.month}${selectedDate.year}')
        .get();

    setState(() {
      isBookedUser = List<bool>.from(documentSnapshot2['bookdBool']);
      // isSelected = isBooked;
      print(isBooked);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2024),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        for (int i = 0; i < 24; i++) {
          isSelected[i] = false;
          isBooked[i] = false;
        }
      });
      initializeFirebase();
    }
  }

  void updateSlotStatus(int index) async {
    setState(() {
      if (isBooked[index] == true) {
        return;
      } else {
        isSelected[index] = !isSelected[index];
      }
    });
  }

  void updateSlots() {
    // isBooked.fillRange(0, isBooked.length, false);
    for (int i = 0; i < 24; i++) {
      if (isSelected[i] == true) {
        isBooked[i] = true;
      }
    }
    FirebaseFirestore.instance
        .collection('Meeting Room')
        .doc('Bookings')
        .collection('${widget.meetingRoomName}')
        .doc('${selectedDate.day}${selectedDate.month}${selectedDate.year}')
        .set({
      'bookdBool': isBooked,
      'bookedBy': user!.phoneNumber,
    });
    print(isBooked);
    // showSuccessDialog();
  }

  void updateUserBooking() {
    isBookedUser.fillRange(0, isBookedUser.length, false);
    for (int i = 0; i < 24; i++) {
      if (isSelected[i] == true) {
        isBookedUser[i] = true;
      }
    }
    print('${user!.email}');
    String docId =
        '${selectedDate.day}${selectedDate.month}${selectedDate.year}';

    int intDocId = int.parse(docId);
    FirebaseFirestore.instance
        .collection('Users')
        .doc('${user!.phoneNumber}')
        .collection('${widget.meetingRoomName} Bookings')
        .doc(docId)
        .set({
      'docId': intDocId,
      'bookdBool': isBookedUser,
      'Meeting Room': '${widget.meetingRoomName}',
      'Date': '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
    });
  }

  void showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Bookings?'),
          content: Text('You will not be able to change your bookings later.'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () async {
                updateSlots();
                updateUserBooking();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
        backgroundColor: Color(0xffD45251),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select\nSlot',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Image.asset(
                    'Assets/office vector.jpg',
                    height: 150,
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  widget.meetingRoomName,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[300],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _selectDate(context);
                          },
                          child: const Text(
                            'Change Date',
                            style: TextStyle(
                                fontSize: 12,
                                color: Color.fromARGB(255, 232, 83, 72)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: GridView.builder(
                      itemCount: hourlySlots.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                      ),
                      itemBuilder: (context, index) {
                        final slot = hourlySlots[index];
                        return GestureDetector(
                          onTap: () => updateSlotStatus(index),
                          child: SizedBox(
                            child: Container(
                              decoration: ShapeDecoration(
                                color: Color(0x1CD9D9D9),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 1.50,
                                    color: isBooked[index]
                                        ? Color.fromARGB(130, 218, 113, 113)
                                        : isSelected[index]
                                            ? Color.fromARGB(70, 156, 215, 243)
                                            : slotColor,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 20),
                              child: Center(
                                child: Text(
                                  '${slot.startTime}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                    color: isBooked[index]
                                        ? Color.fromARGB(130, 218, 113, 113)
                                        : isSelected[index]
                                            ? Colors.blue
                                            : Colors.green,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 400,
                  height: 60,
                  child: GestureDetector(
                    onTap: () {
                      if (isSelected.every((element) => element == false)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            behavior: SnackBarBehavior.floating,
                            content: Text('Please select a slot'),
                          ),
                        );
                        return;
                      }
                      showConfirmationDialog();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0xffD45251),
                      ),
                      child: const Center(
                        child: Text(
                          'Book Slot',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => bookingsPage(
                                meetingRoomName: widget.meetingRoomName,
                              )),
                    );
                  },
                  child: SizedBox(
                    width: 400,
                    height: 60,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Color(0xffD45251),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Bookings',
                          style: TextStyle(
                              color: Color(0xffD45251),
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
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
