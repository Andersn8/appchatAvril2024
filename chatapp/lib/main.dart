// ignore_for_file: prefer_final_fields, unused_field, prefer_const_constructors

import 'package:chatapp/Helper/Helper_function.dart';
import 'package:chatapp/Pages/auth/login_page.dart';
import 'package:chatapp/Pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSingnedIn = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    // ici on recupere le satut de connexion et avec le if on verifie s'il est null ou pa
    return await HelperFunctions.getUserLoggedInStatus().then((value) => {
          if (value != null) {_isSingnedIn = value}
        });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: _isSingnedIn ? HomePage() : LoginPage(),
    );
  }
}
