import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../models/enums.dart';
import '../../providers/login_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/SF_Modal.dart';

final _newPasswordFormKey = GlobalKey<FormState>();

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController modalController = TextEditingController();

  bool showModal = true;
  String modalMessage = "Digite sua nova senha";
  String modalImagePath = r"assets\icon\happy_face.svg";
  ModalPourpose modalPourpose = ModalPourpose.Password;

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
                const Text("password link"),
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
              ? Form(
                  key: _newPasswordFormKey,
                  child: SFModal(
                    picturePath: modalImagePath,
                    message: modalMessage,
                    showModal: showModal,
                    pourpose: modalPourpose,
                    textController: modalController,
                    onTap: () {
                      setState(() {
                        if (modalPourpose == ModalPourpose.Password) {
                          SetNewPassword(context);
                        } else {
                          showModal = false;
                          context.goNamed('login_signup');
                        }
                      });
                    },
                  ),
                )
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
        modalImagePath = r"assets\icon\happy_face.svg";
        showModal = true;
        changePasswordStatus = EnumChangePasswordStatus.Success;
      } else {
        modalMessage = "Ocorreu um erro ao trocar sua senha. Tente novamente";
        modalImagePath = r"assets\icon\sad_face.svg";
        showModal = true;
      }
      if (showModal) {
        setState(() {
          modalPourpose = ModalPourpose.Alert;
        });
      }
    }
  }
}
