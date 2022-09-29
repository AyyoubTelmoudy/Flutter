import 'package:flutter/material.dart';
import 'package:mobile_flutter/core/colors/colors.dart';
import 'package:mobile_flutter/core/utils/utils.dart';
import 'package:mobile_flutter/widgets/club_reservations.dart';
import 'package:mobile_flutter/widgets/manager_game_reservation_form.dart';
import 'package:mobile_flutter/widgets/widgets.dart';

class ManagerReservation extends StatefulWidget {
  const ManagerReservation({Key? key}) : super(key: key);

  @override
  State<ManagerReservation> createState() => _ManagerReservationState();
}

class _ManagerReservationState extends State<ManagerReservation>
    with AutomaticKeepAliveClientMixin {
  int _selectedIndex = 0;
  final _widgetOptions = [
    const ManagerGameReservationForm(),
    const ClubReservations(),
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
            padding: const EdgeInsets.symmetric(horizontal: 5),
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
            label: 'Réservations reçues',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: green,
        onTap: _onItemTapped,
      ),
      drawer: const ManagerDrawer(),
    );
  }

  @override
  bool get wantKeepAlive => false;
}
