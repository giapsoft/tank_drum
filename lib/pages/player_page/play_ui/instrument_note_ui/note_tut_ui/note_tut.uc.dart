part of '../../../player.page.dart';

class _NoteTutUc extends _NoteTut$Ctrl {
  active() {
    state.isActive = true;
  }

  wait() {
    state.isWaiter = true;
  }

  inActive() {
    state.isActive = false;
    state.isWaiter = false;
  }

  Function() callbackOnDone = () {};

  onDone() {
    callbackOnDone();
  }

  trigger(Function() callbackOnDone) {
    this.callbackOnDone = callbackOnDone;
    state.isTraining = true;
  }
}
