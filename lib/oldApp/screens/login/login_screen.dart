import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sandfriends/oldApp/models/user.dart';
import 'package:sandfriends/oldApp/providers/categories_provider.dart';
import 'package:sandfriends/oldApp/providers/match_provider.dart';
import 'package:sandfriends/oldApp/widgets/Modal/SF_ModalInput.dart';
import 'package:sandfriends/oldApp/widgets/Modal/SFModalMessageCopy.dart';
import 'package:sandfriends/oldApp/widgets/SF_Scaffold.dart';

import '../../models/enums.dart';
import '../../providers/user_provider.dart';
import '../../../SharedComponents/View/SFLoading.dart';
import '../../widgets/SF_Button.dart';
import '../../widgets/SF_TextField.dart';
import '../../theme/app_theme.dart';
import '../../models/validators.dart';

final _loginFormKey = GlobalKey<FormState>();
final _forgotPasswordFormKey = GlobalKey<FormState>();

class LoginScreenOld extends StatefulWidget {
  @override
  State<LoginScreenOld> createState() => _LoginScreenOldState();
}

class _LoginScreenOldState extends State<LoginScreenOld> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  TextEditingController modalController = TextEditingController();

  bool isLoading = false;

  bool showModal = false;
  Widget? modalWidget;
  GenericStatus? modalStatus;
  String? modalMessage;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SFScaffold(
      titleText: "Login",
      onTapReturn: () => context.goNamed('login_signup'),
      appBarType: AppBarType.Secondary,
      showModal: showModal,
      modalWidget: modalWidget,
      onTapBackground: () {
        setState(() {
          showModal = false;
        });
      },
      child: Container(
        color: AppTheme.colors.secondaryBack,
        width: double.infinity,
        child: isLoading
            ? Center(
                child: SFLoading(),
              )
            : Form(
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
                          modalStatus = GenericStatus.Success;
                          modalMessage =
                              "Digite seu e-mail e enviaremos o link para troca de senha";
                          modalWidget = SFModalInput(
                              modalStatus: modalStatus!,
                              message: modalMessage!,
                              inputMessage: "digite seu e-mail",
                              formKey: _forgotPasswordFormKey,
                              validator: emailValidator,
                              textController: modalController,
                              textFieldPourpose: TextFieldPourpose.Email,
                              onTap: () => ForgotPassword(context));
                        });
                      },
                      child: SizedBox(
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
                    SizedBox(
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
      setState(() {
        isLoading = true;
      });
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        final responseLogin = responseBody['UserLogin'];

        final newAccessToken = responseLogin['AccessToken'];

        const storage = FlutterSecureStorage();
        await storage.write(key: "AccessToken", value: newAccessToken);

        if (responseLogin['IsNewUser'] == true) {
          Provider.of<UserProvider>(context, listen: false).user = User(
              idUser: -1, firstName: "", lastName: "", photo: "", email: email);
          context.goNamed('new_user_welcome');
        } else {
          final responseUser = responseBody['User'];
          final responseUserMatchCounter = responseBody['MatchCounter'];

          // Provider.of<UserProvider>(context, listen: false).user =
          //     userFromJson(responseUser);

          Provider.of<UserProvider>(context, listen: false)
              .userMatchCounterFromJson(responseUserMatchCounter,
                  Provider.of<CategoriesProvider>(context, listen: false));
          context.goNamed('home', params: {'initialPage': 'feed_screen'});
        }
      } else if (response.statusCode == 404) {
        modalMessage =
            "Você já utilizou esse e-mail para entrar com conta Google"; //link
        modalStatus = GenericStatus.Failed;
        showModal = true;
      } else if (response.statusCode == 405) {
        modalMessage =
            "Antes de começar, confirme seu e-mail com o link que enviamos";
        modalStatus = GenericStatus.Failed;
        showModal = true;
      } else if (response.statusCode == 407) {
        modalMessage = "Você ainda não tem uma conta";
        modalStatus = GenericStatus.Failed;
        showModal = true;
      } else if (response.statusCode == 408) {
        modalMessage = "Senha Incorreta";
        modalStatus = GenericStatus.Failed;
        showModal = true;
      } else {
        print("Erro nao identificado");
      }
      if (showModal) {
        setState(() {
          isLoading = false;
          modalWidget = SFModalMessageCopy(
              modalStatus: modalStatus!,
              message: modalMessage!,
              onTap: () {
                setState(() {
                  showModal = false;
                });
              });
        });
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
        modalStatus = GenericStatus.Success;
      } else if (response.statusCode == 407) {
        modalMessage = "Não existe nenhuma conta com esse e-mail";
        modalStatus = GenericStatus.Failed;
        showModal = true;
      } else if (response.statusCode == 405) {
        modalMessage =
            "Você ainda não confirmou seu e-mail. Faça isso antes de qualquer coisa.";
        modalStatus = GenericStatus.Failed;
        showModal = true;
      } else {
        modalMessage = "Erro Inesperado";
        modalStatus = GenericStatus.Failed;
        showModal = true;
      }
      if (showModal) {
        setState(() {
          modalWidget = SFModalMessageCopy(
            modalStatus: modalStatus!,
            message: modalMessage!,
            onTap: () {
              setState(() {
                modalController.text = "";
                showModal = false;
              });
            },
          );
        });
      }
    }
  }
}