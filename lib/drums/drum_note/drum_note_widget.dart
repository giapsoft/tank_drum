import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tankdrum_learning/songs/song_ctrl.dart';

import '../tank_15n_drum.dart';
import 'drum_note.dart';

class DrumNoteWidget extends StatefulWidget {
  const DrumNoteWidget(this.note, this.drumSize, {Key? key}) : super(key: key);
  final DrumNote note;
  final double drumSize;

  @override
  State<DrumNoteWidget> createState() => _DrumNoteWidgetState();
}

class _DrumNoteWidgetState extends State<DrumNoteWidget> {
  _toPi(double degree) {
    return degree / 180 * math.pi;
  }

  @override
  Widget build(BuildContext context) {
    return buildNote();
  }

  Widget buildNote() {
    return Positioned(
      top: widget.note.top * widget.drumSize,
      left: widget.note.left * widget.drumSize,
      child: Transform.rotate(
        angle: _toPi(widget.note.angle),
        child: TextButton(
            onPressed: () => SongCtrl.hit(widget.note),
            child: DrumNoteBuilder(widget.note, widget.drumSize)),
      ),
    );
  }
}

class DrumNoteBuilder extends StatefulWidget {
  const DrumNoteBuilder(this.note, this.drumSize, {Key? key}) : super(key: key);
  final DrumNote note;
  final double drumSize;

  @override
  State<DrumNoteBuilder> createState() => _DrumNoteBuilderState();
}

class _DrumNoteBuilderState extends State<DrumNoteBuilder>
    with SingleTickerProviderStateMixin {
  @override
  void dispose() {
    widget.note.musicNote.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.note.builders.clear();
    widget.note.builders.add(() => setState(() {}));

    final isNext = !Tank15NDrum.isMute &&
        (SongCtrl.currentNote?.hasDrumNote(widget.note.name) ?? false);
    final btnColor = isNext ? Colors.deepOrange : Colors.amber.shade200;

    return Container(
        width: widget.note.width * widget.drumSize,
        height: widget.note.height * widget.drumSize,
        decoration: BoxDecoration(
            color: btnColor, //noteColor(bgAnimation),
            borderRadius: const BorderRadius.all(Radius.circular(100))),
        child: Center(
          child: Text(
            widget.note.name,
            style: const TextStyle(color: Colors.black),
          ),
        ));
  }
}
