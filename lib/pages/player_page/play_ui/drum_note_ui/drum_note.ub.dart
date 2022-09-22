// ignore_for_file: library_private_types_in_public_api

part of '../../player.page.dart';

@Ui_(isSingle: true)
class _DrumNoteUb extends _DrumNote$Ub {
  _DrumNoteUb(this.drumCtrl, this.soundName, {required this.onTouchPlay});
  final String soundName;
  final _PlayUc drumCtrl;
  final Function() onTouchPlay;

  @override
  Widget build() {
    return ctrl.soundBuilder.ui;
  }

  Widget buildTutPath() {
    return Positioned(
      top: ctrl.drumNote.pos.tutPathTop,
      left: ctrl.drumNote.pos.tutPathLeft,
      height: ctrl.drumNote.pos.tutPathHeight,
      width: ctrl.drumNote.pos.tutPathWidth,
      child: Container(
        width: ctrl.drumNote.pos.size,
        height: ctrl.drumNote.pos.size,
        decoration: BoxDecoration(
            color: const Color.fromARGB(78, 46, 46, 46),
            borderRadius: BorderRadius.circular(ctrl.drumNote.pos.size)),
      ),
    );
  }
}
