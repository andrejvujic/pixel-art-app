import 'package:flutter/material.dart';

class CounterCard extends StatefulWidget {
  @override
  _CounterCardState createState() => _CounterCardState();

  final int counter;
  final Icon counterIcon;
  final Color splashColor, highlightColor;
  final double splashRadius, counterFontSize;
  final Function onPressed;

  CounterCard({
    this.counter = 0,
    this.counterIcon,
    this.counterFontSize = 25.0,
    this.splashColor = Colors.deepPurple,
    this.highlightColor = Colors.deepPurple,
    this.splashRadius = 20.0,
    this.onPressed,
  });
}

class _CounterCardState extends State<CounterCard> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          splashRadius: widget.splashRadius,
          splashColor: widget.splashColor.withOpacity(
            0.2,
          ),
          highlightColor: widget.highlightColor.withOpacity(
            0.1,
          ),
          icon: widget.counterIcon,
          onPressed: () => widget.onPressed?.call(),
        ),
        Text(
          '${widget.counter}',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: widget.counterFontSize,
          ),
        )
      ],
    );
  }
}
