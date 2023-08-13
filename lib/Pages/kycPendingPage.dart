import 'package:flutter/material.dart';

class kycPendingPage extends StatelessWidget {
  const kycPendingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Image.asset(
            'Assets/White logo.png',
            height: 100,
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xffD45251),
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 150,
              ),
              Center(
                child: Text(
                  'Submitted\nSuccessfully!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Image.asset(
                'Assets/verified logo.png',
                height: 100,
              ),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'You have successfully submitted your KYC, you will be able to use the RAW connect app once your documents have been verified.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
