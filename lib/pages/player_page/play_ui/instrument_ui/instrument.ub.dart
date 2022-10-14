part of '../../player.page.dart';

@Ui_(state: [
  SF_<double>(name: 'width'),
  SF_<double>(name: 'height'),
])
class _InstrumentUb extends _Instrument$Ub {
  @override
  Widget build() {
    return LayoutBuilder(builder: ((context, constraints) {
      ctrl.updateSize(constraints);
      return Stack(
        children: [...ctrl.noteUbs.map((e) => e.ui).toList()],
      );
    }));
  }
}
