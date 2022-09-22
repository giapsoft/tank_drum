part of 'create_song.page.dart';

enum _DragAction { insert, delete, changeSound, none }

class _DragData {
  String soundName = '';
  int fromIdx = -1;
  bool isLinking = false;
  bool get isDeleting => soundName.isEmpty;
  _DragData.insert(this.soundName);
  _DragData.fromNote(this.fromIdx, this.soundName);

  _DragAction action = _DragAction.none;

  int validatedData = -1;

  @override
  String toString() {
    return ['action: $action', 'validatedData: $validatedData'].join('\n');
  }
}
