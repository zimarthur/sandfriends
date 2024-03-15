import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Components/SFTextField.dart';
import 'package:sandfriends/Common/Features/UserDetails/View/Modal/UserDetailsRankList.dart';
import 'package:sandfriends/Common/Features/UserDetails/View/Web/SportFavorite.dart';
import 'package:sandfriends/Common/Providers/Categories/CategoriesProvider.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/LandingPage/View/WebHeader.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../../../../Sandfriends/Providers/UserProvider/UserProvider.dart';
import '../../../../Components/SFAvatarUser.dart';
import '../../../../Components/SFButton.dart';
import '../../../../Utils/Constants.dart';
import '../../../../Utils/Validators.dart';
import '../../ViewModel/UserDetailsViewModel.dart';
import '../UserDetailsCard.dart';
import '../UserDetailsEmail.dart';
import '../UserDetailsPhoneNumber.dart';
import '../UserDetailsSportSelector.dart';

class UserDetailsWidgetWeb extends StatefulWidget {
  final UserDetailsViewModel viewModel;
  const UserDetailsWidgetWeb({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  State<UserDetailsWidgetWeb> createState() => _UserDetailsWidgetWebState();
}

class _UserDetailsWidgetWebState extends State<UserDetailsWidgetWeb> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        WebHeader(
          showSport: false,
        ),
        Expanded(
          child: Container(
            color: secondaryBackWeb,
            width: width,
            height: height,
            padding: EdgeInsets.symmetric(
              horizontal: width * (1 - defaultWebScreenWidth),
              vertical: defaultPadding,
            ),
            child: Row(
              children: [
                Container(
                  width: 300,
                  height: height,
                  padding: EdgeInsets.all(defaultPadding),
                  decoration: BoxDecoration(
                    color: primaryBlue,
                    borderRadius: BorderRadius.circular(
                      defaultBorderRadius,
                    ),
                    border: Border.all(
                      color: primaryLightBlue,
                      width: 5,
                    ),
                  ),
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () => widget.viewModel
                                  .openUserDetailsModal(
                                      UserDetailsModals.Photo, context),
                              child: SizedBox(
                                height: 150,
                                width: 150 + (25 * 2),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: SFAvatarUser(
                                        showRank: false,
                                        height: 150,
                                        sport: widget.viewModel.displayedSport,
                                        user: widget.viewModel.userEdited,
                                        editFile: widget.viewModel.noImage
                                            ? null
                                            : widget.viewModel.imagePicker,
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: SvgPicture.asset(
                                        r'assets/icon/edit.svg',
                                        color: primaryBlue,
                                        width: 25,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: defaultPadding,
                            ),
                            Text(
                              "${widget.viewModel.userEdited.firstName} ${widget.viewModel.userEdited.lastName}",
                              style: TextStyle(
                                color: textWhite,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                            SizedBox(
                              height: 2 * defaultPadding,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  r'assets/icon/at_email.svg',
                                  color: textWhite,
                                ),
                                SizedBox(
                                  width: defaultPadding / 2,
                                ),
                                Text(
                                  widget.viewModel.userEdited.email,
                                  style: TextStyle(
                                    color: textWhite,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: defaultPadding / 2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  r'assets/icon/location_ping.svg',
                                  color: textWhite,
                                ),
                                SizedBox(
                                  width: defaultPadding / 2,
                                ),
                                Text(
                                  widget.viewModel.userEdited.city!.cityState,
                                  style: TextStyle(
                                    color: textWhite,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: defaultPadding / 2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  r'assets/icon/star.svg',
                                  color: textWhite,
                                ),
                                SizedBox(
                                  width: defaultPadding / 2,
                                ),
                                Text(
                                  Provider.of<UserProvider>(context,
                                                  listen: false)
                                              .user!
                                              .getUserTotalMatches() ==
                                          1
                                      ? "1 jogo"
                                      : "${Provider.of<UserProvider>(context, listen: false).user!.getUserTotalMatches()} jogos",
                                  style: TextStyle(
                                    color: textWhite,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (widget.viewModel.isEdited)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          left: 0,
                          child: Container(
                            margin: EdgeInsets.all(
                              defaultPadding / 2,
                            ),
                            decoration: BoxDecoration(
                              color: secondaryPaper,
                              borderRadius: BorderRadius.circular(
                                defaultBorderRadius,
                              ),
                            ),
                            padding: EdgeInsets.all(defaultPadding / 2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Você fez alterações no seu perfil",
                                  style: TextStyle(
                                    color: primaryBlue,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: defaultPadding / 2,
                                ),
                                SFButton(
                                  buttonLabel: "Salvar alterações",
                                  onTap: () => widget.viewModel.updateUserInfo(
                                    context,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                    ],
                  ),
                ),
                SizedBox(
                  width: defaultPadding,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Suas informações",
                            style: TextStyle(
                              color: textDarkGrey,
                            ),
                          ),
                          SizedBox(
                            width: defaultPadding / 2,
                          ),
                          Expanded(
                            child: Container(
                              color: textDarkGrey,
                              height: 0.5,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: defaultPadding,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: SFTextField(
                                      labelText: "Nome",
                                      pourpose: TextFieldPourpose.Standard,
                                      controller:
                                          widget.viewModel.firstNameController,
                                      validator: nameValidator,
                                    ),
                                  ),
                                  SizedBox(
                                    width: defaultPadding / 2,
                                  ),
                                  Expanded(
                                    child: SFTextField(
                                      labelText: "Sobrenome",
                                      pourpose: TextFieldPourpose.Standard,
                                      controller:
                                          widget.viewModel.lastNameController,
                                      validator: lastNameValidator,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: defaultPadding,
                              ),
                              Text("Cidade"),
                              SizedBox(
                                height: defaultPadding / 2,
                              ),
                              SFButton(
                                iconFirst: true,
                                buttonLabel: widget
                                        .viewModel.userEdited.city?.cityState ??
                                    "Selecione sua cidade",
                                isPrimary: false,
                                iconPath: r"assets/icon/location_ping.svg",
                                onTap: () {
                                  widget.viewModel.openUserDetailsModal(
                                    UserDetailsModals.Region,
                                    context,
                                  );
                                },
                              ),
                              SizedBox(
                                height: defaultPadding,
                              ),
                              Text("Gênero"),
                              SizedBox(
                                height: defaultPadding / 2,
                              ),
                              Row(
                                children: [
                                  for (var gender
                                      in Provider.of<CategoriesProvider>(
                                              context,
                                              listen: false)
                                          .genders)
                                    Expanded(
                                      child: InkWell(
                                        onTap: () => widget.viewModel
                                            .setUserGender(context, gender),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: defaultPadding / 2,
                                          ),
                                          margin: EdgeInsets.symmetric(
                                              horizontal: defaultPadding / 4),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              defaultBorderRadius,
                                            ),
                                            color: secondaryPaper,
                                            border: Border.all(
                                              color: gender.idGender ==
                                                      widget
                                                          .viewModel
                                                          .userEdited
                                                          .gender!
                                                          .idGender
                                                  ? primaryBlue
                                                  : divider,
                                            ),
                                          ),
                                          child: AutoSizeText(
                                            gender.name,
                                            minFontSize: 10,
                                            maxFontSize: 14,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: gender.idGender ==
                                                      widget
                                                          .viewModel
                                                          .userEdited
                                                          .gender!
                                                          .idGender
                                                  ? textBlue
                                                  : textDarkGrey,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                ],
                              ),
                              SizedBox(
                                height: defaultPadding,
                              ),
                              Text("Mão/Pé"),
                              SizedBox(
                                height: defaultPadding / 2,
                              ),
                              Row(
                                children: [
                                  for (var side
                                      in Provider.of<CategoriesProvider>(
                                              context,
                                              listen: false)
                                          .sidePreferences)
                                    Expanded(
                                      child: InkWell(
                                        onTap: () => widget.viewModel
                                            .setUserSidePreference(
                                                context, side),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: defaultPadding / 2,
                                          ),
                                          margin: EdgeInsets.symmetric(
                                              horizontal: defaultPadding / 4),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              defaultBorderRadius,
                                            ),
                                            color: secondaryPaper,
                                            border: Border.all(
                                              color: side.idSidePreference ==
                                                      widget
                                                          .viewModel
                                                          .userEdited
                                                          .sidePreference!
                                                          .idSidePreference
                                                  ? primaryBlue
                                                  : divider,
                                            ),
                                          ),
                                          child: AutoSizeText(
                                            side.name,
                                            minFontSize: 10,
                                            maxFontSize: 14,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: side.idSidePreference ==
                                                      widget
                                                          .viewModel
                                                          .userEdited
                                                          .sidePreference!
                                                          .idSidePreference
                                                  ? textBlue
                                                  : textDarkGrey,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                ],
                              ),
                              SizedBox(
                                height: defaultPadding,
                              ),
                              SFTextField(
                                labelText: "Celular",
                                pourpose: TextFieldPourpose.Numeric,
                                controller:
                                    widget.viewModel.phoneNumberController,
                                validator: phoneNumberValidator,
                              ),
                              Text(
                                "Nenhum jogador terá acesso ao seu celular",
                                style: TextStyle(
                                  color: textDarkGrey,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(
                                height: defaultPadding,
                              ),
                              SFTextField(
                                labelText: "Aniversário",
                                pourpose: TextFieldPourpose.Numeric,
                                controller: widget.viewModel.birthdayController,
                                validator: (a) => birthdayValidator(a),
                              ),
                              Text(
                                "A sua idade será categorizada em faixas de idade. Ninguém terá acesso à sua idade exata.",
                                style: TextStyle(
                                  color: textDarkGrey,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(
                                height: defaultPadding,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: defaultPadding,
                ),
                SizedBox(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Ranks",
                            style: TextStyle(
                              color: textDarkGrey,
                            ),
                          ),
                          SizedBox(
                            width: defaultPadding / 2,
                          ),
                          Expanded(
                              child: Container(
                            color: textDarkGrey,
                            height: 0.5,
                          ))
                        ],
                      ),
                      SizedBox(
                        height: defaultPadding,
                      ),
                      UserDetailsSportSelector(
                        viewModel: widget.viewModel,
                      ),
                      SizedBox(
                        height: defaultPadding,
                      ),
                      Expanded(
                        child: UserDetailsRankList(
                          viewModel: widget.viewModel,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
