part of 'sound_note.ub.dart';

class _SoundNote$Ui extends UiView<SoundNoteUb> {
  const _SoundNote$Ui({required SoundNoteUb builder, Key? key})
      : super(builder: builder, key: key);
}

abstract class _SoundNote$Ctrl extends UiCtrl {
  late _SoundNote$Ui ui;
  late SoundNoteUb builder;
  @override
  _SoundNote$State get state => builder.state;
}

abstract class _SoundNote$Ub extends UiBuilder with RenderWrapper {
  _SoundNote$Ub({Key? key}) {
    ui = _SoundNote$Ui(builder: this as SoundNoteUb, key: key);
    ctrl.ui = ui;
    ctrl.builder = this as SoundNoteUb;
  }
  _SoundNote$State state = _SoundNote$State();
  late _SoundNote$Ui ui;
  _SoundNoteUc ctrl = _SoundNoteUc();
  @override
  getCtrl() => ctrl;
}

class _SoundNote$State extends ViewState with RenderState {}
