part of '../my_songs.page.dart';

class _SongDetailsUc extends _SongDetails$Ctrl {
  final name = StringInput('Name')..minLength(3);

  @override
  onWillBuild() {
    state.song$.refresh();
    name.value = state.song.name();
    state.mp3FileName = state.song.mp3File.orElse('none selected');
    state.totalNotes = state.song.notes.length;
  }

  saveCurrentSong() {
    state.song.set(name: name.value);
    FocusManager.instance.primaryFocus?.unfocus();
  }

  deleteCurrentSong() async {
    await parent.ctrl.perfectSongList.delete(state.song);
    parent.ctrl.viewList();
  }

  pickMp3() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['mp3']);

    if (result != null) {
      final filePath = result.files.single.path!;
      state.mp3FileName = filePath.split('/').last;
      state.song.mp3File.set(state.mp3FileName);
      final storagePath = 'perfectSongs/${state.mp3FileName}';
      await LocalFiles.persistWrite(
          storagePath, File(filePath).readAsBytesSync());
      await NetworkFiles.syncToNetwork(storagePath);
    }
  }

  pickCsv() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['csv']);

    if (result != null) {
      final filePath = result.files.single.path!;
      File(filePath);
      final input = File(filePath).openRead();
      final fields = await input.transform(utf8.decoder).toList();
      await state.song.notes.deleteAll();
      final silenceNodes = fields.first
          .split('\r\n')
          .map((e) => SilenceNode.parseCsv(e))
          .where((songNote) => songNote != null)
          .toList();
      for (final node in silenceNodes) {
        await state.song.notes.add(e: node);
      }
      state.totalNotes = state.song.notes.length;
    }
  }
}
