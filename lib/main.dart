import 'package:flutter/material.dart';
import 'package:tankdrum_learning/songs/music_note_lib.dart';
import 'package:tankdrum_learning/drums/common/select_play_mode_btn.dart';
import 'package:tankdrum_learning/drums/common/select_song_btn.dart';
import 'package:tankdrum_learning/songs/song_sub.dart';
import 'package:tankdrum_learning/utils/builder.ut.dart';

import 'drums/tank_15n_drum.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const MyHomePage(title: 'Learning Tank Drum'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    rebuild() {
      setState(() {});
    }

    return Scaffold(
      body: ListView(children: [
        BuilderUt.futureNoData(MusicNoteLib.init(),
            () => const Center(child: Tank15NDrumWidget())),
        const SongSub(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SelectSongBtn(rebuild),
            const SelectPlayModeBtn(),
          ],
        )
      ]),
    );
  }
}
