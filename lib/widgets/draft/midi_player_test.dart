import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';

void main(List<String> args) {
  runApp(MyHomePage());
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FlutterMidi fm;
  final songFile = 'assets/NiceSteinwayv39.sf2';

  @override
  void initState() {
    super.initState();

    fm = FlutterMidi();
    _load(songFile);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('MidiPlayer'),
        ),
        body: Center(
          child: TextButton(
            onPressed: () {
              _playSong(
                timing: 100,
                notes: 30,
              );
            },
            child: const Text('Play'),
          ),
        ),
      ),
    );
  }

  void _load(String asset) async {
    fm.unmute();
    ByteData _byte = await rootBundle.load(asset);
    fm.prepare(sf2: _byte, name: songFile.replaceAll('assets/', ''));
  }

  void _playSong({
    required int timing, //Time between notes
    required int notes, //Number of notes to be played
  }) {
    var note = 0;
    Timer.periodic(Duration(milliseconds: timing), (timer) {
      //You played the last note
      if (note == notes) {
        fm.stopMidiNote(midi: note - 1);
        timer.cancel();
        return;
      }

      //Interrupt the previous note
      if (note > 0) {
        fm.stopMidiNote(midi: note - 1);
      }

      //Play the current note and increase the counter
      fm.playMidiNote(midi: note++);
    });
  }
}
