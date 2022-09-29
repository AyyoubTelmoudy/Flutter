import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_flutter/core/models/player_info.dart';
import 'package:mobile_flutter/core/services/player_service.dart';
import 'package:mobile_flutter/screens/screens.dart';

class PlayerDrawer extends StatefulWidget {
  const PlayerDrawer({Key? key}) : super(key: key);

  @override
  State<PlayerDrawer> createState() => _PlayerDrawerState();
}

class _PlayerDrawerState extends State<PlayerDrawer>
    with AutomaticKeepAliveClientMixin {
  bool timeOutError = false;
  PlayerInfo? playerInfo;
  bool loaded = false;
  @override
  void initState() {
    try {
      PlayerService.getPlayerInfo()
          .then((value) {
            if (value == null) {
              setState(() {
                timeOutError = true;
                loaded = false;
              });
            } else {
              setState(() {
                playerInfo = value;
                timeOutError = false;
                loaded = true;
              });
            }
          })
          .timeout(const Duration(seconds: 30))
          .onError((error, stackTrace) {
            setState(() {
              timeOutError = true;
              loaded = false;
            });
          });
    } catch (e, s) {
      setState(() {
        timeOutError = true;
        loaded = false;
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
                    child: loaded
                        ? ListView(
                            padding: EdgeInsets.zero,
                            children: [
                              UserAccountsDrawerHeader(
                                accountName: Text(
                                    "${playerInfo!.firstName} ${playerInfo!.lastName}"),
                                accountEmail: Text(playerInfo!.email!),
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
                                        image: AssetImage(
                                            "assets/images/profile2.jpeg"),
                                        fit: BoxFit.cover)),
                              ),
                              ListTile(
                                leading: const Text("Niveau : "),
                                title: Text(playerInfo!.level!),
                              ),
                              ListTile(
                                leading: const Icon(Icons.book_online),
                                title: const Text("Reservations"),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const PlayerReservation()),
                                  );
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.business),
                                title: const Text("Clubs"),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Clubs()),
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
                                            const PlayerCommunity()),
                                  );
                                },
                              )
                            ],
                          )
                        : const SpinKitRing(
                            color: Color.fromARGB(243, 19, 215, 156),
                            size: 25,
                          ),
                  )));
  }

  @override
  bool get wantKeepAlive => false;
}
