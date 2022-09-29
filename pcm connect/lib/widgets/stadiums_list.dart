import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_flutter/core/models/stadium_info.dart';
import 'package:mobile_flutter/core/services/manager_service.dart';

class StadiumsList extends StatefulWidget {
  const StadiumsList({Key? key}) : super(key: key);

  @override
  State<StadiumsList> createState() => _StadiumsListState();
}

class _StadiumsListState extends State<StadiumsList>
    with AutomaticKeepAliveClientMixin {
  List<StadiumInfo>? stadiums;
  bool loaded = false;
  bool timeOutError = false;
  @override
  void initState() {
    try {
      ManagerService.getClubStadiumsList()
          .then((value) {
            if (value == null) {
              setState(() {
                timeOutError = true;
                loaded = false;
              });
            } else {
              setState(() {
                stadiums = value;
                loaded = true;
                timeOutError = false;
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
    return timeOutError
        ? const Text("Vérifiez votre connection internet !")
        : Container(
            child: loaded
                ? Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(10)),
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(243, 19, 215, 156),
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                const Text(
                                  "Numéro",
                                  style: TextStyle(color: Colors.white),
                                ),
                                for (var stadium in stadiums!)
                                  Text(
                                    stadium.num.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  )
                              ],
                            ),
                            Column(
                              children: [
                                const Text(
                                  "Taille",
                                  style: TextStyle(color: Colors.white),
                                ),
                                for (var stadium in stadiums!)
                                  Text(
                                    stadium.size.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : const SpinKitRing(
                    color: Color.fromARGB(243, 19, 215, 156),
                    size: 25,
                  ),
          );
  }

  @override
  bool get wantKeepAlive => false;
}
