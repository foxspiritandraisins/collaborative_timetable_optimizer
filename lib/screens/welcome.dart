import 'package:collaborative_timetable_optimizer/screens/login.dart';
import 'package:collaborative_timetable_optimizer/screens/registration.dart';
import 'package:flutter/material.dart';
import 'package:collaborative_timetable_optimizer/components/roundBtn.dart';

class WelcomeScreen extends StatelessWidget {
  static String id = 'welcomeScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 200,
          width: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: 80,
              ),
              roundBtn(
                  label: 'login',
                  buttonColor: Colors.blue,
                  newMinWidth: 90,
                  onPressed: () {
                    Navigator.pushNamed(context, LoginScreen.id);
                  }),
              roundBtn(
                  onPressed: () {
                    Navigator.pushNamed(context, registration.id);
                  },
                  label: 'register',
                  buttonColor: Colors.blue,
                newMinWidth: 90,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
