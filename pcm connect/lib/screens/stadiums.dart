import 'package:flutter/material.dart';
import 'package:mobile_flutter/core/colors/colors.dart';
import 'package:mobile_flutter/core/utils/utils.dart';
import 'package:mobile_flutter/screens/add_stadium.dart';
import 'package:mobile_flutter/widgets/stadiums_list.dart';
import 'package:mobile_flutter/widgets/widgets.dart';

class Stadiums extends StatefulWidget {
  const Stadiums({Key? key}) : super(key: key);

  @override
  State<Stadiums> createState() => _StadiumsState();
}

class _StadiumsState extends State<Stadiums>
    with AutomaticKeepAliveClientMixin {
  int _selectedIndex = 0;
  final _widgetOptions = [
    const StadiumsList(),
    const AddStadium(),
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
            icon: Icon(Icons.stadium),
            label: 'Terrains',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Ajouter terrain',
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
