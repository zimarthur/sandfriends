import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../widgets/SF_Button.dart';
import '../../widgets/SF_TextField.dart';
import '../../theme/app_theme.dart';
import '../../widgets/SF_Modal.dart';
import '../../models/enums.dart';
import '../../models/validators.dart';

final _signupFormKey = GlobalKey<FormState>();

class CreateAccountScreen extends StatefulWidget {
  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController modalController = TextEditingController();

  bool showModal = false;
  String? modalMessage;
  String? modalImagePath;

  EnumSignupStatus? signupStatus;

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
                  "Criar Conta",
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
              key: _signupFormKey,
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
                  Padding(padding: EdgeInsets.only(bottom: height * 0.13)),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      height: height * 0.05,
                      padding: EdgeInsets.symmetric(horizontal: width * 0.14),
                      child: SFButton(
                        buttonLabel: "Criar Conta",
                        buttonType: ButtonType.Primary,
                        onTap: () => CreateAccount(context,
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
              ? SFModal(
                  picturePath: modalImagePath!,
                  message: modalMessage!,
                  showModal: showModal,
                  pourpose: ModalPourpose.Alert,
                  textController: modalController,
                  onTap: () {
                    setState(() {
                      showModal = false;
                      if (signupStatus == EnumSignupStatus.Success) {
                        context.goNamed('login_signup');
                      } else if (signupStatus ==
                          EnumSignupStatus.AccountAlreadyExists) {
                        context.goNamed('login');
                      }
                    });
                  },
                )
              : Container()
        ],
      ),
    );
  }

  Future<void> CreateAccount(
      BuildContext context, String email, String password) async {
    if (_signupFormKey.currentState?.validate() == true) {
      var response = await http.post(
        Uri.parse('https://www.sandfriends.com.br/SignIn'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, Object>{
          'Email': email,
          'Password': password,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        final newAccessToken = responseBody['AccessToken'];

        const storage = FlutterSecureStorage();
        await storage.write(key: "AccessToken", value: newAccessToken);

        signupStatus = EnumSignupStatus.Success;
        showModal = true;
        modalMessage =
            "Sua conta foi criada. Valide ela com o e-mail que enviamos";
        modalImagePath = r"assets\icon\happy_face.svg";
      } else if (response.statusCode == 403) {
        modalMessage = "E-mail já cadastrado";
        modalImagePath = r"assets\icon\sad_face.svg";
        signupStatus = EnumSignupStatus.Failed;
        showModal = true;
      } else if (response.statusCode == 404) {
        modalMessage = "E-mail já foi utilizado para entrar com conta Google";
        modalImagePath = r"assets\icon\sad_face.svg";
        signupStatus = EnumSignupStatus.Failed;
        showModal = true;
      } else if (response.statusCode == 405) {
        modalMessage =
            "Sua conta já foi criada. Valide ela com o e-mail que enviamos";
        modalImagePath = r"assets\icon\happy_face.svg";
        signupStatus = EnumSignupStatus.Failed;
        showModal = true;
      } else if (response.statusCode == 409) {
        modalMessage = "Sua conta já está válida, faça login.";
        modalImagePath = r"assets\icon\happy_face.svg";
        signupStatus = EnumSignupStatus.AccountAlreadyExists;
        showModal = true;
      }
      if (showModal) {
        setState(() {});
      }
    }
  }
}
