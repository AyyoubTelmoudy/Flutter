import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_flutter/core/models/models.dart';
import 'package:mobile_flutter/core/services/player_service.dart';

class ReservationsHisotry extends StatefulWidget {
  const ReservationsHisotry({Key? key}) : super(key: key);

  @override
  State<ReservationsHisotry> createState() => _ReservationsHisotryState();
}

class _ReservationsHisotryState extends State<ReservationsHisotry>
    with AutomaticKeepAliveClientMixin {
  List<ReservationInfo>? reservations;
  bool loaded = false;
  bool timeOutError = false;

  @override
  void initState() {
    try {
      PlayerService.getReservationsList()
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
      rethrow;
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
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Column(
                                children: [
                                  const Text(
                                    "Numéro",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  for (var reservation in reservations!)
                                    Text(
                                      reservation.num.toString(),
                                      style:
                                          const TextStyle(color: Colors.white),
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
                                    Text(
                                      reservation.amount.toString(),
                                      style:
                                          const TextStyle(color: Colors.white),
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
                                    Text(
                                      reservation.date.toString(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Column(
                                children: [
                                  const Text(
                                    "Club",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  for (var reservation in reservations!)
                                    Text(
                                      reservation.clubName.toString(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )
                                ],
                              ),
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
