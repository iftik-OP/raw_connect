import 'package:flutter/material.dart';
import 'package:raw_connect/Pages/profilePage.dart';
import 'package:raw_connect/Pages/raiseIssuePage.dart';
import 'package:raw_connect/Pages/wifiPasswordPage.dart';

import 'meetingRoom.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'Assets/White logo.png',
          height: 100,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => profilePage()),
                );
              },
              child: CircleAvatar(
                child: Image.asset('Assets/Profile.jpg'),
              ),
            ),
          )
        ],
        automaticallyImplyLeading: false,
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
                    'Your One\nStop\nOffice\nSolution.',
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
                  'Services',
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
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 30,
                  crossAxisSpacing: 30,
                  primary: true,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => meetingRoomPage()),
                        );
                      },
                      child: Container(
                        child: Image.asset(
                          'Assets/meeting room.png',
                          fit: BoxFit.cover,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 5,
                                spreadRadius: 3,
                                blurStyle: BlurStyle.outer,
                                color: Color.fromARGB(41, 158, 158, 158)
                                    .withOpacity(0.5),
                              )
                            ]),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => formPage()),
                        );
                      },
                      child: Container(
                        child: Image.asset(
                          'Assets/Raise an issue.png',
                          fit: BoxFit.cover,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 5,
                                spreadRadius: 2,
                                blurStyle: BlurStyle.outer,
                                color: Colors.grey.withOpacity(0.5),
                              )
                            ]),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => wifiPasswordPage())));
                      },
                      child: Container(
                        child: Image.asset(
                          'Assets/wifi password.png',
                          fit: BoxFit.cover,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 5,
                                spreadRadius: 2,
                                blurStyle: BlurStyle.outer,
                                color: Colors.grey.withOpacity(0.5),
                              )
                            ]),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
