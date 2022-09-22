import 'package:flutter/material.dart';
import 'package:tankdrum_learning/pages/my_songs_page/my_songs.page.dart';
import 'package:tankdrum_learning/pages/player_page/player.page.dart';

class SideBar extends StatefulWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: const Text('Play'),
            onTap: () {
              PlayerPage.goOff();
            },
          ),
          const ListTile(
            title: Text('My Songs'),
            onTap: MySongsPage.goOff,
          )
        ],
      ),
    );
  }
}
