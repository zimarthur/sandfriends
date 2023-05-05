import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/oldApp/widgets/Modal/SF_Modal.dart';
import 'package:sandfriends/oldApp/widgets/SFAvatar.dart';
import 'package:sandfriends/SharedComponents/View/SFLoading.dart';
import 'package:sandfriends/oldApp/widgets/SF_Button.dart';
import 'package:sandfriends/oldApp/widgets/SF_TextField.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../Utils/Validators.dart';
import '../models/enums.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/Modal/SFModalMessageCopy.dart';

class UserScreen extends StatefulWidget {
  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool showModal = false;
  Widget? modalWidget;
  bool validFeedback = false;

  TextEditingController feedbackController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height - 75;

    return Stack(
      children: [
        Container(
          color: AppTheme.colors.primaryBlue,
          child: SafeArea(
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    context.goNamed('user_detail');
                  },
                  child: SizedBox(
                    height: height * 0.48,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: height * 0.28,
                          child: Column(
                            children: [
                              SFAvatar(
                                height: height * 0.22,
                                showRank: false,
                                user: Provider.of<UserProvider>(context,
                                        listen: false)
                                    .user!,
                                editFile: null,
                              ),
                              SizedBox(
                                height: height * 0.04,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: Text(
                                    "${Provider.of<UserProvider>(context, listen: false).user!.firstName} ${Provider.of<UserProvider>(context, listen: false).user!.lastName}",
                                    style: TextStyle(
                                        color: AppTheme.colors.textWhite),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: height * 0.04),
                          height: height * 0.2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    r'assets\icon\at_email.svg',
                                    color: AppTheme.colors.secondaryPaper,
                                    width: 15,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: width * 0.02),
                                    child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: Text(
                                        "${Provider.of<UserProvider>(context, listen: false).user!.email}",
                                        style: TextStyle(
                                            color: AppTheme.colors.textWhite),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    r'assets\icon\location_ping.svg',
                                    color: AppTheme.colors.secondaryPaper,
                                    width: 15,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: width * 0.02),
                                    child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: Text(
                                        Provider.of<UserProvider>(context,
                                                        listen: false)
                                                    .user!
                                                    .city ==
                                                null
                                            ? "-"
                                            : "${Provider.of<UserProvider>(context, listen: false).user!.city!.city} / ${Provider.of<UserProvider>(context, listen: false).user!.city!.state!.uf}",
                                        style: TextStyle(
                                            color: AppTheme.colors.textWhite),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    r'assets\icon\star.svg',
                                    color: AppTheme.colors.secondaryPaper,
                                    width: 15,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: width * 0.02),
                                    child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: Text(
                                        Provider.of<UserProvider>(context,
                                                        listen: false)
                                                    .user!
                                                    .matchCounter
                                                    .map(
                                                      (e) => e.total,
                                                    )
                                                    .reduce((value, current) =>
                                                        value + current) ==
                                                1
                                            ? "1 jogo"
                                            : "${Provider.of<UserProvider>(context, listen: false).user!.matchCounter.map(
                                                  (e) => e.total,
                                                ).reduce((value, current) => value + current)} jogos",
                                        style: TextStyle(
                                            color: AppTheme.colors.textWhite),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: height * 0.01),
                  child: SvgPicture.asset(
                    r'assets\icon\divider.svg',
                    width: width * 0.9,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.1,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        UserButtons(
                            context, "Meu perfil", r'assets\icon\user.svg', () {
                          context.goNamed('user_detail');
                        }),
                        UserButtons(context, "Minhas partidas",
                            r'assets\icon\trophy.svg', () {
                          context.goNamed('user_match_screen');
                        }),
                        UserButtons(context, "Configurar pagamentos",
                            r'assets\icon\payment.svg', () {
                          context.goNamed('user_detail');
                        }),
                        UserButtons(context, "Fale com a gente",
                            r'assets\icon\chat.svg', () {
                          setState(() {
                            feedbackController.text = "";
                            modalWidget = SFModal(
                              child: SizedBox(
                                height: height * 0.6,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      height: height * 0.4,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.04,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Envie seu feedback!",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: AppTheme.colors.textBlue,
                                            ),
                                            textScaleFactor: 1.2,
                                          ),
                                          Text(
                                            "Escreva aqui sua crítica ou sugestão",
                                            style: TextStyle(
                                                color: AppTheme
                                                    .colors.textDarkGrey),
                                          ),
                                          SFTextField(
                                            minLines: 5,
                                            maxLines: 6,
                                            labelText: "",
                                            pourpose:
                                                TextFieldPourpose.Multiline,
                                            controller: feedbackController,
                                            validator: (a) => max255(a, "a"),
                                            onChanged: (value) {
                                              setState(() {
                                                if (value.isNotEmpty) {
                                                  validFeedback = true;
                                                } else {
                                                  validFeedback = false;
                                                }
                                              });
                                            },
                                          ),
                                          SFButton(
                                            textPadding: EdgeInsets.symmetric(
                                              horizontal: width * 0.04,
                                              vertical: height * 0.02,
                                            ),
                                            buttonLabel: "Enviar",
                                            buttonType: ButtonType.Primary,
                                            onTap: () {
                                              if (validFeedback) {
                                                setState(() {
                                                  modalWidget = SFModal(
                                                    onTapBackground: () {},
                                                    child: SizedBox(
                                                      height: height * 0.6,
                                                      child: const SFLoading(),
                                                    ),
                                                  );
                                                });
                                                sendFeedback();
                                              }
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "ou",
                                      style: TextStyle(
                                        color: AppTheme.colors.textDarkGrey,
                                      ),
                                      textScaleFactor: 0.9,
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.05,
                                      ),
                                      child: SFButton(
                                        buttonLabel:
                                            "Fale com a gente pelo whats",
                                        buttonType: ButtonType.Secondary,
                                        onTap: () {
                                          final url = Uri.parse(
                                              "https://wa.me/+5551996712775");
                                          UrlLauncher(url);
                                        },
                                        iconPath: r"assets\icon\whatsapp.svg",
                                        textPadding: EdgeInsets.symmetric(
                                          horizontal: width * 0.04,
                                          vertical: height * 0.02,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTapBackground: () {
                                setState(() {
                                  showModal = false;
                                });
                              },
                            );
                            showModal = true;
                          });
                        }),
                        UserButtons(context, "Sair", r'assets\icon\logout.svg',
                            () {
                          context.goNamed('login_signup');
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        showModal ? modalWidget! : Container(),
      ],
    );
  }

  void UrlLauncher(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> sendFeedback() async {
    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: "AccessToken");
    if (accessToken != null) {
      var response = await http.post(
        Uri.parse('https://www.sandfriends.com.br/SendFeedback'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, Object>{
          "accessToken": accessToken,
          "message": feedbackController.text,
        }),
      );
      if (mounted) {
        if (response.statusCode == 200) {
          setState(() {
            feedbackController.text = "";
            modalWidget = SFModal(
                child: SFModalMessageCopy(
                    modalStatus: GenericStatus.Success,
                    message: "Obrigado pelo seu comentário!",
                    onTap: () {
                      setState(() {
                        showModal = false;
                      });
                    }),
                onTapBackground: () {
                  setState(() {
                    showModal = false;
                  });
                });
          });
        } else {
          setState(() {
            modalWidget = SFModal(
                child: SFModalMessageCopy(
                    modalStatus: GenericStatus.Failed,
                    message:
                        "Não foi possível enviar seu comentário. Tente novamente",
                    onTap: () {
                      setState(() {
                        showModal = false;
                      });
                    }),
                onTapBackground: () {
                  setState(() {
                    showModal = false;
                  });
                });
          });
        }
      }
    }
  }
}

Widget UserButtons(
  BuildContext context,
  String title,
  String iconPath,
  VoidCallback onTap,
) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height - 75;
  return Material(
    color: Colors.transparent,
    child: InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      highlightColor: AppTheme.colors.primaryDarkBlue,
      onTap: onTap,
      child: Ink(
        color: AppTheme.colors.primaryBlue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  iconPath,
                  height: height * 0.45 * 0.07,
                  color: AppTheme.colors.secondaryPaper,
                ),
                Container(
                  padding: EdgeInsets.only(left: width * 0.03),
                  child: Text(
                    title,
                    style: TextStyle(
                        color: AppTheme.colors.secondaryBack,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
