import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:warranty_tracker/functions.dart';
import 'package:warranty_tracker/home.dart';
import 'package:warranty_tracker/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final auth = AuthService();
  if (auth.firebaseAuth.currentUser != null) {
    runApp(MaterialApp(
      title: 'Warranty Tracker',
      home: Home(),
    ));
  } else {
    runApp((MaterialApp(
      title: 'Warranty Tracker',
      home: Login(),
    )));
  }
}
