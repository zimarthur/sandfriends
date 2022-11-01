import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:sandfriends/providers/redirect_provider.dart';
import 'package:sandfriends/widgets/Modal/SF_ModalMessage.dart';
import 'dart:convert';

import '../../models/enums.dart';
import '../../providers/login_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/Modal/SF_Modal.dart';

class EmailValidation extends StatefulWidget {
  const EmailValidation({Key? key}) : super(key: key);

  @override
  State<EmailValidation> createState() => _EmailValidationState();
}

class _EmailValidationState extends State<EmailValidation> {
  final TextEditingController modalController = TextEditingController();

  bool showModal = false;
  Widget? modalWidget;
  GenericStatus? modalStatus;
  String? modalMessage;

  GenericStatus? emailConfirmationStatus;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      showModal = false;

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
                const Text("dynamic link"),
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
                    });
                  },
                  child: SFModalMessage(
                    message: modalMessage!,
                    modalStatus: modalStatus!,
                    onTap: () {
                      setState(() {
                        if (emailConfirmationStatus == GenericStatus.Failed) {
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
      emailConfirmationStatus = GenericStatus.Success;
      showModal = false;
      context.goNamed('new_user_welcome');
    } else if (response.statusCode == 406) {
      emailConfirmationStatus = GenericStatus.Failed;
      modalMessage = "Seu link não é válido. Tente novamente";
      modalStatus = GenericStatus.Failed;
      showModal = true;
    } else if (response.statusCode == 411) {
      emailConfirmationStatus = GenericStatus.Failed;
      modalMessage = "Sua conta já foi confirmada. Faça login!";
      modalStatus = GenericStatus.Success;
      showModal = true;
    } else {
      emailConfirmationStatus = GenericStatus.Failed;
      modalMessage = "Ocorreu um erro inesperado. Tente novamente";
      modalStatus = GenericStatus.Failed;
      showModal = true;
    }

    if (mounted) {
      if (showModal) {
        setState(() {
          // Your state change code goes here
        });
      }
    }
  }
}
