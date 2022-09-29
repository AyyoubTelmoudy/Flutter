import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_flutter/core/models/models.dart';
import 'package:mobile_flutter/core/services/player_service.dart';
import 'package:mobile_flutter/core/utils/utils.dart';
import 'package:mobile_flutter/widgets/widgets.dart';

class Clubs extends StatefulWidget {
  const Clubs({
    Key? key,
  }) : super(key: key);

  @override
  State<Clubs> createState() => _ClubsState();
}

class _ClubsState extends State<Clubs> with AutomaticKeepAliveClientMixin {
  List<ClubIfo> clubs = <ClubIfo>[];
  List<ClubIfo> foundClubs = <ClubIfo>[];
  bool loaded = false;
  bool timeOutError = false;
  _ClubsState();
  @override
  void initState() {
    try {
      PlayerService.getClubsList().then((value) {
        if (value == null) {
          setState(() {
            timeOutError = true;
            loaded = false;
          });
        } else {
          setState(() {
            clubs = value;
            foundClubs = value;
            loaded = true;
          });
        }
      }).timeout(const Duration(seconds: 30));
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: const [
          IconButton(onPressed: Utils.logOut, icon: Icon(Icons.logout))
        ],
        title: const Text("PCM Connect"),
      ),
      body: SingleChildScrollView(
        child: timeOutError
            ? const Center(
                child: Text("Vérifiez votre connection internet !"),
              )
            : Center(
                child: loaded
                    ? Column(
                        children: [
                          Container(
                            color: const Color.fromARGB(243, 19, 215, 156),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: TextField(
                                style: const TextStyle(color: Colors.white),
                                onChanged: (value) => _runFilter(value),
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Rechercher',
                                    hintStyle: TextStyle(color: Colors.white),
                                    labelStyle: TextStyle(color: Colors.white),
                                    suffixIcon: Icon(
                                      Icons.search,
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            child: foundClubs.isNotEmpty
                                ? Column(
                                    children: [
                                      for (var club in foundClubs)
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.black12,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                    243, 19, 215, 156),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: ListTile(
                                              leading: Text(
                                                club.name.toString(),
                                                style: const TextStyle(
                                                    fontSize: 24,
                                                    color: Colors.white),
                                              ),
                                              title: Text(club.email!,
                                                  style: const TextStyle(
                                                      color: Colors.white)),
                                              subtitle: Text(
                                                  club.phone.toString(),
                                                  style: const TextStyle(
                                                      color: Colors.white)),
                                            ),
                                          ),
                                        )
                                    ],
                                  )
                                : const Text(
                                    'Club introuvable',
                                    style: TextStyle(
                                        fontSize: 24,
                                        color:
                                            Color.fromARGB(243, 19, 215, 156)),
                                  ),
                          ),
                        ],
                      )
                    : const SpinKitRing(
                        color: Color.fromARGB(243, 19, 215, 156)),
              ),
      ),
      drawer: const PlayerDrawer(),
    );
  }

  void _runFilter(String enteredKeyword) {
    List<ClubIfo> results = [];
    if (enteredKeyword.isEmpty) {
      results = clubs;
    } else {
      results = clubs
          .where((clubIfo) => clubIfo.name!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      foundClubs = results;
    });
  }

  @override
  bool get wantKeepAlive => false;
}
