import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:raw_connect/Pages/otpPage.dart';

// ignore: camel_case_types, must_be_immutable
class loginScreen extends StatefulWidget {
  loginScreen({super.key});
  var phoneNumber = '';
  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  bool loading = false;
  final TextEditingController _phoneNumberController = TextEditingController();
  var phone;

  final signupPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2C302E),
      body: Column(
        children: [
          const SizedBox(
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
              decoration: const BoxDecoration(
                color: Color(0xffECECEC),
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
                      const SizedBox(
                        height: 100,
                      ),
                      const Text(
                        textAlign: TextAlign.left,
                        "Login",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      TextField(
                        controller: _phoneNumberController,
                        onChanged: (value) {
                          phone = value;
                        },
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
                      const SizedBox(
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
                                    const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ))),
                            onPressed: () async {
                              // _loginWithPhoneNumber(context);
                              loginScreen().phoneNumber = phone;
                              if (phone.length != 10) {
                                SnackBar snackBar = const SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor:
                                      Color.fromARGB(164, 232, 24, 9),
                                  content: Text('Enter a valid phone number'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                return;
                              } else {
                                FirebaseAuth auth = FirebaseAuth.instance;
                                setState(() {
                                  loading = true;
                                });
                                await auth.verifyPhoneNumber(
                                  phoneNumber: '+91 ${phone}',
                                  verificationCompleted:
                                      (PhoneAuthCredential credential) async {
                                    await auth.signInWithCredential(credential);
                                  },
                                  verificationFailed:
                                      (FirebaseAuthException e) {
                                    print('Ye hai err: ${e.message}');

                                    SnackBar snackBar = SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor:
                                          Color.fromARGB(164, 232, 24, 9),
                                      content: Text(e.message!),
                                    );
                                    setState(() {
                                      loading = false;
                                    });
                                    print('Verification Failed: ${e.message}');
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  },
                                  codeSent: (String verificationId,
                                      int? resendToken) {
                                    setState(() {
                                      loading = false;
                                    });
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => otpPage(
                                                  verificationIdd:
                                                      verificationId,
                                                )));
                                  },
                                  codeAutoRetrievalTimeout:
                                      (String verificationId) {},
                                );
                              }
                            },
                            child: loading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 1.5,
                                  )
                                : const Text(
                                    'Send Code',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
