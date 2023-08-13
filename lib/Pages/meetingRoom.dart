import 'package:flutter/material.dart';
import 'package:raw_connect/Pages/selectSlot.dart';

class meetingRoomPage extends StatefulWidget {
  const meetingRoomPage({super.key});

  @override
  State<meetingRoomPage> createState() => _meetingRoomPageState();
}

class _meetingRoomPageState extends State<meetingRoomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: Color(0xffD45251),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Meeting\nRoom',
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.w600),
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
                      'Select Meeting Room',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const selectSlotPage(
                              meetingRoomName: 'Meeting Room 1',
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 115,
                        width: 400,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                // mainAxisAlignment:
                                //     MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Meeting Room 1',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    'Capacity: 6',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  // Text(
                                  //   'Credits: 1/HR',
                                  //   style: TextStyle(
                                  //       fontSize: 15,
                                  //       fontWeight: FontWeight.w600),
                                  // ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xffD45251),
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
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
                            builder: (context) => const selectSlotPage(
                              meetingRoomName: 'Meeting Room 2',
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 115,
                        width: 400,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                // mainAxisAlignment:
                                //     MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Meeting Room 2',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    'Capacity: 8',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  // Text(
                                  //   'Credits: 2/HR',
                                  //   style: TextStyle(
                                  //       fontSize: 15,
                                  //       fontWeight: FontWeight.w600),
                                  // ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xffD45251),
                                ),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
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
                            builder: (context) => const selectSlotPage(
                              meetingRoomName: 'Meeting Room 3',
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 115,
                        width: 400,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Column(
                                // mainAxisAlignment:
                                //     MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Meeting Room 3',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    'Capacity: 10',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  // Text(
                                  //   'Credits: 3/HR',
                                  //   style: TextStyle(
                                  //       fontSize: 15,
                                  //       fontWeight: FontWeight.w600),
                                  // ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xffD45251),
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                ),
                              ),
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
        ),
      ),
    );
  }
}
