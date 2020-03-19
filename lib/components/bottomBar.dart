import 'package:flutter/material.dart';
import 'package:flutter_haushaltsbuch/components/modalBottomSheet.dart';
import 'package:flutter_haushaltsbuch/utility/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_haushaltsbuch/utility/navigatorNameCheck.dart';

class BottomBar extends StatefulWidget {
  final bottomSheet = CustomBottomSheet();

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: MediaQuery.of(context).size.width,
      color: kBackgroundColor,
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamedIfNotCurrent('/statistics');
              },
              child: Container(
                height: 60,
                width: 60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Icon(
                      Icons.show_chart,
                      size: 30,
                      color: kTextColorHeading,
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Statistics',
                      style: GoogleFonts.nunitoSans(textStyle: kTabbarTextStyle),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                CustomBottomSheet().showBottomSheet(context);
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: kTextColorHeading,
                  boxShadow: [kCardShadow],
                  borderRadius: BorderRadius.circular(kButtonRadius),
                ),
                child: Icon(
                  Icons.add,
                  color: kBackgroundColor,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                print('Profile tapped');
              },
              child: Container(
                height: 60,
                width: 60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Icon(
                      Icons.person_outline,
                      size: 30,
                      color: kTextColorHeading,
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Profile',
                      style: GoogleFonts.nunitoSans(textStyle: kTabbarTextStyle),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
