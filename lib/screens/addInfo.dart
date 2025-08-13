import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collaborative_timetable_optimizer/components/buildAlertDialog.dart';
import 'package:collaborative_timetable_optimizer/components/menubarDrawer.dart';
import 'package:collaborative_timetable_optimizer/components/roundBtn.dart';
import 'package:collaborative_timetable_optimizer/screens/editTimetable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class addInfo extends StatefulWidget {
  static String id = "addInfo";

  @override
  State<addInfo> createState() => _addInfoState();
}

class _addInfoState extends State<addInfo> {
  final _auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  int deleteWeek = 4, minute = 30;
  TimeOfDay startTime = TimeOfDay(hour: 12, minute: 0),
      endedTime = TimeOfDay(hour: 0, minute: 0);
  bool _isStartTimeSelected = false;
  List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  String startWeek = "Monday", endWeek = "Tuesday";
  String? timetableName;
  late int i;
  List<String> timetableNameList = [];
  late DateTime firstDate, endDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Timetable Information"),
      ),
      drawer: menubardrawer(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text("TimetableName: "),
                        SizedBox(
                          width: 150,
                          child: TextField(
                            onChanged: (value) {
                              timetableName = value;
                            },
                            maxLength: 50,
                            showCursor: true,
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            decoration: InputDecoration(
                              hintText: "timetable name",
                            ),
                          ),
                        )
                      ],
                    ),

                    /*
                    Row(
                      children: [
                        Text("Auto delete Week(s): "),
                        Text(deleteWeek.toString()),
                        Text(" week"),
                      ],
                    ),
                    // Row(
                    //   children: [
                    //     DateRangePickerDialog(firstDate: DateTime.now(), lastDate: DateTime(2026,6,20)),
                    //   ],
                    // ), ///wrong code
                    Row(
                      children: [
                        Slider(
                            min: 2,
                            max: 25,
                            value: deleteWeek.toDouble(),
                            onChanged: (double newWeek) {
                              setState(() {
                                deleteWeek = newWeek.round();
                              });
                            }),
                        Text("Max(25 weeks)"),
                      ],
                    ),    */
                    Row(
                      children: [
                        Text("Each grid: "),
                        Text(minute.toString()),
                        Text(" mins"),
                      ],
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: minute > 10
                              ? () {
                                  setState(() {
                                    minute -= 10;
                                  });
                                }
                              : null,
                          child: Text(
                            "-",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: minute < 180
                              ? () {
                                  setState(() {
                                    minute += 10;
                                  });
                                }
                              : null,
                          child: const Text(
                            "+",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    choosingTime("From: ", startTime, true),
                    choosingTime("To: ", endedTime, false),
                    const Row(
                      children: [
                        Text("Week"),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            DropdownButton<String>(
                              value: startWeek,
                              items: daysOfWeek
                                  .map((item) => DropdownMenuItem<String>(
                                      value: item, child: Text(item)))
                                  .toList(),
                              onChanged: (item) =>
                                  setState(() => startWeek = item!),

                              ///if extract method, setState cause infinite loop
                            ),
                            const Text(" to "),
                            DropdownButton<String>(
                              value: endWeek,
                              items: daysOfWeek
                                  .map((item) => DropdownMenuItem<String>(
                                      value: item, child: Text(item)))
                                  .toList(),
                              onChanged: (item) =>
                                  setState(() => endWeek = item!),
                            ),
                          ],
                        ),
                      ],
                    ),
                    roundBtn(
                        onPressed: () async {
                          String uid = _auth.currentUser!.uid;
                          // final addOwnTimetable =
                          await db.collection('timetable').
                          where('ownerID', isEqualTo: uid,).get()
                              .then((querySnapshot) {
                            for (var docSnapshot in querySnapshot.docs) {
                              timetableNameList.add(docSnapshot['timetableName']);
                            }
                          });
                          ///add all name to list

                          if (timetableName == null) {
                            for (i = 0; i < timetableNameList.length; i++) {
                              if (!(timetableNameList[i]
                                  .startsWith("Untitled_"))) {
                                timetableNameList.remove(timetableNameList[i]);
                              }
                            }

                            ///remove non untitled
                            ///check if previous Untitled exists
                            for (i = 0; i <= timetableNameList.length; i++) {
                              if (!(timetableNameList
                                  .contains("Untitled_${i + 1}"))) {
                                timetableName = "Untitled_${i + 1}";
                                await addDataToDB();
                                // Navigator.pushNamed(context, table.id);
                                // break; // end for loop
                              }
                            }
                          } else if (!(timetableNameList
                              .contains(timetableName))) {
                            print(timetableNameList);
                            await addDataToDB();
                            // Navigator.pushNamed(context, table.id);
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => buildAlertDialog(
                                  context,
                                  newIcons: Icons.info,
                                  newColor: Colors.blue,
                                  newMessage:
                                      "This name is used. Please rename it or remain empty."),
                            );
                          }
                          print(timetableName);
                        },
                        borderRadius: 20,
                        newMinWidth: 80,
                        label: "Create",
                        buttonColor: Colors.lightBlueAccent
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addDataToDB() async {
    try {
      String uid = _auth.currentUser!.uid;

      ///add data to db
      final data = {
        'timetableName': timetableName,
        'startTime': startTime.toString(),
        'endTime': endedTime.toString(),
        'interval': minute,
        'deleteWeek': deleteWeek,
        'ownerID': uid,
        'Start Week': startWeek,
        'End Week': endWeek,
        'last Modified': FieldValue.serverTimestamp(),
      };
      DocumentReference documentReference =
          await db.collection('timetable').add(data);
      var documentId = [documentReference.id];
      await db.collection('users').doc(uid).update({
        'ownedTimetable': FieldValue.arrayUnion(documentId),
      });
      //TODO: create collections for all day in timetable
      // db.collection('')
      Navigator.pushNamed(context, editTimetable.id);
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> _chooseTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (_isStartTimeSelected) {
      if (picked != null && picked != startTime) {
        setState(() {
          int adjustedMinute = (picked.minute / 10).round() * 10;
          startTime = TimeOfDay(hour: picked.hour, minute: adjustedMinute);
        });
      }
    } else {
      if (picked != null && picked != endedTime) {
        setState(() {
          int adjustedMinute = (picked.minute / 10).round() * 10;
          endedTime = TimeOfDay(hour: picked.hour, minute: adjustedMinute);
        });
      }
    }
    _isStartTimeSelected = false;
  }

  Row choosingTime(
      String chooseTimeHint, TimeOfDay thatTime, bool startTimeSelected) {
    return Row(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$chooseTimeHint ${thatTime.format(context)}',
            ),
            SizedBox(
              width: 20,
            ),
            ElevatedButton(
              onPressed: () {
                _isStartTimeSelected = startTimeSelected;
                _chooseTime();
              },
              child: const Text('Select Time'),
            ),
          ],
        ),
      ],
    );
  }
}
