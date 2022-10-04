part of 'create_song.page.dart';

@Page_(state: [
  SF_<int>(name: 'currentNoteIdx'),
  SF_<List<SongNote>>(name: 'songNotes'),
  SF_<int>(name: 'activeNoteBeats'),
  SF_<int>(name: 'bpm', init: 150),
  SF_<bool>(name: 'isPlayingFromCurrentNote'),
  SF_<bool>(name: 'isPlayingCurrentPage'),
  SF_<int>(name: 'tune', init: 21)
])
class CreateSongBuilder extends CreateSong$Builder {
  @override
  Widget build() {
    return SafeArea(
      child: Scaffold(
        body: ListView(children: [
          ctrl.songName.ui(),
          buildPlaybar(),
          buildSongNotes(),
          buildSoundNotes(),
        ]),
      ),
    );
  }

  Widget buildSoundNotes() {
    buildDragSound(SoundNoteUb note) {
      return Draggable(
        feedback: DragingSound(note.soundName),
        data: _DragData.insert(note.soundName),
        child: note.ui,
      );
    }

    return Wrap(
      alignment: WrapAlignment.center,
      children: ctrl.soundNotes.map(buildDragSound).toList(),
    );
  }

  Widget buildPlaybar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        hideOnPlay(() => IconButton(
            onPressed: ctrl.prevPage, icon: const Icon(Icons.navigate_before))),
        hideIf(
            () => state.isPlayingCurrentPage,
            () => GestureDetector(
                  onTap: ctrl.playFromCurrentNote,
                  child: Obx(() => Icon(
                        state.isPlayingFromCurrentNote
                            ? Icons.pause
                            : Icons.play_circle,
                        color: Colors.blue,
                        size: 28,
                      )),
                )),
        hideOnPlay(() => IconButton(
            onPressed: ctrl.nextPage, icon: const Icon(Icons.navigate_next))),
        hideOnPlay(
          () => SizedBox(
              width: 150,
              child: Slider(
                  divisions: state.songNotes.length - 1,
                  value: state.currentNoteIdx.toDouble() + 1,
                  min: 1,
                  max: state.songNotes.length.toDouble(),
                  onChanged: ctrl.changeCurrentNoteIdx)),
        ),
        Obx(() => Text('${state.currentNoteIdx + 1}/${state.songNotes.length}'))
      ],
    );
  }

  Widget hideOnPlay(Widget Function() build) {
    return Obx(() => ctrl.isPlaying ? const SizedBox() : build());
  }

  Widget hideIf(bool Function() condition, Widget Function() build) {
    return Obx(() => condition() ? const SizedBox() : build());
  }

  Widget buildSongNotes() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Card(
        elevation: 1,
        borderOnForeground: true,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  runSpacing: 10,
                  children: ctrl.notes.map((e) => e.ui).toList()),
              SizedBox(
                height: 30,
                child: Obx(() =>
                    state.activeNoteBeats < 1 ? buildBpm() : buildBeats()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBeats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Beats'),
        Slider(
            value: state.activeNoteBeats.toDouble(),
            divisions: 20,
            min: 1,
            max: 20,
            onChanged: ctrl.setActiveNoteBeats),
      ],
    );
  }

  Widget buildBpm() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          hideIf(
              () => state.isPlayingFromCurrentNote,
              () => IconButton(
                  onPressed: ctrl.playCurrentPage,
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                  icon: state.isPlayingCurrentPage
                      ? const Icon(Icons.pause)
                      : const Icon(Icons.play_arrow))),
          Text('Bpm ${state.bpm}'),
          hideOnPlay(
            () => Slider(
                value: state.bpm.toDouble(),
                divisions: 241,
                min: 60,
                max: 300,
                onChanged: ((value) => state.bpm = value.toInt())),
          ),
        ],
      ),
    );
  }
}
