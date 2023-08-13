import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:raw_connect/Pages/kycPendingPage.dart';

class kycFormPage extends StatefulWidget {
  const kycFormPage({super.key});

  @override
  State<kycFormPage> createState() => _kycFormPageState();
}

class _kycFormPageState extends State<kycFormPage> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  bool isLoading = false;

  Future uploadKYC() async {
    setState(() {
      isLoading = true;
    });
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        pickedFile == null) {
      SnackBar snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color.fromARGB(164, 232, 24, 9),
        content: Text('Please fill all the fields'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        isLoading = false;
      });
    } else {
      try {
        final path =
            'KYCdocs/${FirebaseAuth.instance.currentUser!.phoneNumber}KYC';
        final file = File(pickedFile!.path!);

        final ref = FirebaseStorage.instance.ref().child(path);
        uploadTask = ref.putFile(file);

        final snapshot = await uploadTask!.whenComplete(() => null);

        final URLdownload = await snapshot.ref.getDownloadURL();
        print(URLdownload);

        try {
          bool Verified = false;
          CollectionReference itemsCollection =
              FirebaseFirestore.instance.collection('Users');

          DocumentReference newItem = itemsCollection
              .doc(FirebaseAuth.instance.currentUser!.phoneNumber);

          User user = FirebaseAuth.instance.currentUser!;
          user.updateDisplayName(nameController.text);
          user.updateEmail(emailController.text);

          newItem.set({
            'Verified': Verified,
            'Name': nameController.text,
            'email': emailController.text,
            'KYC': URLdownload,
          });

          setState(() {
            isLoading = false;
          });

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => kycPendingPage()),
            ),
          );
        } catch (e) {
          SnackBar snackBar = SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Color.fromARGB(163, 75, 75, 75),
            content: Text(e.toString()),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          setState(() {
            isLoading = false;
          });
        }
      } catch (e) {
        SnackBar snackBar = SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color.fromARGB(163, 75, 75, 75),
          content: Text(e.toString()),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _pickFiles() async {
    print('Function Executed');
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'doc', 'png'],
      );

      if (result != null) {
        setState(() {
          pickedFile = result.files.first;
        });
        print(pickedFile!.name);
      } else {
        SnackBar snackBar = const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color.fromARGB(163, 75, 75, 75),
          content: Text('Select a file'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      print('Error in file uploading: ${e.toString()}');
      SnackBar snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color.fromARGB(164, 232, 24, 9),
        content: Text(e.toString()),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Center(
                  child: Image.asset(
                'Assets/RAW text png.png',
                height: 150,
              )),
              Center(
                child: Text(
                  'Complete KYC',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    textAlign: TextAlign.center,
                    'Complete your KYC to start using the RAW Connect app',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(color: Colors.grey)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.grey)),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  height: 150,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: pickedFile == null
                          ? Text(
                              'Upload your ID proof\n(Aadhar Card, PAN Card)',
                              style: TextStyle(color: Colors.grey),
                              textAlign: TextAlign.center,
                            )
                          : Text(
                              pickedFile!.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 46, 171, 52)),
                            ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: _pickFiles,
                child: Text(
                  'Upload File',
                  style: TextStyle(color: Color.fromARGB(255, 255, 17, 0)),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 50,
                width: 330,
                child: GestureDetector(
                  onTap: uploadKYC,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 226, 79, 69),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: isLoading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              'Submit',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
