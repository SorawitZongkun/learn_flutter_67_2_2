// Step 2: App Screen
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// Step 3: Check internet connection
import 'package:connectivity_plus/connectivity_plus.dart';

// Step 4: Show toast message
import 'package:fluttertoast/fluttertoast.dart';

// Step 6: Firestore service
import 'package:learn_flutter_67_2_2/services/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  // อะไรที่อยากให้ทำก่อน ให้เขียนใน initState()
  void initState() {
    super.initState();

    // Step 3: Check internet connection
    chechInternetConnection();
  }

  // Step 3: Check internet connection
  Future<void> chechInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    // This condition is for demo purposes only to explain every connection type.
    // Use conditions which work for your requirements.
    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      // Mobile network available.
      _showToast(context, "Mobile network is available.");
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      // Wi-fi is available.
      // Note for Android:
      // When both mobile and Wi-Fi are turned on system will return Wi-Fi only as active network type
      _showToast(context, "Wi-Fi is available.");
    } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
      // Ethernet connection available.
      _showToast(context, "LAN is available.");
    } else if (connectivityResult.contains(ConnectivityResult.vpn)) {
      // Vpn connection active.
      // Note for iOS and macOS:
      // There is no separate network interface type for [vpn].
      // It returns [other] on any device (also simulator)
      _showToast(context, "VPN is available.");
    } else if (connectivityResult.contains(ConnectivityResult.bluetooth)) {
      // Bluetooth connection available.
      _showToast(context, "Bluetooth is available.");
    } else if (connectivityResult.contains(ConnectivityResult.other)) {
      // Connected to a network which is not in the above mentioned networks.
      _showToast(context, "Other network is available.");
    } else if (connectivityResult.contains(ConnectivityResult.none)) {
      // No available network types
      setState(() {
        _showAlertDialog(
          context,
          "No Internet Connection",
          "Please check your internet connection and try again.",
        );
      });
    }
  }

  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orangeAccent, Colors.deepOrange],
          begin: FractionalOffset(0.0, 0.0),
          end: FractionalOffset(0.6, 0.5),
          tileMode: TileMode.repeated,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('./android/assets/images/app_screen.png'),
          const SizedBox(height: 50),
          const SpinKitSpinningLines(color: Colors.white),
        ],
      ),
    );
  }
}

// Step 4: Show toast message
void _showToast(BuildContext context, String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.green,
    textColor: Colors.white,
    fontSize: 14.0,
  );
  _timer(context);
}

// Step 4: Show toast message
void _timer(BuildContext context) {
  // เมื่อครบเวลา จะทำการกดปุ่มโดยอัตโนมัติ
  Timer(
    const Duration(seconds: 3),
    () => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SecondPage()),
    ),
  );
}

// Step 4: Show toast message
void _showAlertDialog(BuildContext context, String title, String msg) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            color: Colors.red,
            fontFamily: "ALike",
            fontWeight: FontWeight.w500,
          ),
        ),
        content: Text(msg),
        actions: <Widget>[
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.deepOrange),
            ),
            onPressed: () {
              // Navigator.pop(context) เป็นการถอยหลังไปหนึ่ง step
              Navigator.pop(context);
            },
            child: Text(
              "OK",
              style: TextStyle(
                fontSize: 16,
                color: Colors.amberAccent,
                fontFamily: "ALike",
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      );
    },
  );
}

// class SecondPage extends StatelessWidget {
//   const SecondPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Second Page')),
//       body: Center(
//         child: Text(
//           'Welcome to the Second Page!',
//           style: TextStyle(
//             fontSize: 30,
//             color: Colors.pinkAccent,
//             fontFamily: "ALike",
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//     );
//   }
// }

// Step 6: make a service for Firestore
class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  // Step 6: Firestore service

  // make an instance of FirestoreService
  final FirestoreService firestoreService = FirestoreService();

  // text controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // open a dialog vox to add a note
  void openPersonBox({String? personID}) async {
    if (personID != null) {
      final person = await firestoreService.getPersonById(personID);
      nameController.text = person['personName'] ?? '';
      ageController.text = person['personAge']?.toString() ?? '';
      emailController.text = person['personEmail'] ?? '';
    } else {
      nameController.clear();
      ageController.clear();
      emailController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              final name = nameController.text;
              final age = int.tryParse(ageController.text) ?? 0;
              final email = emailController.text;

              if (personID != null) {
                firestoreService.updatePerson(personID, name, age, email);
              } else {
                firestoreService.addPerson(name, age, email);
              }

              nameController.clear();
              ageController.clear();
              emailController.clear();

              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Persons List"),
        automaticallyImplyLeading: false, // เอาปุ่ม back ออก
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openPersonBox();
        },
        child: const Icon(Icons.add),
      ),
      // read function
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getPersonsStream(),
        builder: (context, snapshot) {
          // if we have data, get all the documents
          if (snapshot.hasData) {
            List personsList = snapshot.data!.docs;

            // display the notes
            return ListView.builder(
              itemCount: personsList.length,
              itemBuilder: (context, index) {
                // get each individual person document
                DocumentSnapshot document = personsList[index];
                String personID = document.id;

                // get person from each document
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String personText = data['personName'] ?? '';
                String ageText = data['personAge']?.toString() ?? '';
                String emailText = data['personEmail'] ?? '';

                // display as a list tile
                return ListTile(
                  title: Text('$personText (Age: $ageText)'),
                  subtitle: Text(emailText),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () {
                          // update function
                          openPersonBox(personID: personID);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          // delete function
                          firestoreService.deletePerson(personID);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
          // if we don't have data, return nothing
          else {
            return const Center(
              child: Text(
                "No notes available",
                style: TextStyle(fontSize: 20, color: Colors.redAccent),
              ),
            );
          }
        },
      ),
    );
  }
}
