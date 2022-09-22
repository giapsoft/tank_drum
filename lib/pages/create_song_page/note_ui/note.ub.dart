part of '../create_song.page.dart';

@Ui_(isSingle: true, state: [
  SF_<String>(name: 'soundName'),
  SF_<bool>(name: 'isActive'),
  SF_<NoteLinkType>(name: 'linkType'),
  SF_<int>(name: 'beats', init: 1),
  SF_<String>(name: 'draggingName', init: 'NO_NAME'),
  SF_<int>(name: 'draggingBeats'),
  SF_<NoteLinkType>(name: 'draggingType')
])
class _NoteUb extends _Note$Ub {
  _NoteUb(
    this.idx, {
    required this.onChangeLinkType,
    required this.onWillAcceptNote,
    required this.onAcceptNote,
    required this.onLeave,
    required this.notes,
    required this.onActiveChanged,
  });

  final List<_NoteUb> notes;
  final Function(_NoteUb) onChangeLinkType;
  final Function(_NoteUb) onActiveChanged;
  final Function(_NoteUb, Object?) onLeave;
  final bool Function(_NoteUb, Object?) onWillAcceptNote;
  final Function(_NoteUb, Object?) onAcceptNote;
  final int idx;

  @override
  Widget build() {
    return buildNote();
  }

  Widget wrapWithDragTarget(Widget Function() buildMethod,
      {bool isLinking = false}) {
    return DragTarget(builder: (_, candidateData, rejectedData) {
      return buildMethod();
    }, onWillAccept: (data) {
      data as _DragData;
      data.isLinking = isLinking;
      return onWillAcceptNote(this, data);
    }, onAccept: (data) {
      data as _DragData;
      data.isLinking = isLinking;
      onAcceptNote(this, data);
    }, onLeave: (data) {
      data as _DragData;
      data.isLinking = isLinking;
      onLeave(this, data);
    });
  }

  Widget wrapWithDraggable(Widget Function() buildMethod) {
    return Draggable(
      feedback: DragingSound(state.soundName),
      data: _DragData.fromNote(idx, state.soundName),
      child: buildMethod(),
    );
  }

  Widget buildNote() {
    return LayoutBuilder(builder: (context, constraints) {
      final parentWidth = constraints.maxWidth;
      final noteSize = parentWidth / 10;
      final totalSize = noteSize * 2;
      final iconSize = parentWidth / 16;

      buildBeats() {
        return Container(
          width: iconSize,
          height: iconSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: ctrl.noteColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                ctrl.beats.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      }

      buildLinkType() {
        return Icon(
          ctrl.linkType.iconData,
          size: iconSize,
          color: ctrl.noteColor,
        );
      }

      Widget buildLink() {
        return GestureDetector(
          onTap: () => onChangeLinkType(this),
          child: SizedBox(
              width: noteSize,
              child: Center(
                  child: Obx(
                () => ctrl.isRenderBeats() ? buildBeats() : buildLinkType(),
              ))),
        );
      }

      Widget buildNote() {
        return GestureDetector(
          onTap: ctrl.touchActive,
          child: Obx(() => Container(
                width: noteSize,
                height: noteSize,
                decoration: BoxDecoration(
                  color: ctrl.noteColor,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: SoundNameText(ctrl.soundName),
              )),
        );
      }

      return SizedBox(
        width: totalSize,
        child: Stack(
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.end,
              children: [
                buildNote(),
                buildLink(),
              ],
            ),
            wrapWithDragTarget(() {
              return SizedBox(
                width: noteSize,
                height: noteSize,
              );
            }),
            Positioned(
              left: noteSize,
              child: wrapWithDragTarget(() {
                return SizedBox(
                  width: noteSize,
                  height: noteSize,
                );
              }, isLinking: true),
            )
          ],
        ),
      );
    });
  }
}
