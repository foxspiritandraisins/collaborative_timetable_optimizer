import 'package:collaborative_timetable_optimizer/components/buildAlertDialog.dart';
import 'package:collaborative_timetable_optimizer/components/roundBtn.dart';
import 'package:collaborative_timetable_optimizer/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class registration extends StatefulWidget {
  static String id = 'register';

  @override
  State<registration> createState() => _registrationState();
}

class _registrationState extends State<registration> {
  String? firstName, lastName, email, password;
  final _auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      firstName = value;
                    },
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                        hintText: 'first name',
                        hintStyle: TextStyle(color: Colors.black)),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      lastName = value;
                    },
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    decoration: InputDecoration(hintText: 'Last name'),
                  ),
                )
              ],
            ),
            TextField(
              onChanged: (value) {
                email = value;
              },
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              decoration: InputDecoration(hintText: 'email'),
            ),
            TextField(
              onChanged: (value) {
                password = value;
              },
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              obscureText: true,
              decoration: InputDecoration(hintText: 'password'),
            ),
            roundBtn(
              onPressed: () async {
                if (firstName != (null) && lastName != null) {
                  try {
                    var userCredential =
                        await _auth.createUserWithEmailAndPassword(
                            email: email!, password: password!);

                    String uid = userCredential.user!.uid;
                    List<String> ownedTimetable = [],
                        sharedTimetable = [];
                    final userDetail = {
                      "Firstname": firstName!,
                      "Lastname": lastName!,
                      "lastModified": FieldValue.serverTimestamp(),
                      'ownedTimetable': ownedTimetable,
                      'sharedTimetable': sharedTimetable,
                    };
                    // db.collection('users').add(userDetail);
                    DocumentSnapshot docID =
                        await db.collection('users').doc(uid).get();
                    // db.collection("users").where("uid", "==", "");
                    if (!(docID.exists)) {
                      db.collection('users').doc(uid).set(userDetail);
                    }
                    // db.doc('cqHKvhhl7aGRE6Pw4l0T').collection('users').doc('$uid').set(userDetail);
                    Navigator.pushNamed(context, LoginScreen.id);
                  } catch (e) {
                    print(e);
                  }
                } else {
                  if (!(firstName != (null) || lastName != null)) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          buildAlertDialog(
                              context, newIcons: Icons.warning,
                              newColor: Colors.red,
                              newMessage: "Firstname and Lastname must be filled in"
                          ),
                    );
                  }
                }
              },
              label: "Register",
              buttonColor: Colors.blue,
            ),
          ]),
        ),
      ),
    );
  }
}
