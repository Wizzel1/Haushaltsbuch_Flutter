import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;
  final bool isSelectable;
  final Function onTap;

  const Indicator({
    Key key,
    this.color,
    this.text,
    this.isSquare,
    this.isSelectable,
    this.size = 16,
    this.onTap,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        onTap();
      },
      onTapUp: (details) {
        isSelectable ? null : onTap();
      },
      child: Row(
        children: <Widget>[
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: isSquare ? null : BorderRadius.circular(19),
              color: color,
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            text,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
          )
        ],
      ),
    );
  }
}
