import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:mobile_flutter/core/api/api.dart';
import 'package:mobile_flutter/core/models/models.dart';
import 'package:mobile_flutter/core/utils/utils.dart';
import 'package:mobile_flutter/screens/home.dart';
import 'dart:convert' as convert;

import 'package:mobile_flutter/screens/login.dart';

class ManagerRegister extends StatefulWidget {
  const ManagerRegister({Key? key}) : super(key: key);

  @override
  State<ManagerRegister> createState() => _ManagerRegisterState();
}

class _ManagerRegisterState extends State<ManagerRegister>
    with AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();
  String backEndErrorMessage = "";
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? level;
  String? city;
  String? country;
  String? neighborhood;
  String? clubName;
  String? webSite;
  String? zipCode;
  String? clubPhone;
  String? clubEmail;
  TimeOfDay openingTime = TimeOfDay.now();
  TimeOfDay closingTime = TimeOfDay.now();
  bool internetConn = false;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
          shadowColor: Colors.grey[300],
          backgroundColor: Colors.grey[300],
          leading: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Home(),
                  ),
                );
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Color.fromARGB(243, 19, 215, 156),
              ))),
      backgroundColor: Colors.grey[300],
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                        height: 100,
                        width: 100,
                        child: const CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/images/logo.jpeg"),
                        )),
                    const SizedBox(
                      height: 26,
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
                              hintText: 'Prénom',
                            ),
                            onChanged: (val) {
                              setState(() {
                                firstName = val;
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
                              hintText: 'Nom',
                            ),
                            onChanged: (val) {
                              setState(() {
                                lastName = val;
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
                              hintText: 'Email',
                            ),
                            onChanged: (val) {
                              setState(() {
                                email = val;
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
                              hintText: 'Mot de passe',
                            ),
                            onChanged: (val) {
                              setState(() {
                                password = val;
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
                              hintText: 'Nom du club',
                            ),
                            onChanged: (val) {
                              setState(() {
                                clubName = val;
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
                              hintText: 'Site web du club',
                            ),
                            onChanged: (val) {
                              setState(() {
                                webSite = val;
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
                              hintText: 'Ville',
                            ),
                            onChanged: (val) {
                              setState(() {
                                city = val;
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
                              hintText: 'Pays',
                            ),
                            onChanged: (val) {
                              setState(() {
                                country = val;
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
                              hintText: 'Quartier',
                            ),
                            onChanged: (val) {
                              setState(() {
                                neighborhood = val;
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
                              hintText: 'Code postal',
                            ),
                            onChanged: (val) {
                              setState(() {
                                zipCode = val;
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
                              hintText: 'Email du club',
                            ),
                            onChanged: (val) {
                              setState(() {
                                clubEmail = val;
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
                              hintText: 'Téléphone du club',
                            ),
                            onChanged: (val) {
                              setState(() {
                                clubPhone = val;
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
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: ElevatedButton(
                                onPressed: () {
                                  _selectOpeningTime(context);
                                },
                                child: const Text("Heure de d'ouverture"),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                  "${openingTime.hour}:${openingTime.minute}"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: ElevatedButton(
                                onPressed: () {
                                  _selectdClosingTime(context);
                                },
                                child: const Text("Heure de fermeture"),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                  "${closingTime.hour}:${closingTime.minute}"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    backEndErrorMessage.isNotEmpty
                        ? Text(backEndErrorMessage)
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
                        if (_formKey.currentState!.validate()) {
                          _register();
                        }
                      },
                      child: loading
                          ? const SpinKitRing(
                              color: Colors.white,
                              size: 25,
                            )
                          : const Text('S\'inscrire'),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  _register() async {
    setState(() {
      loading = true;
      internetConn = false;
    });
    String body = Utils.toManagerRegisterRequestString(
        firstName!,
        lastName!,
        email!,
        password!,
        clubName!,
        webSite!,
        city!,
        country!,
        neighborhood!,
        zipCode!,
        clubPhone!,
        clubEmail!,
        openingTime,
        closingTime);
    const headers = {"Content-type": "application/json"};
    try {
      final response = await post(Uri.parse(ManagerAPI.REGISTER),
              headers: headers, body: body)
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        setState(() {
          internetConn = false;
          loading = false;
        });
        final jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        LoginRequest loginRequest = LoginRequest(
            email: jsonResponse['email'], password: jsonResponse['password']);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Login(
              logRequest: loginRequest,
            ),
            settings: RouteSettings(
              arguments: loginRequest,
            ),
          ),
        );
      } else {
        setState(() {
          loading = false;
          internetConn = false;
        });
        final jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        setState(() {
          if ((jsonResponse['email'] as String?) != null) {
            backEndErrorMessage = jsonResponse['email'];
          }
          if ((jsonResponse['name'] as String?) != null) {
            backEndErrorMessage = jsonResponse['name'];
          }
          if ((jsonResponse['error'] as String?) != null) {
            backEndErrorMessage = jsonResponse['error'];
          }
        });
      }
    } catch (e, s) {
      setState(() {
        backEndErrorMessage = "";
        internetConn = true;
        loading = false;
      });
    }
  }

  _selectOpeningTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: openingTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != openingTime) {
      setState(() {
        openingTime = timeOfDay;
      });
    }
  }

  _selectdClosingTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: closingTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != closingTime) {
      setState(() {
        closingTime = timeOfDay;
      });
    }
  }

  @override
  bool get wantKeepAlive => false;
}
