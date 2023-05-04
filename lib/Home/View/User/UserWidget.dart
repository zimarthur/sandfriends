import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Home/View/User/UserCardHome.dart';
import 'package:sandfriends/Home/View/User/UserTileButton.dart';
import 'package:sandfriends/SharedComponents/ViewModel/DataProvider.dart';
import 'package:sandfriends/Utils/Constants.dart';

import '../../../oldApp/widgets/SFAvatar.dart';
import '../../ViewModel/HomeViewModel.dart';

class UserWidget extends StatefulWidget {
  HomeViewModel viewModel;
  UserWidget({
    required this.viewModel,
  });

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
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: height * 0.47,
                child: UserCardHome(
                  viewModel: widget.viewModel,
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
                      UserTileButton(
                        title: "Meu perfil",
                        iconPath: r'assets\icon\user.svg',
                        onTap: () => widget.viewModel.goToUSerDetail(context),
                      ),
                      UserTileButton(
                        title: "Minhas partidas",
                        iconPath: r'assets\icon\trophy.svg',
                        onTap: () =>
                            widget.viewModel.goToUserMatchScreen(context),
                      ),
                      UserTileButton(
                          title: "Configurar pagamentos",
                          iconPath: r'assets\icon\payment.svg',
                          onTap: () {
                            Navigator.pushNamed(context, '/user_detail');
                          }),
                      UserTileButton(
                        title: "Fale com a gente",
                        iconPath: r'assets\icon\chat.svg',
                        onTap: () => widget.viewModel.openAppRatingModal(),
                      ),
                      UserTileButton(
                        title: "Sair",
                        iconPath: r'assets\icon\logout.svg',
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
