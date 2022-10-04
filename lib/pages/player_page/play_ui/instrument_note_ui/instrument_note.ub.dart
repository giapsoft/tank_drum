// ignore_for_file: library_private_types_in_public_api

part of '../../player.page.dart';

@Ui_(isSingle: true)
class _InstrumentNoteUb extends _InstrumentNote$Ub {
  _InstrumentNoteUb(this.playCtrl, this.note, {required this.onTouchPlay});
  final InstrumentNote note;
  final _PlayUc playCtrl;
  final Function() onTouchPlay;

  @override
  Widget build() {
    return Positioned(
      top: note.top,
      left: note.left,
      width: note.width,
      height: note.height,
      child: Transform.rotate(
          angle: note.angle * pi / 180, child: ctrl.soundBuilder.ui),
    );
  }

  Widget buildTutPath() {
    return const SizedBox();
    // return Positioned(
    //   top: ctrl.drumNote.pos.tutPathTop,
    //   left: ctrl.drumNote.pos.tutPathLeft,
    //   height: ctrl.drumNote.pos.tutPathHeight,
    //   width: ctrl.drumNote.pos.tutPathWidth,
    //   child: Container(
    //     width: ctrl.drumNote.pos.size,
    //     height: ctrl.drumNote.pos.size,
    //     decoration: BoxDecoration(
    //         color: const Color.fromARGB(78, 46, 46, 46),
    //         borderRadius: BorderRadius.circular(ctrl.drumNote.pos.size)),
    //   ),
    // );
  }
}
