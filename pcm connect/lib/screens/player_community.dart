import 'package:flutter/material.dart';
import 'package:mobile_flutter/core/colors/colors.dart';
import 'package:mobile_flutter/core/utils/utils.dart';
import 'package:mobile_flutter/screens/blogs_list.dart';
import 'package:mobile_flutter/widgets/create_blog_form.dart';
import 'package:mobile_flutter/widgets/widgets.dart';

class PlayerCommunity extends StatefulWidget {
  const PlayerCommunity({Key? key}) : super(key: key);

  @override
  State<PlayerCommunity> createState() => _PlayerCommunityState();
}

class _PlayerCommunityState extends State<PlayerCommunity>
    with AutomaticKeepAliveClientMixin {
  int _selectedIndex = 0;
  final _widgetOptions = [
    const BlogsList(),
    const CreateBlogForm(),
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
        title: const Text("PCM Connect"),
        actions: const [
          IconButton(onPressed: Utils.logOut, icon: Icon(Icons.logout))
        ],
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
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.create),
            label: 'Publier un blog',
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
