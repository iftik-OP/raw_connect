import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

String ticket = 'Ticket Rasied Successfully';
Color snackbarClr = Colors.green;
bool isNotLoading = true;
final user = FirebaseAuth.instance.currentUser;

class formPage extends StatefulWidget {
  const formPage({
    super.key,
  });

  @override
  State<formPage> createState() => _formPageState();
}

class _formPageState extends State<formPage> {
  String? _selectedItem = 'Electricity';

  List<String> category = [
    'Electricity',
    'Cleaning',
    'Plumbing',
    'App Bug',
    'Other',
  ];
  List<String> selectedImages = [];
  final imageURLs = [];
  String imageURL = '';

  TextEditingController _textEditingController = TextEditingController();

  Future<void> sendNotificationToAdmins(String? title, String body) async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Admins').get();

    querySnapshot.docs.forEach((doc) async {
      String adminPhone = doc.id;
      DocumentSnapshot adminSnapshot = await FirebaseFirestore.instance
          .collection('Admins')
          .doc(adminPhone)
          .get();
      String adminToken = adminSnapshot.get('fcmtoken');

      FirebaseMessaging.instance.getToken().then((token) async {
        var data = {
          'to': adminToken,
          'priority': 'high',
          'notification': {
            'title': title,
            'body': body,
          },
        };

        await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            body: jsonEncode(data),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization':
                  'key=AAAAO2esv_g:APA91bH7agK4ydojObIVVyA-swKzXkiaJI6sa0ofSdybrGj30xIIF9C6G0U8AZhUg-rkf7j28p9wL-x3UIA70HH92VsMfVCp1CT_HC2SwNfFG-Z_IVuF2hgPHkrkQSmDyq-4J3O8FUdO'
            });

        // Send the message to each admin's FCM token
        // You can use the data variable above to send the message
      });
    });
  }

  Future<void> uploadImages(
    List<String> images,
  ) async {
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceImages = referenceRoot.child('Images');

    try {
      for (final image in images) {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference referenceImageToUpload = referenceImages.child(fileName);
        await referenceImageToUpload.putFile(File(image));
        imageURL = await referenceImageToUpload.getDownloadURL();
        imageURLs.add(imageURL);
      }
      print(imageURL);
    } catch (e) {
      ticket = 'Error uploading pictures';
      snackbarClr = Colors.red;
    }
  }

  Future<void> uploadItem(
    String? category,
    String description,
    final URLs,
    String ticket,
  ) async {
    try {
      CollectionReference itemsCollection =
          FirebaseFirestore.instance.collection('Service Issues');

      DocumentReference newItem = itemsCollection.doc();

      newItem.set({
        'Category': category,
        'Description': description,
        'imageURL': URLs,
        'Date': DateFormat("yyyy-MM-dd").format(DateTime.now()),
        'RaisedBy': user?.phoneNumber,
      });
      ticket = 'Ticket Raised Successfully';
    } catch (e) {
      ticket = 'Some Error Occured';
      snackbarClr = Colors.red;
    }
  }

  void _pickImages() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();

    // ignore: unnecessary_null_comparison
    if (pickedImages != null) {
      setState(() {
        selectedImages
            .addAll(pickedImages.map((pickedImage) => pickedImage.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Text(
                'Raise an Issue',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  Text(
                    'Choose category: ',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  DropdownButton(
                    iconDisabledColor: Colors.black,
                    value: _selectedItem,
                    borderRadius: BorderRadius.circular(10),
                    items: category
                        .map((e) => DropdownMenuItem(
                              child: Text(e),
                              value: e,
                            ))
                        .toList(),
                    onChanged: (e) => setState(() {
                      _selectedItem = e;
                    }),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                controller: _textEditingController,
                minLines: 5,
                maxLines: 10,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.red[50]),
                padding: EdgeInsets.all(10),
                child: selectedImages.length > 0
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: selectedImages.map(
                          (e) {
                            return Padding(
                              padding: EdgeInsets.all(5),
                              child: Image.file(
                                File(e),
                                fit: BoxFit.cover,
                                width: 70,
                                height: 70,
                              ),
                            );
                          },
                        ).toList(),
                      )
                    : Center(
                        child: GestureDetector(
                          onTap: _pickImages,
                          child: CircleAvatar(
                            radius: 35,
                            child: Icon(Icons.add_a_photo_outlined),
                          ),
                        ),
                      ),
              ),
              SizedBox(
                height: 20,
              ),
              ButtonTheme(
                minWidth: 200,
                height: 100,
                child: ElevatedButton(
                  onPressed: isNotLoading
                      ? () async {
                          setState(() {
                            isNotLoading = false;
                          });

                          String description = _textEditingController.text;
                          ticket = 'Ticket Raised Successfully';

                          await uploadImages(selectedImages);
                          await uploadItem(
                              _selectedItem, description, imageURLs, ticket);

                          sendNotificationToAdmins(_selectedItem, description);

                          // DocumentReference documentReference =
                          //     await FirebaseFirestore.instance
                          //         .collection('Users')
                          //         .doc('iftikharahmad.mgs@gmail.com');

                          // DocumentSnapshot snapshot =
                          //     await documentReference.get();
                          // dynamic myToken = snapshot.get('fcmtoken');

                          // FirebaseMessaging.instance
                          //     .getToken()
                          //     .then((token) async {
                          //   var data = {
                          //     'to': myToken,
                          //     'priority': 'high',
                          //     'notification': {
                          //       'title': _selectedItem,
                          //       'body': description,
                          //     },
                          //   };

                          //   await http.post(
                          //       Uri.parse('https://fcm.googleapis.com/fcm/send'),
                          //       body: jsonEncode(data),
                          //       headers: {
                          //         'Content-Type':
                          //             'application/json; charset=UTF-8',
                          //         'Authorization':
                          //             'key=AAAAO2esv_g:APA91bH7agK4ydojObIVVyA-swKzXkiaJI6sa0ofSdybrGj30xIIF9C6G0U8AZhUg-rkf7j28p9wL-x3UIA70HH92VsMfVCp1CT_HC2SwNfFG-Z_IVuF2hgPHkrkQSmDyq-4J3O8FUdO'
                          //       });
                          // });

                          setState(() {
                            isNotLoading = true;
                          });

                          final snackBar = SnackBar(
                            content: Text(ticket),
                            backgroundColor: snackbarClr,
                            duration: Duration(seconds: 3),
                          );

                          _textEditingController.clear();
                          selectedImages.clear();
                          setState(() {});
                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      : null, // Disable the button when loading

                  child: isNotLoading ? Text('Submit') : Text('Loading...'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red[400]),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
