import 'package:flutter/material.dart';
import '../Utils/Constants.dart';

class SFDropdown extends StatefulWidget {
  String labelText;
  final List<String> items;
  final FormFieldValidator<String>? validator;
  final Function(String?) onChanged;
  bool isEnabled;
  Color textColor;
  bool enableBorder;
  Alignment? align;

  SFDropdown({
    super.key,
    required this.labelText,
    required this.items,
    required this.validator,
    required this.onChanged,
    this.isEnabled = true,
    this.textColor = textBlack,
    this.enableBorder = false,
    this.align,
  });

  @override
  State<SFDropdown> createState() => _SFDropdownState();
}

class _SFDropdownState extends State<SFDropdown> {
  bool onError = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: widget.align,
      padding: EdgeInsets.symmetric(
          horizontal: widget.enableBorder ? defaultPadding / 2 : 0),
      decoration: widget.enableBorder
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(defaultBorderRadius),
              border: Border.all(
                color: divider,
                width: 2,
              ),
            )
          : const BoxDecoration(),
      child: DropdownButton(
        value: widget.labelText,
        style: TextStyle(
          color: widget.isEnabled ? widget.textColor : textLightGrey,
          fontFamily: "Lexend",
        ),
        iconEnabledColor: widget.textColor,
        items: widget.items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: widget.onChanged,
        alignment: AlignmentDirectional.center,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        underline: Container(),
      ),
    );
  }
}
