import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String label;
  final Color fillColor;
  final Color checkColor;
  final Color activeColor;
  final Color borderColor;
  final double borderRadius;

  const CustomCheckbox({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.label,
    required this.fillColor,
    required this.checkColor,
    required this.activeColor,
    required this.borderColor,
    this.borderRadius = 4.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: value,
      onChanged: onChanged,
      activeColor: activeColor,
      title: Text(
        label,
        style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
      ),
      controlAffinity: ListTileControlAffinity.leading,
      tileColor: fillColor,
      checkColor: checkColor,
      contentPadding: EdgeInsets.zero,
      dense: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(color: borderColor),
      ),
    );
  }
}