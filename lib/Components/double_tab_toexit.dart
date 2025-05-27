import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DoubleTapToExit extends StatefulWidget {
  final Widget child;

  const DoubleTapToExit({required this.child, Key? key}) : super(key: key);

  @override
  _DoubleTapToExitState createState() => _DoubleTapToExitState();
}

class _DoubleTapToExitState extends State<DoubleTapToExit> {
  DateTime? _lastPressedAt;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        const duration = Duration(seconds: 2);
        if (_lastPressedAt == null ||
            now.difference(_lastPressedAt!) > duration) {
          _lastPressedAt = now;
          Fluttertoast.showToast(
            msg: "Tap again to exit",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return false;
        }
        return true;
      },
      child: widget.child,
    );
  }
}
