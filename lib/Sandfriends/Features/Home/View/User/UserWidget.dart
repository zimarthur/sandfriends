import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../Common/Utils/Constants.dart';
import '../../ViewModel/HomeViewModel.dart';
import 'UserCardHome.dart';
import 'UserTileButton.dart';

class UserWidget extends StatefulWidget {
  final HomeViewModel viewModel;
  const UserWidget({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  State<UserWidget> createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (layoutContext, layoutConstraints) {
      double height = layoutConstraints.maxHeight;
      double width = layoutConstraints.maxWidth;
      return Container(
        color: primaryBlue,
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.05,
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: height * 0.45,
                child: Stack(
                  children: [
                    UserCardHome(
                      viewModel: widget.viewModel,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: const EdgeInsets.only(top: defaultPadding / 2),
                        height: 60,
                        width: 60,
                        child: InkWell(
                          onTap: () =>
                              widget.viewModel.showAppInfoModal(context),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: SvgPicture.asset(
                              r'assets/icon/info_circle.svg',
                              height: 30,
                              width: 30,
                              color: secondaryBack,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: height * 0.01),
                color: divider,
                height: 1,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.05,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      UserTileButton(
                        title: "Meu perfil",
                        iconPath: r'assets/icon/user.svg',
                        onTap: () => widget.viewModel.goToUSerDetail(context),
                      ),
                      UserTileButton(
                        title: "Minhas partidas",
                        iconPath: r'assets/icon/trophy.svg',
                        onTap: () =>
                            widget.viewModel.goToUserMatchScreen(context),
                      ),
                      UserTileButton(
                          title: "Configurar pagamentos",
                          iconPath: r'assets/icon/payment.svg',
                          onTap: () {
                            Navigator.pushNamed(context, '/payment');
                          }),
                      UserTileButton(
                        title: "Fale com a gente",
                        iconPath: r'assets/icon/chat.svg',
                        onTap: () => widget.viewModel.openAppRatingModal(),
                      ),
                      UserTileButton(
                        title: "Sair",
                        iconPath: r'assets/icon/logout.svg',
                        onTap: () => widget.viewModel.logOff(context),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
