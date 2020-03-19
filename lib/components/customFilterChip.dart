import 'package:flutter/material.dart';
import 'package:flutter_haushaltsbuch/utility/constants.dart';

class CustomFilterChip extends StatefulWidget {
  CustomFilterChip({this.chipLabel, this.onSetActive, this.onSetInactive});
  final String chipLabel;
  final Function onSetActive;
  final Function onSetInactive;

  @override
  _CustomFilterChipState createState() => _CustomFilterChipState();
}

class _CustomFilterChipState extends State<CustomFilterChip> {
  bool _isSelected = false;
  @override
  Widget build(BuildContext context) {
    return FilterChip(
      labelStyle: kTabbarTextStyle.copyWith(color: kBackgroundColor),
      checkmarkColor: kBackgroundColor,
      shadowColor: Colors.transparent,
      elevation: 5,
      selected: _isSelected,
      backgroundColor: Colors.red,
      selectedColor: kTextColorHeading,
      label: Text(widget.chipLabel),
      onSelected: (isSelected) {
        isSelected ? widget.onSetActive() : widget.onSetInactive();
        setState(() {
          _isSelected = isSelected;
        });
      },
    );
  }
}
