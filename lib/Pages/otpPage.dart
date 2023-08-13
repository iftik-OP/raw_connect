import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:raw_connect/Pages/loadingPage.dart';

class otpPage extends StatefulWidget {
  final verificationIdd;
  otpPage({super.key, required this.verificationIdd});

  @override
  State<otpPage> createState() => _otpPageState();
}

class _otpPageState extends State<otpPage> {
  bool isLoading = false;

  FirebaseAuth auth = FirebaseAuth.instance;
  var code = '';
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
                        "Enter OTP",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Pinput(
                        androidSmsAutofillMethod:
                            AndroidSmsAutofillMethod.smsUserConsentApi,
                        closeKeyboardWhenCompleted: true,
                        length: 6,
                        onChanged: (value) {
                          print(value);
                          code = value;
                        },
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
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xff2C302E)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              try {
                                print('Code: ${code}');
                                PhoneAuthCredential creds =
                                    PhoneAuthProvider.credential(
                                        verificationId: widget.verificationIdd,
                                        smsCode: code);
                                await auth.signInWithCredential(creds);
                                print("User Registered Successfully");
                                setState(() {
                                  isLoading = false;
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: ((context) => loadingPage()),
                                  ),
                                );
                              } catch (e) {
                                setState(() {
                                  isLoading = false;
                                  SnackBar snackBar = SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor:
                                        Color.fromARGB(164, 232, 24, 9),
                                    content: Text(e.toString()),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                });
                                print(e);
                              }
                            },
                            child: isLoading
                                ? CircularProgressIndicator()
                                : Text(
                                    'Continue',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 120,
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Change Mobile Number',
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
      ),
    );
  }
}
