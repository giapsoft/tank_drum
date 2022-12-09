import 'package:flutter/material.dart';
import 'package:tankdrum_learning/pages/login_page/login.page.dart';
import 'package:tankdrum_learning/pages/my_songs_page/my_songs.page.dart';
import 'package:tankdrum_learning/pages/player_page/player.page.dart';
import 'package:tankdrum_learning/pages/select_song_page/select_song.page.dart';

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
          buildPageTile('Play', PlayerPage.goOff),
          buildPageTile('My Songs', MySongsPage.goOff),
          buildPageTile('Login', LoginPage.goOff),
          buildPageTile('Select Song', SelectSongPage.goOff),
        ],
      ),
    );
  }

  ListTile buildPageTile(String name, Function() onTap) {
    return ListTile(title: Text(name), onTap: onTap);
  }
}
