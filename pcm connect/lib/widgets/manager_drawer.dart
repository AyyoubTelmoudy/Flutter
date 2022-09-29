import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_flutter/core/models/manager_info.dart';
import 'package:mobile_flutter/core/services/manager_service.dart';
import 'package:mobile_flutter/screens/manager_reservation.dart';
import 'package:mobile_flutter/screens/screens.dart';
import 'package:mobile_flutter/screens/stadiums.dart';

class ManagerDrawer extends StatefulWidget {
  const ManagerDrawer({Key? key}) : super(key: key);

  @override
  State<ManagerDrawer> createState() => _ManagerDrawerState();
}

class _ManagerDrawerState extends State<ManagerDrawer>
    with AutomaticKeepAliveClientMixin {
  ManagerInfo? managerInfo;
  bool timeOutError = false;
  bool loading = false;

  @override
  void initState() {
    setState(() {
      loading = true;
      timeOutError = false;
    });
    try {
      ManagerService.getManagerInfo()
          .then((value) {
            if (value == null) {
              setState(() {
                loading = false;
                timeOutError = true;
              });
            } else {
              setState(() {
                managerInfo = value;
                loading = false;
                timeOutError = false;
              });
            }
          })
          .timeout(const Duration(seconds: 30))
          .onError((error, stackTrace) {
            setState(() {
              loading = false;
              timeOutError = true;
            });
          });
    } catch (e, s) {
      setState(() {
        loading = false;
        timeOutError = true;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Drawer(
        child: SafeArea(
      child: timeOutError
          ? const Text("Vérifiez votre connection internet !")
          : Container(
              child: loading
                  ? const SpinKitRing(
                      color: Color.fromARGB(243, 19, 215, 156),
                      size: 25,
                    )
                  : ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        UserAccountsDrawerHeader(
                          accountName: Text(
                              "${managerInfo!.firstName} ${managerInfo!.lastName}"),
                          accountEmail: Text(managerInfo!.email!),
                          currentAccountPicture: CircleAvatar(
                            child: ClipOval(
                              child: Image.asset(
                                "assets/images/profil1.jpeg",
                                fit: BoxFit.cover,
                                height: 100,
                                width: 100,
                              ),
                            ),
                          ),
                          decoration: const BoxDecoration(
                              color: Colors.blue,
                              image: DecorationImage(
                                  image:
                                      AssetImage("assets/images/profile2.jpeg"),
                                  fit: BoxFit.cover)),
                        ),
                        ListTile(
                          leading: const Text("Club : "),
                          title: Text(managerInfo!.clubName!),
                        ),
                        ListTile(
                          leading: const Icon(Icons.book_online),
                          title: const Text("Réservations"),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ManagerReservation()),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.group),
                          title: const Text("Communauté"),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ManagerCommunity()),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.stadium),
                          title: const Text("Terrains"),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Stadiums()),
                            );
                          },
                        )
                      ],
                    ),
            ),
    ));
  }

  @override
  bool get wantKeepAlive => false;
}
