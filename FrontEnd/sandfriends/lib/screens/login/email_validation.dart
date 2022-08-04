import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sandfriends/providers/redirect_provider.dart';

import '../../models/enums.dart';
import '../../providers/login_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/SF_Modal.dart';

class EmailValidation extends StatefulWidget {
  const EmailValidation({Key? key}) : super(key: key);

  @override
  State<EmailValidation> createState() => _EmailValidationState();
}

class _EmailValidationState extends State<EmailValidation> {
  final TextEditingController modalController = TextEditingController();

  bool showModal = false;
  String? modalMessage;
  String? modalImagePath;
  ModalPourpose? modalPourpose;

  EnumEmailConfirmationStatus? emailConfirmationStatus;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      showModal = false;
      modalPourpose = ModalPourpose.Alert;
      ConfirmEmail(context);
    });

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: AppTheme.colors.secondaryBack,
            child: Stack(
              children: [
                Text("dynamic link"),
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
                  picturePath: modalImagePath!,
                  message: modalMessage!,
                  showModal: showModal,
                  pourpose: modalPourpose!,
                  textController: modalController,
                  onTap: () {
                    setState(() {
                      if (emailConfirmationStatus ==
                          EnumEmailConfirmationStatus.Failed) {
                        context.goNamed('login_signup');
                      }
                    });
                  },
                )
              : Container()
        ],
      ),
    );
  }

  Future<void> ConfirmEmail(BuildContext context) async {
    var response = await http.post(
      Uri.parse('https://www.sandfriends.com.br/ConfirmEmail'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, Object>{
          'EmailConfirmationToken': Provider.of<Login>(context, listen: false)
              .emailConfirmationToken!,
        },
      ),
    );

    if (response.statusCode == 200) {
      emailConfirmationStatus = EnumEmailConfirmationStatus.Success;
      showModal = false;
      context.goNamed('login');
    } else if (response.statusCode == 406) {
      emailConfirmationStatus = EnumEmailConfirmationStatus.Failed;
      modalMessage = "Seu link não é válido. Tente novamente";
      modalImagePath = r"assets\icon\sad_face.svg";
      showModal = true;
    } else {
      emailConfirmationStatus = EnumEmailConfirmationStatus.Failed;
      modalMessage = "Ocorreu um erro inesperado. Tente novamente";
      modalImagePath = r"assets\icon\sad_face.svg";
      showModal = true;
    }

    if (this.mounted) {
      if (showModal) {
        setState(() {
          // Your state change code goes here
        });
      }
    }
  }
}
