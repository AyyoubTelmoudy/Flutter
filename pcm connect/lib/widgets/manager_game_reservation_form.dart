import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_flutter/core/api/api.dart';
import 'package:mobile_flutter/core/http/http_client.dart';
import 'package:mobile_flutter/core/utils/utils.dart';
import 'package:mobile_flutter/widgets/manager_payment_form.dart';

class ManagerGameReservationForm extends StatefulWidget {
  const ManagerGameReservationForm({Key? key}) : super(key: key);

  @override
  State<ManagerGameReservationForm> createState() =>
      _ManagerGameReservationFormState();
}

class _ManagerGameReservationFormState extends State<ManagerGameReservationForm>
    with AutomaticKeepAliveClientMixin {
  final _reservationFormKey = GlobalKey<FormState>();
  String size = "1x1";
  TimeOfDay selectedStartTime = TimeOfDay.now();
  TimeOfDay selectedEndTime = TimeOfDay.now();
  String? playerEmail;
  DateTime selectedDate = DateTime.now();
  String backEndMessage = "";
  bool checked = false;
  bool toPay = false;
  bool internetConn = false;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return toPay
        ? ManagerPaymentForm(
            reservation: Utils.toManagerGameReservation(selectedDate, size,
                playerEmail!, false, selectedStartTime, selectedEndTime),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Form(
              key: _reservationFormKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.only(left: 20),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email du joueur',
                        ),
                        onChanged: (val) {
                          setState(() {
                            playerEmail = val;
                          });
                        },
                        validator: (val) {
                          return val!.isEmpty
                              ? 'Ce champ est obligatoire'
                              : null;
                        },
                      ),
                    ),
                  ),
                  const Divider(),
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
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12)),
                      child: Text(
                          "${selectedEndTime.hour}:${selectedEndTime.minute}")),
                  const Divider(),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 25, right: 25, bottom: 10),
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
                            Text("Vérifiez votre connection internet !"),
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
                            if (_reservationFormKey.currentState!.validate()) {
                              String reservation =
                                  Utils.toManagerGameReservation(
                                      selectedDate,
                                      size,
                                      playerEmail!,
                                      true,
                                      selectedStartTime,
                                      selectedEndTime);
                              _checkAvailability(reservation);
                            }
                          },
                          child: loading
                              ? const SpinKitRing(
                                  color: Colors.white,
                                  size: 25,
                                )
                              : const Text("Verifier la disponibilité")),
                ],
              ),
            ),
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
          await HttpClient.post_(ManagerAPI.RESERVE_GAME, body: reservation)
              .timeout(const Duration(seconds: 30));
      final jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 202) {
        setState(() {
          backEndMessage = jsonResponse['message'];
          checked = true;
          internetConn = false;
          loading = false;
        });
      } else {
        if ((jsonResponse['email'] as String?) != null) {
          setState(() {
            backEndMessage = jsonResponse['email'];
            internetConn = false;
            loading = false;
          });
        }
        if ((jsonResponse['error'] as String?) != null) {
          setState(() {
            backEndMessage = jsonResponse['error'];
            internetConn = false;
            loading = false;
          });
        }
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
