// ignore_for_file: prefer_const_declarations, no_leading_underscores_for_local_identifiers, prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, unused_element, unused_field, non_constant_identifier_names

import 'package:chatapp/Helper/Helper_function.dart';
import 'package:chatapp/Pages/auth/register_page.dart';
import 'package:chatapp/Pages/home_page.dart';
import 'package:chatapp/service/auth_service.dart';
import 'package:chatapp/service/database_service.dart';
import 'package:chatapp/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  AuthService authService = AuthService();
  final _taille = 15.0;
  final _Formkey = GlobalKey<FormState>();
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(backgroundColor: Color.fromARGB(255, 255, 94, 30)),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Form(
              key: _Formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "My chat",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    "Login in my chat app and enjoy well",
                    textAlign: TextAlign.center,
                  ),
                  Image.asset("assets/login.png"),
                  TextFormField(
                    decoration: TextFormfieldStyle.copyWith(
                        labelText: "Email",
                        prefixIcon: Icon(
                          Icons.mail,
                          color: Color.fromARGB(255, 255, 94, 30),
                        )),
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    },
                    validator: (String? _email) {
                      const pattern =
                          r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
                          r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
                          r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
                          r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
                          r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
                          r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
                          r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
                      final regex = RegExp(pattern);

                      return _email!.isNotEmpty && !regex.hasMatch(_email)
                          ? 'Enter a valid email address'
                          : null;
                    },
                  ),
                  SizedBox(
                    height: _taille,
                  ),
                  TextFormField(
                    decoration: TextFormfieldStyle.copyWith(
                        labelText: "Password",
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Color.fromARGB(255, 255, 94, 30),
                        )),
                    onChanged: (val) {
                      setState(() {
                        password = val;
                      });
                    },
                    validator: (value) {
                      if (value!.length < 6) {
                        return "le mot de passe doit avoir au moins 6 caractères";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: _taille,
                  ),
                  Container(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  Color.fromARGB(255, 255, 94, 30)),
                          onPressed: () {
                            login();
                          },
                          child: Text("Sign in"))),
                  SizedBox(
                    height: 10,
                  ),
                  Text.rich((TextSpan(
                      text: "Don't have an account  ",
                      style: const TextStyle(color: Colors.black, fontSize: 15),
                      children: <TextSpan>[
                        TextSpan(
                            text: "  Register here",
                            style: const TextStyle(
                                color: Color.fromARGB(255, 11, 109, 255),
                                decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                nextscreen(context, RegisterPage());
                              })
                      ]))),
                ],
              )),
        ),
      ),
    );
  }

  login() async {
    if (_Formkey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .loginUserWithEmailandPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);
          // saving the values to our shared preferences
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailsf(email);
          await HelperFunctions.saveUserNamesf(snapshot.docs[0]['fullName']);
          // ignore: use_build_context_synchronously
          nextscreenReplace(context, const HomePage());
        } else {
          showSnackbar(context, const Color.fromARGB(255, 255, 94, 30), value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
