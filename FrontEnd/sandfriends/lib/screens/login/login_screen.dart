import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../models/enums.dart';
import '../../widgets/SF_Button.dart';
import '../../widgets/SF_TextField.dart';
import '../../theme/app_theme.dart';
import '../../widgets/SF_Modal.dart';
import '../../models/validators.dart';

final _loginFormKey = GlobalKey<FormState>();
final _forgotPasswordFormKey = GlobalKey<FormState>();

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController modalController = TextEditingController();

  bool showModal = false;
  String? modalMessage;
  String? modalImagePath;
  ModalPourpose modalPourpose = ModalPourpose.Alert;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          child: Container(
            color: AppTheme.colors.secondaryBack,
            padding: const EdgeInsets.all(17),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    context.goNamed('login_signup');
                  },
                  child: SvgPicture.asset(
                    r'assets\icon\arrow_left.svg',
                    height: 8.7,
                    width: 13.2,
                  ),
                ),
                Text(
                  "Login",
                  style: TextStyle(
                    color: AppTheme.colors.primaryBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SvgPicture.asset(
                  r'assets\icon\info.svg',
                  height: 15,
                  width: 15,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: AppTheme.colors.secondaryBack,
            width: double.infinity,
            child: Form(
              key: _loginFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    r"assets\icon\logo_brand.png",
                    height: height * 0.22,
                  ),
                  Padding(padding: EdgeInsets.only(bottom: height * 0.08)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: SFTextField(
                      controller: emailController,
                      labelText: "Digite seu e-mail",
                      prefixIcon: SvgPicture.asset(r"assets\icon\email.svg"),
                      pourpose: TextFieldPourpose.Email,
                      validator: emailValidator,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: height * 0.025)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: SFTextField(
                      controller: passwordController,
                      labelText: "Digite sua senha",
                      prefixIcon: SvgPicture.asset(r"assets\icon\lock.svg"),
                      suffixIcon:
                          SvgPicture.asset(r"assets\icon\eye_closed.svg"),
                      suffixIconPressed:
                          SvgPicture.asset(r"assets\icon\eye_open.svg"),
                      pourpose: TextFieldPourpose.Password,
                      validator: passwordValidator,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: height * 0.01)),
                  InkWell(
                    onTap: () {
                      setState(() {
                        showModal = true;
                        modalPourpose = ModalPourpose.Email;
                        modalMessage =
                            "Digite seu e-mail e enviaremos o link para troca de senha";
                        modalImagePath = r"assets\icon\happy_face.svg";
                      });
                    },
                    child: Container(
                      height: height * 0.022,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Text(
                          "Esqueci minha senha",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppTheme.colors.textBlue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: height * 0.1)),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      height: height * 0.05,
                      padding: EdgeInsets.symmetric(horizontal: width * 0.14),
                      child: SFButton(
                        buttonLabel: "Login",
                        buttonType: ButtonType.Primary,
                        onTap: () => validateLogin(context,
                            emailController.text, passwordController.text),
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                  Container(
                    height: height * 0.06,
                    width: MediaQuery.of(context).size.width,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: SvgPicture.asset(
                        r'assets\icon\sand_bar.svg',
                        alignment: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          showModal
              ? Form(
                  key: _forgotPasswordFormKey,
                  child: SFModal(
                    picturePath: modalImagePath!,
                    message: modalMessage!,
                    showModal: showModal,
                    pourpose: modalPourpose,
                    textController: modalController,
                    onTap: () {
                      setState(() {
                        if (modalPourpose == ModalPourpose.Email) {
                          ForgotPassword(context);
                        } else {
                          showModal = false;
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

  Future<void> validateLogin(
      BuildContext context, String email, String password) async {
    if (_loginFormKey.currentState?.validate() == true) {
      var response = await http.post(
        Uri.parse('https://www.sandfriends.com.br/LogIn'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, Object>{
          'Email': email,
          'Password': password,
          'ThirdPartyLogin': false,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        final newAccessToken = responseBody['AccessToken'];

        const storage = FlutterSecureStorage();
        await storage.write(key: "AccessToken", value: newAccessToken);

        if (responseBody['IsNewUser'] == true) {
          context.goNamed('new_user_welcome');
        } else {
          context.goNamed('home');
        }
      } else if (response.statusCode == 404) {
        modalMessage =
            "Você já utilizou esse e-mail para entrar com conta Google"; //link
        modalImagePath = r"assets\icon\sad_face.svg";
        showModal = true;
      } else if (response.statusCode == 405) {
        modalMessage =
            "Antes de começar, confirme seu e-mail com o link que enviamos";
        modalImagePath = r"assets\icon\sad_face.svg";
        showModal = true;
      } else if (response.statusCode == 407) {
        modalMessage = "Você ainda não tem uma conta";
        modalImagePath = r"assets\icon\sad_face.svg";
        showModal = true;
      } else if (response.statusCode == 408) {
        modalMessage = "Senha Incorreta";
        modalImagePath = r"assets\icon\sad_face.svg";
        showModal = true;
      } else {
        print("Erro nao identificado");
      }
      if (showModal) {
        setState(() {});
      }
    }
  }

  Future<void> ForgotPassword(BuildContext context) async {
    if (_forgotPasswordFormKey.currentState?.validate() == true) {
      var response = await http.post(
        Uri.parse('https://www.sandfriends.com.br/ChangePasswordRequest'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, Object>{
          'Email': modalController.text,
        }),
      );

      if (response.statusCode == 200) {
        showModal = true;
        modalMessage =
            "Feito! Enviamos um e-mail para você escolher uma nova senha";
        modalImagePath = r"assets\icon\happy_face.svg";
      } else if (response.statusCode == 407) {
        modalMessage = "Não existe nenhuma conta com esse e-mail";
        modalImagePath = r"assets\icon\sad_face.svg";
        showModal = true;
      } else if (response.statusCode == 405) {
        modalMessage =
            "Você ainda não confirmou seu e-mail. Faça isso antes de qualquer coisa.";
        modalImagePath = r"assets\icon\sad_face.svg";
        showModal = true;
      } else {
        modalMessage = "Erro Inesperado";
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
