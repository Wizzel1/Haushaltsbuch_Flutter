import 'package:flutter/material.dart';
import 'package:flutter_haushaltsbuch/utility/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class QuickActionIcon extends StatelessWidget {
  const QuickActionIcon({this.icon, this.text, this.onTap});

  final Icon icon;
  final String text;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                color: kBackgroundColor,
                borderRadius: BorderRadius.circular(kButtonRadius)),
            child: Center(
              child: icon,
            ),
          ),
          SizedBox(height: 5),
          Text(
            text,
            style: GoogleFonts.nunitoSans(
              textStyle: TextStyle(
                  color: kBackgroundColor, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
