import 'package:flutter/material.dart';

class LogLayout<T> extends StatelessWidget {
  final Widget child;
  final String? tag;

  const LogLayout({Key? key, required this.child, this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      assert(() {
        print('${tag ?? key ?? child}: $constraints');
        return true;
      }());
      return child;
    });
  }
}
