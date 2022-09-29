import 'package:flutter/material.dart';
import 'package:mobile_flutter/core/colors/colors.dart';
import 'package:mobile_flutter/core/utils/utils.dart';
import 'package:mobile_flutter/widgets/widgets.dart';

class PlayerReservation extends StatefulWidget {
  const PlayerReservation({Key? key}) : super(key: key);

  @override
  State<PlayerReservation> createState() => _PlayerReservationState();
}

class _PlayerReservationState extends State<PlayerReservation>
    with AutomaticKeepAliveClientMixin {
  int _selectedIndex = 0;
  String commentAddedSuccessfully = "";
  final _widgetOptions = [
    const PlayerGameReservationForm(),
    const ReservationsHisotry(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: const [
          IconButton(onPressed: Utils.logOut, icon: Icon(Icons.logout))
        ],
        title: const Text("PCM Connect"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              children: [_widgetOptions.elementAt(_selectedIndex)],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online),
            label: 'Réserver',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historique',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: green,
        onTap: _onItemTapped,
      ),
      drawer: const PlayerDrawer(),
    );
  }

  @override
  bool get wantKeepAlive => false;
}
