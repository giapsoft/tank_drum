part of '../player.page.dart';

@Ui_(state: [
  SF_<int>(name: 'totalNotes', init: 15),
])
class _ConfigUb extends _Config$Ub {
  @override
  Widget build() {
    SystemChrome.setPreferredOrientations([]);
    return SafeArea(
      child: LayoutBuilder(builder: (context, constraints) {
        return OrientationBuilder(
          builder: (__, _) => Obx(() => Stack(
                children: [
                  ...ctrl
                      .positions(constraints)
                      .map((e) => Positioned(
                          top: e.top,
                          left: e.left,
                          width: e.width,
                          height: e.height,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.red,
                                border: Border.all(color: Colors.black)),
                          )))
                      .toList(),
                  Positioned(
                      top: 30,
                      left: 0,
                      child: TextButton(
                        onPressed: ctrl.changeType,
                        child: Text(state.totalNotes.toString()),
                      )),
                  Positioned(
                      top: 30,
                      left: 50,
                      child: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: ctrl.addNote,
                      )),
                  Positioned(
                      top: 30,
                      left: 100,
                      child: IconButton(
                        icon: const Icon(Icons.minimize),
                        onPressed: ctrl.reduceNote,
                      ))
                ],
              )),
        );
      }),
    );
  }
}
