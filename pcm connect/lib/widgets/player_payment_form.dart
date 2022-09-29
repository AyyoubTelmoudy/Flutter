// ignore_for_file: no_logic_in_create_state

import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_flutter/core/api/api.dart';
import 'package:mobile_flutter/core/http/http_client.dart';

class PlayerPaymentForm extends StatefulWidget {
  const PlayerPaymentForm({
    Key? key,
    required this.reservation,
  }) : super(key: key);
  final String reservation;

  @override
  State<PlayerPaymentForm> createState() =>
      _PlayerPaymentFormState(reservation);
}

class _PlayerPaymentFormState extends State<PlayerPaymentForm>
    with AutomaticKeepAliveClientMixin {
  final _paymentFormKey = GlobalKey<FormState>();
  final String reservation;
  String backEndMessage = "";
  String creditNumber = "";
  String expirationMonth = "";
  String expirationYear = "";
  String cvc = "";
  bool loading = false;
  bool internetConn = false;
  _PlayerPaymentFormState(this.reservation);
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Form(
      key: _paymentFormKey,
      child: SafeArea(
        child: Center(
            child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Numéro de Carte',
                    ),
                    onChanged: (val) {
                      setState(() {});
                    },
                    validator: (val) {
                      return val!.isEmpty ? 'Ce champ est obligatoire' : null;
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'August',
                          ),
                          onChanged: (val) {
                            setState(() {
                              expirationMonth = val;
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
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 25),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '2023',
                          ),
                          onChanged: (val) {
                            setState(() {
                              expirationYear = val;
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
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'CVS/CW',
                    ),
                    onChanged: (val) {
                      setState(() {
                        expirationYear = val;
                      });
                    },
                    validator: (val) {
                      return val!.isEmpty ? 'Ce champ est obligatoire' : null;
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            backEndMessage.isNotEmpty
                ? Text(backEndMessage)
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
            ElevatedButton(
                onPressed: () async {
                  if (_paymentFormKey.currentState!.validate()) {
                    _confirmReservation(reservation);
                  }
                },
                child: loading
                    ? const SpinKitRing(
                        color: Colors.white,
                        size: 25,
                      )
                    : const Text("confirmer")),
          ],
        )),
      ),
    );
  }

  _confirmReservation(String reservation) async {
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
        _paymentFormKey.currentState!.reset();
        setState(() {
          internetConn = false;
          loading = false;
          backEndMessage = jsonResponse['message'];
        });
      } else {
        setState(() {
          internetConn = false;
          loading = false;
          backEndMessage = jsonResponse['error'];
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
