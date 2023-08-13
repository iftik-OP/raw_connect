import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class wifiPasswordPage extends StatefulWidget {
  const wifiPasswordPage({super.key});

  @override
  State<wifiPasswordPage> createState() => _wifiPasswordPageState();
}

class _wifiPasswordPageState extends State<wifiPasswordPage> {
  late Stream<QuerySnapshot> _stream;

  void initState() {
    super.initState();

    _stream =
        FirebaseFirestore.instance.collection('WiFi Passwords').snapshots();
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
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'WiFi\nPasswords',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
                  ),
                  Icon(
                    Icons.wifi,
                    size: 100,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  final List<DocumentSnapshot> wifis = snapshot.data!.docs;

                  return SingleChildScrollView(
                    child: Column(
                      children: wifis.map((wifi) {
                        final Name = wifi['Name'];
                        final password = wifi['Password'];

                        return Card(
                          child: ListTile(
                            leading: Icon(Icons.wifi),
                            title: Text(Name),
                            subtitle: Text(password),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
