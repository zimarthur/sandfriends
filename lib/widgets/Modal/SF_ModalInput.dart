import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/models/enums.dart';

import '../../theme/app_theme.dart';
import '../SF_Button.dart';
import '../SF_TextField.dart';

class SFModalInput extends StatefulWidget {
  final GenericStatus modalStatus;
  final String message;
  final String inputMessage;
  final TextEditingController textController;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;
  GlobalKey<FormState> formKey;
  final TextFieldPourpose textFieldPourpose;

  SFModalInput({
    required this.modalStatus,
    required this.message,
    required this.inputMessage,
    required this.textController,
    required this.validator,
    required this.onTap,
    required this.formKey,
    required this.textFieldPourpose,
  });

  @override
  State<SFModalInput> createState() => _SFModalInputState();
}

class _SFModalInputState extends State<SFModalInput> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.1, vertical: height * 0.03),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SvgPicture.asset(
            widget.modalStatus == GenericStatus.Success
                ? r"assets\icon\happy_face.svg"
                : r"assets\icon\sad_face.svg",
            height: width * 0.25,
            width: width * 0.25,
          ),
          Container(
            constraints: BoxConstraints(minHeight: height * 0.1),
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: height * 0.05, bottom: height * 0.02),
            child: Text(
              widget.message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.colors.primaryBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Form(
            key: widget.formKey,
            child: Padding(
              padding: EdgeInsets.only(bottom: height * 0.02),
              child: SFTextField(
                  labelText: widget.inputMessage,
                  pourpose: widget.textFieldPourpose,
                  controller: widget.textController,
                  validator: widget.validator),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: SizedBox(
              height: height * 0.05,
              child: SFButton(
                buttonLabel: "Concluído",
                buttonType: ButtonType.Primary,
                onTap: widget.onTap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
