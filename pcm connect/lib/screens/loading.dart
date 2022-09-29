import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_flutter/core/constant/constnats.dart';
import 'package:mobile_flutter/screens/home.dart';
import 'package:mobile_flutter/screens/manager_reservation.dart';
import 'package:mobile_flutter/screens/player_reservation.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with AutomaticKeepAliveClientMixin {
  bool isLoading = true;
  bool isManager = true;
  bool isAuthenticated = false;

  @override
  void initState() {
    checkUserAuthentication();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return isLoading
        ? Scaffold(
            body: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(color: Colors.white),
              child: Center(
                child: Container(
                  height: 100,
                  width: 100,
                  child: const CircleAvatar(
                    backgroundImage: AssetImage("assets/images/logo.jpeg"),
                  ),
                ),
              ),
            ),
          )
        : Container(
            child: isAuthenticated
                ? Container(
                    child: isManager
                        ? const ManagerReservation()
                        : const PlayerReservation(),
                  )
                : const Home(),
          );
  }

  Future<void> checkUserAuthentication() async {
    const storage = FlutterSecureStorage();
    await storage.read(key: ROLE).then((role) {
      if (role == null) {
        setState(() {
          isLoading = false;
          isManager = true;
          isAuthenticated = false;
        });
      } else {
        if (role == PLAYER_ROLE) {
          setState(() {
            isLoading = false;
            isManager = false;
            isAuthenticated = true;
          });
        } else {
          setState(() {
            isLoading = false;
            isManager = true;
            isAuthenticated = true;
          });
        }
      }
    });
  }

  @override
  bool get wantKeepAlive => false;
}
