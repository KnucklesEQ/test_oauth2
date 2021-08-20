import 'package:flutter/material.dart';

class MyStretchableButton extends StatelessWidget {
  final double borderRadius;
  final Color buttonColor;
  final Color buttonBorderColor;
  final bool centered;
  final VoidCallback onPressed;
  final List<Widget> children;

  MyStretchableButton({
    required this.buttonColor,
    required this.onPressed,
    this.borderRadius = 3.0,
    this.buttonBorderColor = Colors.transparent,
    this.centered = false,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var contents = List<Widget>.from(children);

        if (constraints.minWidth == 0) {
          contents.add(SizedBox.shrink());
        } else {
          if (centered) {
            contents.insert(0, Spacer());
          }
          contents.add(Spacer());
        }

        BorderSide bs;
        if (buttonBorderColor != Colors.transparent) {
          bs = BorderSide(color: buttonBorderColor);
        } else {
          bs = BorderSide.none;
        }

        return ButtonTheme(
          height: 40.0,
          padding: EdgeInsets.all(0.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: bs,
          ),
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              primary: buttonColor,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: contents,
            ),
          ),
        );
      },
    );
  }
}
