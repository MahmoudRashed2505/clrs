import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Function action;
  final Widget child;
  final double btnWidth;
  RoundedButton(
      {@required this.child, @required this.action, @required this.btnWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * btnWidth,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1),
        borderRadius: BorderRadius.circular(50),
      ),
      child: GestureDetector(
        onTap: () {
          action(context);
        },
        child: child,
      ),
    );
  }
}
