import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/theme/app_theme.dart';
import '../models/validators.dart';
import '../widgets/SF_Button.dart';
import '../widgets/SF_TextField.dart';
import '../models/enums.dart';

class SFModal extends StatefulWidget {
  final String picturePath;
  final String message;
  final ModalPourpose pourpose;
  bool showModal;
  final VoidCallback? onTap;
  final TextEditingController textController;

  SFModal(
      {required this.picturePath,
      required this.message,
      required this.showModal,
      required this.onTap,
      required this.pourpose,
      required this.textController});

  @override
  State<SFModal> createState() => _SFModalState();
}

class _SFModalState extends State<SFModal> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: width,
          height: height,
          color: AppTheme.colors.primaryBlue.withOpacity(0.4),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.colors.secondaryPaper,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(blurRadius: 2, color: AppTheme.colors.secondaryPaper)
            ],
          ),
          width: width * 0.8,
          height: widget.pourpose == ModalPourpose.Alert
              ? height * 0.4
              : height * 0.7,
          padding: const EdgeInsets.all(12),
          child: Column(
            children: <Widget>[
              const Padding(padding: EdgeInsets.only(top: 10)),
              SvgPicture.asset(
                widget.picturePath,
                height: 88,
                width: 88,
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    widget.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppTheme.colors.primaryBlue,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              widget.pourpose == ModalPourpose.Email
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: SFTextField(
                          labelText: "digite seu e-mail",
                          pourpose: TextFieldPourpose.Email,
                          controller: widget.textController,
                          validator: emailValidator),
                    )
                  : widget.pourpose == ModalPourpose.Password
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: SFTextField(
                              labelText: "digite sua senha",
                              pourpose: TextFieldPourpose.Password,
                              controller: widget.textController,
                              validator: passwordValidator),
                        )
                      : Container(),
              SizedBox(
                width: double.infinity,
                child: Container(
                  height: height * 0.05,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.14),
                  child: SFButton(
                    buttonLabel: "Concluído",
                    buttonType: ButtonType.Primary,
                    onTap: widget.onTap,
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(
                bottom: widget.pourpose == ModalPourpose.Alert
                    ? height * 0.4 * 0.05
                    : height * 0.7 * 0.05,
              )),
            ],
          ),
        ),
      ],
    );
  }
}
