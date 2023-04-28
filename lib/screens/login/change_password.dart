import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:sandfriends/widgets/Modal/SF_ModalInput.dart';
import 'package:sandfriends/widgets/SF_TextField.dart';
import 'dart:convert';

import '../../models/enums.dart';
import '../../models/validators.dart';
import '../../providers/login_provider.dart';
import '../../providers/redirect_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/Modal/SF_Modal.dart';
import '../../widgets/Modal/SF_ModalMessage.dart';

final _newPasswordFormKey = GlobalKey<FormState>();

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController modalController = TextEditingController();

  bool showModal = true;
  GenericStatus? modalStatus = GenericStatus.Success;
  String? modalMessage = "";
  Widget? modalWidget;

  EnumChangePasswordStatus? changePasswordStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: AppTheme.colors.secondaryBack,
            child: Stack(
              children: [
                Positioned.fill(
                  child: SvgPicture.asset(
                    r'assets\icon\sand_bar.svg',
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
                Center(
                    child: Image.asset(
                  r'assets\icon\logo.png',
                  alignment: Alignment.center,
                  height: 120,
                )),
              ],
            ),
          ),
          showModal
              ? SFModal(
                  onTapBackground: () {
                    setState(() {
                      showModal = false;
                      context.goNamed('login_signup');
                    });
                  },
                  child: modalWidget == null
                      ? SFModalInput(
                          formKey: _newPasswordFormKey,
                          inputMessage: 'senha',
                          textController: modalController,
                          textFieldPourpose: TextFieldPourpose.Password,
                          validator: passwordValidator,
                          message: 'digite sua nova senha',
                          modalStatus: GenericStatus.Success,
                          onTap: () {
                            setState(() {
                              SetNewPassword(context);
                            });
                          },
                        )
                      : modalWidget!)
              : Container()
        ],
      ),
    );
  }

  Future<void> SetNewPassword(BuildContext context) async {
    if (_newPasswordFormKey.currentState?.validate() == true) {
      var response = await http.post(
        Uri.parse('https://www.sandfriends.com.br/ChangePassword'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, Object>{
            'ResetPasswordValue':
                Provider.of<Login>(context, listen: false).changePasswordToken!,
            'NewPassword': modalController.text
          },
        ),
      );

      if (response.statusCode == 200) {
        modalMessage = "Sua senha foi alterada!";
        modalStatus = GenericStatus.Success;
        showModal = true;
        changePasswordStatus = EnumChangePasswordStatus.Success;
      } else {
        modalMessage = "Esse link não é mais válido. Solicite novamente.";
        modalStatus = GenericStatus.Failed;
        showModal = true;
      }
      if (mounted) {
        if (showModal) {
          setState(() {
            modalWidget = SFModalMessage(
              modalStatus: modalStatus!,
              message: modalMessage!,
              onTap: () {
                setState(() {
                  showModal = false;
                  context.goNamed('login_signup');
                });
              },
            );
          });
        }
      }
    }
  }
}
