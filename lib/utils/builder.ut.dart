import 'package:flutter/material.dart';

class BuilderUt {
  static Widget noneExist() {
    return const Center(child: Text('none Existed'));
  }

  static Widget error({String? err, Function()? action}) {
    return err == null
        ? const SizedBox()
        : Scaffold(
            body: Center(
                child: TextButton(
            onPressed: action,
            child: Text(err),
          )));
  }

  static Widget loading() {
    return const Center(child: CircularProgressIndicator());
  }

  static Widget future<T>(
      Future<T?> Function() getFuture, Widget Function(T) buildFunction) {
    return FutureBuilder<T?>(
        future: getFuture(),
        builder: (_, asyncSnapshot) {
          if (asyncSnapshot.hasError) {
            debugPrint(asyncSnapshot.error.toString());
            return error(err: asyncSnapshot.error.toString());
          }
          if (asyncSnapshot.connectionState == ConnectionState.done) {
            final data = asyncSnapshot.data;
            if (data != null) {
              return buildFunction(data);
            } else {
              return noneExist();
            }
          }
          return loading();
        });
  }

  static Widget futureNoData<T>(
      Future<T?> future, Widget Function() buildFunction) {
    return FutureBuilder<T?>(
        future: future,
        builder: (_, asyncSnapshot) {
          if (asyncSnapshot.hasError) {
            debugPrint(asyncSnapshot.error.toString());
            return error(err: asyncSnapshot.error.toString());
          }
          if (asyncSnapshot.connectionState == ConnectionState.done) {
            return buildFunction();
          }
          return loading();
        });
  }
}
