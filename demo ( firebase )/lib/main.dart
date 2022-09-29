import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_2/home.dart';
import 'package:flutter_app_2/register.dart';
import 'firebase_options.dart';
import 'login.dart';

Future<void> main() async {
  runApp(MaterialApp(
    initialRoute: '/login',
    routes: {
      '/login': (context) => const Login(),
      '/register': (context) => const Register(),
      '/home': (context) => const Home(),
    },
  ));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
