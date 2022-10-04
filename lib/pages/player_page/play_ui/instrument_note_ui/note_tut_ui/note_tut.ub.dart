part of '../../../player.page.dart';

@Ui_(isSingle: true, state: [
  SF_<bool>(name: 'isTraining'),
  SF_<bool>(name: 'isActive'),
  SF_<bool>(name: 'isWaiter'),
])
class _NoteTutUb extends _NoteTut$Ub {
  _NoteTutUb(this.instrumentNote, this.idx);
  final InstrumentNote instrumentNote;
  final int idx;

  Color get activeColor {
    return SoundNoteUb.getColor(state.isActive, state.isWaiter);
  }

  @override
  Widget build() {
    return const SizedBox();
    // return Obx(
    //   () => AnimatedPositioned(
    //     curve: Curves.linear,
    //     onEnd: () {
    //       if (state.isTraining) {
    //         ctrl.onDone();
    //         state.isTraining = false;
    //       }
    //       state.isActive = false;
    //       state.isWaiter = false;
    //     },
    //     top: state.isTraining ? drumNote.pos.top : drumNote.pos.firstTutPos.top,
    //     left: state.isTraining
    //         ? drumNote.pos.left
    //         : drumNote.pos.firstTutPos.left,
    //     width: drumNote.pos.size,
    //     height: drumNote.pos.size,
    //     duration: state.isTraining
    //         ? const Duration(seconds: 2)
    //         : const Duration(seconds: 0),
    //     child: Container(
    //       width: drumNote.pos.size,
    //       height: drumNote.pos.size,
    //       decoration: BoxDecoration(
    //         border: Border.all(
    //             color: activeColor,
    //             width: state.isActive
    //                 ? 6
    //                 : state.isWaiter
    //                     ? 4
    //                     : 2),
    //         borderRadius: BorderRadius.circular(drumNote.pos.size),
    //       ),
    //     ),
    //   ),
    // );
  }
}
