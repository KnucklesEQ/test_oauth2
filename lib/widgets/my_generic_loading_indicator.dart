import 'package:flutter/material.dart';

class MyGenericLoadingIndicator extends StatelessWidget {
  final double opacity;

  MyGenericLoadingIndicator({this.opacity = 0.7});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        decoration: BoxDecoration(color: Colors.black),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
