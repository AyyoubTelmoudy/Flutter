import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_flutter/core/api/api.dart';
import 'package:mobile_flutter/core/http/http_client.dart';
import 'package:mobile_flutter/core/models/club.dart';
import 'package:mobile_flutter/core/services/player_service.dart';
import 'package:mobile_flutter/core/utils/utils.dart';
import 'package:mobile_flutter/widgets/player_payment_form.dart';
import 'dart:convert' as convert;

class PlayerGameReservationForm extends StatefulWidget {
  const PlayerGameReservationForm({Key? key}) : super(key: key);

  @override
  State<PlayerGameReservationForm> createState() =>
      _PlayerGameReservationFormState();
}

class _PlayerGameReservationFormState extends State<PlayerGameReservationForm>
    with AutomaticKeepAliveClientMixin {
  final _reservationFormKey = GlobalKey<FormState>();
  bool loaded = false;
  List<ClubIfo>? clubs;
  String size = "1x1";
  TimeOfDay selectedStartTime = TimeOfDay.now();
  TimeOfDay selectedEndTime = TimeOfDay.now();
  String? clubName;
  DateTime selectedDate = DateTime.now();
  String backEndMessage = "";
  bool checked = false;
  bool toPay = false;
  bool loading = false;
  bool internetConn = false;
  bool timeOutError = false;
  @override
  void initState() {
    try {
      PlayerService.getClubsList()
          .then((value) {
            if (value == null) {
              setState(() {
                timeOutError = true;
                loaded = false;
              });
            } else {
              setState(() {
                clubs = value;
                loaded = true;
                clubName = clubs?.elementAt(0).name;
              });
            }
          })
          .timeout(const Duration(seconds: 30))
          .onError((error, stackTrace) {
            setState(() {
              timeOutError = true;
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
        : loaded
            ? toPay
                ? PlayerPaymentForm(
                    reservation: Utils.toPlayerGameReservation(
                        selectedDate,
                        size,
                        clubName!,
                        false,
                        selectedStartTime,
                        selectedEndTime),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Form(
                      key: _reservationFormKey,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ElevatedButton(
                              onPressed: () {
                                _selectDate(context);
                              },
                              child: const Text("Date"),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12)),
                            child: Text(
                                "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}"),
                          ),
                          const Divider(),
                          Container(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ElevatedButton(
                              onPressed: () {
                                _selectStartTime(context);
                              },
                              child: const Text("Heure de début"),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12)),
                            child: Text(
                                "${selectedStartTime.hour}:${selectedStartTime.minute}"),
                          ),
                          const Divider(),
                          Container(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ElevatedButton(
                              onPressed: () {
                                _selectEndTime(context);
                              },
                              child: const Text("Heure de fin"),
                            ),
                          ),
                          Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12)),
                              child: Text(
                                  "${selectedEndTime.hour}:${selectedEndTime.minute}")),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 25, right: 25, bottom: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(12)),
                              child: const Padding(
                                padding: EdgeInsets.all(5),
                                child: Text("Taille du terrain"),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12)),
                            child: DropdownButton(
                                borderRadius: BorderRadius.circular(12),
                                items: const [
                                  DropdownMenuItem(
                                    child: Text("1x1"),
                                    value: "1x1",
                                  ),
                                  DropdownMenuItem(
                                    child: Text("2x2"),
                                    value: "2x2",
                                  )
                                ],
                                value: size,
                                icon: const Icon(Icons.arrow_drop_down),
                                iconSize: 42,
                                underline: const SizedBox(),
                                onChanged: (String? selectedValue) {
                                  setState(() {
                                    size = selectedValue!;
                                  });
                                }),
                          ),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 25, right: 25, bottom: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(12)),
                              child: const Padding(
                                padding: EdgeInsets.all(5),
                                child: Text("Club"),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12)),
                            child: DropdownButton(
                                borderRadius: BorderRadius.circular(12),
                                items: [
                                  for (var club in clubs!)
                                    DropdownMenuItem(
                                      child: Text(club.name!),
                                      value: club.name,
                                    )
                                ],
                                value: clubName,
                                icon: const Icon(Icons.arrow_drop_down),
                                iconSize: 42,
                                underline: const SizedBox(),
                                onChanged: (String? selectedValue) {
                                  setState(() {
                                    clubName = selectedValue!;
                                  });
                                }),
                          ),
                          const Divider(),
                          backEndMessage.isNotEmpty
                              ? Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(backEndMessage)
                                  ],
                                )
                              : const SizedBox.shrink(),
                          internetConn
                              ? Column(
                                  children: const [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                        "Vérifiez votre connection internet !"),
                                  ],
                                )
                              : const SizedBox.shrink(),
                          const SizedBox(
                            height: 10,
                          ),
                          checked
                              ? ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      toPay = true;
                                    });
                                  },
                                  child: const Text("suivant"))
                              : ElevatedButton(
                                  onPressed: () {
                                    String reservation =
                                        Utils.toPlayerGameReservation(
                                            selectedDate,
                                            size,
                                            clubName!,
                                            true,
                                            selectedStartTime,
                                            selectedEndTime);
                                    _checkAvailability(reservation);
                                  },
                                  child: loading
                                      ? const SpinKitRing(
                                          color: Colors.white,
                                          size: 25,
                                        )
                                      : const Text(
                                          "Verifier la disponibilité")),
                        ],
                      ),
                    ),
                  )
            : const SpinKitRing(
                color: Color.fromARGB(243, 19, 215, 156),
                size: 25,
              );
  }

  _selectStartTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedStartTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedStartTime) {
      setState(() {
        selectedStartTime = timeOfDay;
      });
    }
  }

  _selectEndTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedEndTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedEndTime) {
      setState(() {
        selectedEndTime = timeOfDay;
      });
    }
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }
  }

  _checkAvailability(String reservation) async {
    setState(() {
      loading = true;
      internetConn = false;
    });
    try {
      final response =
          await HttpClient.post_(PlayerAPI.RESERVE_GAME, body: reservation)
              .timeout(const Duration(seconds: 30));
      final jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 202) {
        setState(() {
          backEndMessage = jsonResponse['message'];
          checked = true;
          loading = false;
          internetConn = false;
        });
      } else {
        setState(() {
          backEndMessage = jsonResponse['error'];
          loading = false;
          internetConn = false;
        });
      }
    } catch (e, s) {
      setState(() {
        internetConn = true;
        loading = false;
        backEndMessage = "";
      });
    }
  }

  @override
  bool get wantKeepAlive => false;
}
