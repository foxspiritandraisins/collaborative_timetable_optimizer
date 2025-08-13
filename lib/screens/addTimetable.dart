import 'package:collaborative_timetable_optimizer/components/menubarDrawer.dart';
import 'package:collaborative_timetable_optimizer/components/roundBtn.dart';
import 'package:collaborative_timetable_optimizer/screens/addInfo.dart';
import 'package:flutter/material.dart';

class addTimetable extends StatelessWidget {
  static String id = "add";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose method"),
      ),
      drawer: menubardrawer(),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 280,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Create timetable by:-"),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      roundBtn(
                        onPressed: () => Navigator.pushNamed(context, addInfo.id),
                        newMinWidth: 130,
                        borderRadius: 15,
                        label: "I want to type it",
                        buttonColor: Colors.white
                      ),
                      // buildRoundButton(
                      //     context,
                      //     Navigator.pushNamed(context, addInfo.id),
                      //     "I want to type it"),
                      // buildRoundButton(context, null, "Image/PDF"),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

/*  roundBtn buildRoundButton(
      BuildContext context, var onPressed, String buttonText) {
    return roundBtn(
        onPressed: onPressed,
        newMinWidth: 130,
        borderRadius: 15,
        label: buttonText,
        buttonColor: Colors.white);
  }     */
}
