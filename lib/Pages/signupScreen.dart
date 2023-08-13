import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raw_connect/Pages/loginScreen.dart';

import '../Providers/providers.dart';
import 'otpPage.dart';

class signupScreen extends StatefulWidget {
  const signupScreen({super.key});

  @override
  State<signupScreen> createState() => _signupScreenState();
}

class _signupScreenState extends State<signupScreen> {
  TextEditingController _phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff2C302E),
        body: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Center(
              child: Image.asset(
                'Assets/RAW text png.png',
                height: 227,
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xffECECEC),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(110),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          textAlign: TextAlign.left,
                          "Signup",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        TextField(
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            filled: true,
                            fillColor: const Color(0xffD9D8D8),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: '+91 Phone Number',
                            filled: true,
                            fillColor: const Color(0xffD9D8D8),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            filled: true,
                            fillColor: const Color(0xffD9D8D8),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          const Color(0xff2C302E)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                  ))),
                              onPressed: () async {
                                await FirebaseAuth.instance.verifyPhoneNumber(
                                  phoneNumber:
                                      '+91 ${_phoneController.text.trim()}',
                                  verificationCompleted:
                                      (PhoneAuthCredential credential) {},
                                  verificationFailed:
                                      (FirebaseAuthException e) {
                                    print('Ye hai err: ${e.message}');

                                    const snackBar = SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor:
                                          Color.fromARGB(164, 232, 24, 9),
                                      content: Text('Some Error Occured'),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  },
                                  codeSent: (String verificationId,
                                      int? resendToken) {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => otpPage()));
                                  },
                                  codeAutoRetrievalTimeout:
                                      (String verificationId) {},
                                );
                              },
                              child: Text(
                                'Continue',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  (MaterialPageRoute(
                                    builder: (context) => loginScreen(),
                                  )));
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w300),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
