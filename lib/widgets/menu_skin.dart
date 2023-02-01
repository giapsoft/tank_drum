import 'package:flutter/material.dart';
import 'package:g_pages/pages.dart';
import 'package:tankdrum_learning/widgets/side_bar.dart';

class MenuSkin extends Skin {
  @override
  Widget wrap(Widget widget, List<Widget> actions) {
    return Scaffold(
      appBar: AppBar(actions: actions, title: Text(builder.title)),
      body: widget,
      drawer: const SideBar(),
    );
  }
}
