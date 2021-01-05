import 'package:flutter/material.dart';

class SolidButton extends StatefulWidget {
  @override
  _SolidButtonState createState() => _SolidButtonState();

  final Widget child;
  final Function onPressed;
  final double height, width, splashOpacity, highlightOpacity;
  final Color splashColor, highlightColor, color;
  final EdgeInsets margin, padding, childMargin, childPadding;
  final Alignment alignment;
  SolidButton({
    this.child,
    this.onPressed,
    this.height,
    this.width,
    this.color,
    this.highlightColor = Colors.deepPurple,
    this.splashColor = Colors.deepPurple,
    this.highlightOpacity = 0.1,
    this.splashOpacity = 0.2,
    this.margin = const EdgeInsets.all(0.0),
    this.padding = const EdgeInsets.all(0.0),
    this.childMargin = const EdgeInsets.all(0.0),
    this.childPadding = const EdgeInsets.all(0.0),
    this.alignment = Alignment.center,
  });
}

class _SolidButtonState extends State<SolidButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      margin: widget.margin,
      padding: widget.padding,
      alignment: widget.alignment,
      child: FlatButton(
        child: Container(
          margin: widget.childMargin,
          padding: widget.childPadding,
          child: widget.child,
        ),
        onPressed: () => widget.onPressed?.call(),
        splashColor: widget.splashColor.withOpacity(
          widget.splashOpacity,
        ),
        highlightColor: widget.highlightColor.withOpacity(
          widget.highlightOpacity,
        ),
        color: widget.color,
      ),
    );
  }
}
