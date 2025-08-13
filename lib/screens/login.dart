import 'package:collaborative_timetable_optimizer/components/roundBtn.dart';
import 'package:collaborative_timetable_optimizer/screens/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static String id= 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? email, password;
  final _auth = FirebaseAuth.instance;
  bool _obscureText = true;

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 90,
                ),
                SizedBox(
                  height: 110,
                  child: Column(
                    children: [
                      TextField(
                        onChanged: (value){
                          email = value;
                        },
                        onTapOutside: (event) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        decoration: const InputDecoration(
                            hintText: 'Enter your email'
                        ),
                      ),
                      TextField(
                        onChanged: (value){
                          password = value;
                        },
                        decoration: InputDecoration(
                            hintText: 'Enter your password',
                            suffixIcon: IconButton(
                                onPressed: (){
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                icon: Icon(
                                    _obscureText ? Icons.visibility : Icons.visibility_off,
                                ),
                            ),
                        ),
                        obscureText: _obscureText,
                      ),
                    ],
                  ),
                ),
                roundBtn(
                  onPressed: () async {
                    try{
                      var userLoggedIn = await _auth.signInWithEmailAndPassword(email: email!, password: password!);
                      Navigator.pushReplacementNamed(context, Dashboard.id);
                    }on FirebaseAuthException catch (e){
                      String message;
                      switch (e.code){
                        case 'user-disabled':
                          message = 'the user is disabled';
                          break;
                        case 'invalid-credential':
                          message = "the email or password is incorrect";
                          break;
                        default:
                          message = "unexpected error occured";
                          break;
                      }
                      showDialog(
                          context: context,
                          builder: (BuildContext context){
                            return AlertDialog(
                                icon: Icon(Icons.info),
                                content: Text(message),
                                actions: <Widget>[
                                  TextButton(
                                      onPressed: Navigator.of(context).pop,
                                      child: const Text("ok"),
                                  ),
                                ],
                            );
                          }
                      );
                    }
                  },
                  label: "login",
                  buttonColor: Colors.blue,
                  newMinWidth: 70,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
