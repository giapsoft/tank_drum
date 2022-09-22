class SoundNote {
  static const names = [
    'C',
    'C#',
    'D',
    'D#',
    'E',
    'F',
    'F#',
    'G',
    'G#',
    'A',
    'A#',
    'B',
  ];

  static const intervals = [1, 2, 3, 4, 5, 6, 7, 8];
  static Map<String, int>? _allNoteNames;
  static Map<String, int> get allNoteNames => _allNoteNames ??= getAllNames();
  static List<String> noteNames = [];
  static Map<String, int> getAllNames() {
    final result = <String, int>{};
    for (final inter in intervals) {
      for (final name in names) {
        noteNames.add('$name$inter');
      }
    }
    for (int i = 0; i < noteNames.length; i++) {
      result[noteNames[i]] = i;
    }
    return result;
  }

  final String name;
  final String interval;
  String rootName = '';
  SoundNote(this.name, this.interval) {
    rootName = '$name$interval';
  }

  String getName(int tune) {
    final idx = allNoteNames[rootName]!;
    return noteNames[idx + tune];
  }
}
