import 'package:flutter/material.dart';
import 'package:mobile_flutter/core/colors/colors.dart';
import 'package:mobile_flutter/screens/screens.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const Home());
  }
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  String userType = "PLAYER";
  final List<String> list = <String>['Player', 'Manager'];
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
                opacity: 0.5,
                image: AssetImage('assets/images/back.jpg'),
                fit: BoxFit.cover),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        padding: EdgeInsets.zero,
                        height: 100,
                        width: 100,
                        child: const CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/images/logo.jpeg"),
                        )),
                    const SizedBox(
                      height: 26,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white60,
                      ),
                      child: Text(
                        "Let's padel it !",
                        style: GoogleFonts.bebasNeue(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white60,
                                    borderRadius: BorderRadius.circular(13)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: const Text(
                                  "Quel type de compte souhaitez-vous créer ?",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                color: green,
                                borderRadius: BorderRadius.circular(12)),
                            child: DropdownButton(
                                dropdownColor: green,
                                borderRadius: BorderRadius.circular(12),
                                items: const [
                                  DropdownMenuItem(
                                    child: Text(
                                      "Joueur",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    value: "PLAYER",
                                  ),
                                  DropdownMenuItem(
                                    child: Text(
                                      "Manager",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    value: "MANAGER",
                                  )
                                ],
                                value: userType,
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                ),
                                iconSize: 42,
                                underline: const SizedBox(),
                                onChanged: (String? selectedValue) {
                                  setState(() {
                                    userType = selectedValue!;
                                  });
                                }),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12)),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: toLogin,
                          child: const Text(
                            'Se connecter',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
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
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12)),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: toRegister,
                          child: const Text(
                            "S'inscrire",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void toLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const Login(
                logRequest: null,
              )),
    );
  }

  void toRegister() {
    if (userType == "PLAYER") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PlayerRegister()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ManagerRegister()),
      );
    }
  }

  @override
  bool get wantKeepAlive => false;
}
