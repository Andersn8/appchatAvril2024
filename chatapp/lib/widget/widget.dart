// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

const TextFormfieldStyle = InputDecoration(
  labelStyle: TextStyle(color: Colors.black),
  border: OutlineInputBorder(),
  enabledBorder:
      OutlineInputBorder(borderSide: BorderSide(color: Colors.deepOrange)),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color.fromARGB(176, 1, 53, 165))),
  errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color.fromARGB(255, 255, 94, 30))),
);

void nextscreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextscreenReplace(context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}

void showSnackbar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontSize: 14),
      ),
      backgroundColor: color,
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: "ok",
        onPressed: () {},
        textColor: const Color.fromARGB(255, 255, 255, 255),
      )));
}
