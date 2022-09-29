import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_flutter/core/models/club_reservation.dart';
import 'package:mobile_flutter/core/services/manager_service.dart';

class ClubReservations extends StatefulWidget {
  const ClubReservations({Key? key}) : super(key: key);

  @override
  State<ClubReservations> createState() => _ClubReservationsState();
}

class _ClubReservationsState extends State<ClubReservations>
    with AutomaticKeepAliveClientMixin {
  List<ClubReservation>? reservations;
  bool loaded = false;
  bool timeOutError = false;

  @override
  void initState() {
    try {
      ManagerService.getClubReservationsList()
          .then((value) {
            if (value == null) {
              setState(() {
                timeOutError = true;
                loaded = false;
              });
            } else {
              setState(() {
                reservations = value;
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
                ? SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(10)),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(243, 19, 215, 156),
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Column(
                                  children: [
                                    const Text(
                                      "Numéro",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    for (var reservation in reservations!)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Text(
                                          reservation.num.toString(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Column(
                                  children: [
                                    const Text(
                                      "Montant (dh)",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    for (var reservation in reservations!)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Text(
                                          reservation.amount.toString(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Column(
                                  children: [
                                    const Text(
                                      "Date",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    for (var reservation in reservations!)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Text(
                                          reservation.date.toString(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Column(
                                  children: [
                                    const Text(
                                      "Email du joueur",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    for (var reservation in reservations!)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Text(
                                          reservation.playerEmail.toString(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      )
                                  ],
                                ),
                              )
                            ],
                          ),
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
