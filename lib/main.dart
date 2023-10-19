
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'LoginPage.dart';

import 'complains.dart';
import 'dashboard.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    final User? firebaseUser = FirebaseAuth.instance.currentUser;
    print(firebaseUser);

    Widget firstWidget;

    if (firebaseUser != null) {
      firstWidget = Dashboard();
    } else {
      firstWidget = Loginpage();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      home: firstWidget,
    );
  }


}
