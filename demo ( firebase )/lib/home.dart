import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'google_maps.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text("Home"),
            ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text("Logout"))
          ],
        )),
        body: Container(
          child: const Maps(),
          alignment: Alignment.center,
        ));
  }
}
