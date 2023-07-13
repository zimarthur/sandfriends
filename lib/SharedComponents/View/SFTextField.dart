import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sandfriends/Utils/Constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum TextFieldPourpose { Standard, Email, Password, Numeric, Multiline }

class SFTextField extends StatefulWidget {
  final String labelText;
  final SvgPicture? prefixIcon;
  final SvgPicture? suffixIcon;
  final SvgPicture? suffixIconPressed;
  final TextFieldPourpose pourpose;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final int? maxLines;
  final int? minLines;
  final Function(String)? onChanged;
  final String? hintText;
  final Color themeColor;
  final List<TextInputFormatter>? inputFormatters;

  const SFTextField({
    Key? key,
    required this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixIconPressed,
    required this.pourpose,
    required this.controller,
    required this.validator,
    this.maxLines,
    this.onChanged,
    this.minLines,
    this.hintText,
    this.themeColor = primaryBlue,
    this.inputFormatters,
  }) : super(key: key);

  @override
  State<SFTextField> createState() => _SFTextFieldState();
}

class _SFTextFieldState extends State<SFTextField> {
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      controller: widget.controller,
      textInputAction: TextInputAction.next,
      inputFormatters: widget.inputFormatters,
      keyboardType: widget.pourpose == TextFieldPourpose.Email
          ? TextInputType.emailAddress
          : widget.pourpose == TextFieldPourpose.Numeric
              ? TextInputType.number
              : widget.pourpose == TextFieldPourpose.Multiline
                  ? TextInputType.multiline
                  : TextInputType.text,
      obscureText: widget.pourpose != TextFieldPourpose.Password
          ? false
          : _passwordVisible
              ? false
              : true,
      onChanged: widget.onChanged ?? (value) {},
      minLines: widget.minLines ?? 1,
      maxLines:
          widget.pourpose == TextFieldPourpose.Multiline ? widget.maxLines : 1,
      enableSuggestions: false,
      autocorrect: false,
      style: TextStyle(
        color: widget.themeColor,
        fontWeight: FontWeight.w700,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: secondaryPaper,
        contentPadding: const EdgeInsets.all(16),
        labelText: widget.labelText,
        labelStyle: const TextStyle(
          color: textDarkGrey,
          fontWeight: FontWeight.w300,
          fontSize: 14,
        ),
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon == null
            ? null
            : Container(
                padding: const EdgeInsets.all(16),
                child: widget.prefixIcon,
              ),
        suffixIcon: widget.suffixIcon == null
            ? null
            : InkWell(
                onTap: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: _passwordVisible
                      ? widget.suffixIconPressed
                      : widget.suffixIcon,
                ),
              ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            width: 2,
            color: divider,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            width: 2,
            color: widget.themeColor,
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
    );
  }
}