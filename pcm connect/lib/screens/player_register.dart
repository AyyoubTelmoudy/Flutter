import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:mobile_flutter/core/api/api.dart';
import 'dart:convert' as convert;
import 'package:mobile_flutter/core/models/models.dart';
import 'package:mobile_flutter/core/utils/utils.dart';
import 'package:mobile_flutter/screens/home.dart';
import 'package:mobile_flutter/screens/login.dart';

class PlayerRegister extends StatefulWidget {
  const PlayerRegister({Key? key}) : super(key: key);

  @override
  State<PlayerRegister> createState() => _PlayerRegisterState();
}

class _PlayerRegisterState extends State<PlayerRegister>
    with AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();
  String backEndErrorMessage = "";
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String level = "Expert";
  String? city;
  String? country;
  String? neighborhood;
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
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
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
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(12)),
                            child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Text("Niveau"),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12)),
                          child: DropdownButton(
                              dropdownColor: Colors.white,
                              style: TextStyle(color: Colors.grey[200]),
                              borderRadius: BorderRadius.circular(12),
                              items: const [
                                DropdownMenuItem(
                                  child: Text(
                                    "Expert",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  value: "Expert",
                                ),
                                DropdownMenuItem(
                                  child: Text(
                                    "Newcomer",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  value: "Newcomer",
                                ),
                                DropdownMenuItem(
                                  child: Text(
                                    "Average",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  value: "Average",
                                ),
                                DropdownMenuItem(
                                  child: Text(
                                    "Beginner",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  value: "Beginner",
                                )
                              ],
                              value: level,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black,
                              ),
                              iconSize: 40,
                              underline: const SizedBox(),
                              onChanged: (String? selectedValue) {
                                setState(() {
                                  level = selectedValue!;
                                });
                              }),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12)),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
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
                              : const Text(
                                  'S\'inscrire',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                    )
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
    });
    String body = Utils.toPlayerRegisterRequestString(firstName!, lastName!,
        email!, password!, level, city!, country!, neighborhood!);
    const headers = {"Content-type": "application/json"};
    try {
      final response = await post(Uri.parse(PlayerAPI.REGISTER),
              headers: headers, body: body)
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        setState(() {
          loading = false;
          internetConn = false;
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

  @override
  bool get wantKeepAlive => false;
}
