import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert' as convert;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_flutter/core/api/security_api.dart';
import 'package:mobile_flutter/core/models/login_regquest.dart';
import 'package:mobile_flutter/core/utils/utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_flutter/screens/screens.dart';

class Login extends StatefulWidget {
  const Login({Key? key, required this.logRequest}) : super(key: key);
  final LoginRequest? logRequest;

  @override
  State<Login> createState() => _LoginState(logRequest);
  static Route route() {
    return MaterialPageRoute<void>(
        builder: (_) => const Login(
              logRequest: null,
            ));
  }
}

class _LoginState extends State<Login> with AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool internetConn = false;
  String? email = "";
  String? password = "";
  String backEndErrorMessage = "";
  final LoginRequest? logRequest;

  _LoginState(this.logRequest);
  @override
  void initState() {
    setState(() {
      email = logRequest?.email;
      password = logRequest?.password;
    });
    super.initState();
  }

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
          child: Center(
              child: Form(
            key: _formKey,
            child: SafeArea(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                    height: 100,
                    width: 100,
                    child: CircleAvatar(
                      backgroundImage: AssetImage("assets/images/logo.jpeg"),
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
                        initialValue: logRequest?.email,
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
                  height: 20,
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
                        initialValue: logRequest?.password,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Mot de passe',
                        ),
                        obscureText: true,
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
                backEndErrorMessage.isNotEmpty
                    ? Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text(backEndErrorMessage),
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
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(12)),
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
                          loginUser();
                        }
                      },
                      child: loading
                          ? const SpinKitRing(
                              color: Colors.white,
                              size: 25,
                            )
                          : const Text(
                              'Se connecter',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ),
              ],
            )),
          )),
        ),
      ),
    );
  }

  Future loginUser() async {
    setState(() {
      loading = true;
      internetConn = false;
      backEndErrorMessage = "";
    });
    try {
      const headers = {"Content-type": "application/json"};
      var json = '{"email":"$email","password":"$password"}';
      final response = await post(Uri.parse(SecurityAPI.LOGIN_API),
              headers: headers, body: json)
          .timeout(
        const Duration(seconds: 30),
      );
      if (response.statusCode == 200) {
        setState(() {
          loading = false;
          internetConn = false;
          backEndErrorMessage = "";
        });
        final jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        const storage = FlutterSecureStorage();
        storage.deleteAll();
        await storage.write(
            key: "access_token", value: jsonResponse['access_token']);
        await storage.write(
            key: "refresh_token", value: jsonResponse['refresh_token']);
        await storage.write(key: "role", value: jsonResponse['role']);
        Utils.redirectUser(context);
      } else {
        setState(() {
          loading = false;
          internetConn = false;
        });
        final jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        setState(() {
          backEndErrorMessage = jsonResponse['error'];
        });
      }
    } catch (e, s) {
      setState(() {
        internetConn = true;
        loading = false;
      });
    }
  }

  @override
  bool get wantKeepAlive => false;
}
