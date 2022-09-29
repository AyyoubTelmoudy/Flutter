import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_flutter/core/api/api.dart';
import 'package:mobile_flutter/core/http/http_client.dart';
import 'dart:convert' as convert;

class AddStadium extends StatefulWidget {
  const AddStadium({Key? key}) : super(key: key);

  @override
  State<AddStadium> createState() => _AddStadiumState();
}

class _AddStadiumState extends State<AddStadium>
    with AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();
  String size = "1x1";
  int? number;
  String backendMessage = "";
  bool timeOutError = false;
  bool loading = false;
  bool notValidNumber = false;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
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
                padding: const EdgeInsets.only(left: 20),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Numéro',
                  ),
                  onChanged: (val) {
                    setState(() {
                      try {
                        number = int.parse(val);
                        notValidNumber = false;
                      } catch (e) {
                        notValidNumber = true;
                      }
                    });
                  },
                  validator: (val) {
                    return val!.isEmpty ? 'Ce champ est obligatoire' : null;
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            backendMessage.isNotEmpty
                ? Column(
                    children: [
                      Text(backendMessage),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  )
                : const SizedBox.shrink(),
            timeOutError
                ? Column(
                    children: const [
                      Text("Vérifiez votre connection internet !"),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  )
                : const SizedBox.shrink(),
            notValidNumber
                ? Column(
                    children: const [
                      Text("Numéro invalid !"),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  )
                : const SizedBox.shrink(),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _addStadium();
                  }
                },
                child: loading
                    ? const SpinKitRing(
                        color: Colors.white,
                        size: 25,
                      )
                    : const Text("Ajouter"))
          ],
        ),
      ),
    );
  }

  _addStadium() async {
    if (!notValidNumber) {
      setState(() {
        loading = true;
      });
      String body = '{"size":"$size","num":"$number"}';
      try {
        await HttpClient.post_(ManagerAPI.ADD_STADIUM, body: body)
            .then((value) {
              final jsonResponse =
                  convert.jsonDecode(value.body) as Map<String, dynamic>;
              if (value.statusCode == 202) {
                _formKey.currentState!.reset();
                setState(() {
                  timeOutError = false;
                  loading = false;
                  backendMessage = jsonResponse['message'];
                  notValidNumber = false;
                });
              } else {
                setState(() {
                  timeOutError = false;
                  loading = false;
                  notValidNumber = false;
                  backendMessage = jsonResponse['error'];
                });
              }
            })
            .timeout(const Duration(seconds: 30))
            .onError((error, stackTrace) {
              setState(() {
                backendMessage = "";
                timeOutError = true;
                loading = false;
                notValidNumber = false;
              });
            });
      } catch (e, s) {
        setState(() {
          backendMessage = "";
          timeOutError = true;
          loading = false;
          notValidNumber = false;
        });
      }
    }
  }

  @override
  bool get wantKeepAlive => false;
}
