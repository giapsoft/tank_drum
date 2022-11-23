part of '../../player.page.dart';

@Ui_(state: [
  SF_<double>(name: 'width'),
  SF_<double>(name: 'height'),
])
class _InstrumentUb extends _Instrument$Ub {
  int pointers = 0;

  @override
  Widget build() {
    return LayoutBuilder(builder: ((context, constraints) {
      ctrl.updateSize(constraints);
      return Listener(
        onPointerDown: ((event) {
          pointers.synchronized(() {
            pointers++;
          });
          for (var note in ctrl.noteUbs.reversed) {
            if (note.ctrl.isInBody(event.localPosition)) {
              note.ctrl.doSwipedIn(event.localPosition);
              return;
            }
          }
        }),
        onPointerUp: ((event) {
          pointers.synchronized(() {
            pointers--;
            if (pointers == 0) {
              for (var note in ctrl.noteUbs) {
                note.ctrl.doSwipedOut();
              }
            } else {
              for (var note in ctrl.noteUbs.reversed) {
                if (pointers == 0 || note.ctrl.isInBody(event.localPosition)) {
                  note.ctrl.doSwipedOut();
                  return;
                }
              }
            }
          });
        }),
        onPointerMove: (details) {
          pointers.synchronized(() {
            final pos = details.localPosition;
            final idxList = <int>[];
            for (var note in ctrl.noteUbs.reversed) {
              if (note.ctrl.isInBody(pos)) {
                note.ctrl.doSwipedIn(pos);
                idxList.add(note.currentSoundIdx);
                break;
              }
            }
            for (var note in ctrl.noteUbs.reversed) {
              if (!idxList.contains(note.currentSoundIdx) &&
                  note.ctrl.isInBorder(pos)) {
                note.ctrl.doSwipedOut();
              }
            }
          });
        },
        child: Stack(
          children: [
            Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              decoration: const BoxDecoration(color: Colors.yellow),
            ),
            ...ctrl.noteUbs.map((e) => e.ui).toList()
          ],
        ),
      );
    }));
  }
}
