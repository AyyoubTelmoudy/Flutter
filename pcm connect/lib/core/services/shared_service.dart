import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_flutter/screens/screens.dart';

class SharedService {
  static getBlogsList() {}
  static getBlogComments() {}
  static void logOut(BuildContext context) {
    const storage = FlutterSecureStorage();
    storage.deleteAll();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Home()),
    );
  }
}
