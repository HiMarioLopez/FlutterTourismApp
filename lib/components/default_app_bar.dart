import 'package:flutter/material.dart';
import 'package:lesson01/styles.dart';

class DefaultAppBar extends AppBar {
  @override
  final Widget title =
      Text("Tourism & Co.".toUpperCase(), style: Styles.navbarTitle);

  @override
  final IconThemeData iconTheme = IconThemeData(color: Colors.black);

  @override
  final Brightness brightness = Brightness.light;

  @override
  final Color backgroundColor = Colors.white;

  @override
  final bool centerTitle = true;

  @override
  final double elevation = 0.5;
}
