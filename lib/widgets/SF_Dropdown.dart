import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class SFDropdown extends StatefulWidget {
  final String labelText;
  String? controller;
  final List<String> items;
  final FormFieldValidator<String>? validator;
  final Function(String?) onChanged;

  SFDropdown({
    required this.labelText,
    required this.controller,
    required this.items,
    required this.validator,
    required this.onChanged,
  });

  @override
  State<SFDropdown> createState() => _SFDropdownState();
}

class _SFDropdownState extends State<SFDropdown> {
  bool onError = false;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      validator: widget.validator,
      decoration: InputDecoration(
        labelText: widget.controller == null ? null : widget.labelText,
        labelStyle: TextStyle(color: AppTheme.colors.textDarkGrey),
        fillColor: AppTheme.colors.secondaryPaper,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            width: 2,
            color: AppTheme.colors.divider,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            width: 2,
            color: AppTheme.colors.primaryBlue,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
      ),
      focusColor: AppTheme.colors.primaryBlue,
      iconEnabledColor: AppTheme.colors.primaryBlue,
      isExpanded: true,
      hint: Text(
        widget.labelText,
        style: TextStyle(
          color: AppTheme.colors.textDarkGrey,
          fontWeight: FontWeight.w300,
          fontSize: 14,
        ),
      ),
      value: widget.controller,
      onChanged: (String? newValue) {
        widget.onChanged(newValue);
      },
      style: TextStyle(
        color: AppTheme.colors.primaryBlue,
        fontWeight: FontWeight.w700,
        fontSize: 14,
      ),
      items: widget.items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
