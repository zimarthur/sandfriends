import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Utils/Constants.dart';

import '../../../SharedComponents/ViewModel/DataProvider.dart';
import '../../ViewModel/HomeViewModel.dart';
import 'FeedHeader.dart';

class FeedWidget extends StatefulWidget {
  HomeViewModel viewModel;
  FeedWidget({
    required this.viewModel,
  });

  @override
  State<FeedWidget> createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (layoutContext, layoutConstraints) {
      double width = layoutConstraints.maxWidth;
      double height = layoutConstraints.maxHeight;
      return Container(
        color: secondaryBack,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FeedHeader(
              viewModel: widget.viewModel,
              height: MediaQuery.of(context).padding.top + height * 0.07,
              width: width,
            ),
            RefreshIndicator(
              onRefresh: GetUserInfo,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Container(
                  height: height -
                      (MediaQuery.of(context).padding.top + height * 0.07) -
                      60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: width * 0.02),
                        width: width * 0.5,
                        height: height * 0.07,
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            "Olá, ${Provider.of<DataProvider>(context).user!.firstName}!",
                            style: TextStyle(
                              color: primaryBlue,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              left: width * 0.02,
                              right: width * 0.02,
                              top: height * 0.01,
                            ),
                            height: height * 0.025,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      r"assets\icon\court.svg",
                                      color: primaryBlue,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        right: width * 0.02,
                                      ),
                                    ),
                                    Text(
                                      "Próximas Partidas",
                                      style: TextStyle(
                                        color: primaryBlue,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height * 0.25,
                            child: Provider.of<UserProvider>(context)
                                    .nextMatchList
                                    .isEmpty
                                ? Container(
                                    alignment: Alignment.topCenter,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.03,
                                        vertical: height * 0.02),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: width * 0.03,
                                        vertical: height * 0.02),
                                    height: height * 0.15,
                                    decoration: BoxDecoration(
                                      color: divider,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            "Você não tem nenhuma partida agendada",
                                            style: TextStyle(
                                              color: textWhite,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: height * 0.01),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              Provider.of<Redirect>(context,
                                                      listen: false)
                                                  .selectedPageIndex = 2;
                                              Provider.of<Redirect>(context,
                                                      listen: false)
                                                  .goto(2);
                                            });
                                            Provider.of<Redirect>(context,
                                                    listen: false)
                                                .notifyListeners();
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                r"assets\icon\navigation\schedule_screen_selected.svg",
                                                height: height * 0.025,
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      right: width * 0.02)),
                                              Flexible(
                                                child: Text(
                                                  "Agende já seu horário",
                                                  style: TextStyle(
                                                    color: textBlue,
                                                    fontWeight: FontWeight.w700,
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount:
                                        Provider.of<UserProvider>(context)
                                            .nextMatchList
                                            .length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          context
                                              .goNamed('match_screen', params: {
                                            'matchUrl':
                                                Provider.of<UserProvider>(
                                                        context,
                                                        listen: false)
                                                    .nextMatchList[index]
                                                    .matchUrl,
                                            'returnTo': 'home',
                                            'returnToParam': 'initialPage',
                                            'returnToParamValue': 'feed_screen',
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: width * 0.02,
                                              vertical: height * 0.01),
                                          width: width * 0.55,
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: textLightGrey,
                                                blurRadius: 2.0,
                                                spreadRadius: 0.0,
                                                offset: const Offset(1.0, 1.0),
                                              )
                                            ],
                                            color: secondaryPaper,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Stack(
                                            children: [
                                              Container(
                                                height: height * 0.15,
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(16),
                                                    topRight:
                                                        Radius.circular(16),
                                                  ),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(16),
                                                    topRight:
                                                        Radius.circular(16),
                                                  ),
                                                  child: CachedNetworkImage(
                                                    imageUrl: Provider.of<
                                                                UserProvider>(
                                                            context)
                                                        .nextMatchList[index]
                                                        .sport
                                                        .photoUrl,
                                                    width: width * 0.55,
                                                    fit: BoxFit.fill,
                                                    placeholder:
                                                        (context, url) =>
                                                            Center(
                                                      child: SFLoading(),
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Center(
                                                      child:
                                                          Icon(Icons.dangerous),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                left: width * 0.02,
                                                top: height * 0.07,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: secondaryPaper
                                                        .withOpacity(0.9),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                  ),
                                                  height: height * 0.07,
                                                  width: height * 0.07,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        height: height * 0.03,
                                                        child: FittedBox(
                                                          fit: BoxFit.fitHeight,
                                                          child: Text(
                                                            "${Provider.of<UserProvider>(context).nextMatchList[index].date.day}",
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: height * 0.025,
                                                        child: FittedBox(
                                                          fit: BoxFit.fitHeight,
                                                          child: Text(
                                                            "${Provider.of<CategoriesProvider>(context, listen: false).monthsPortuguese[Provider.of<UserProvider>(context).nextMatchList[index].date.month - 1]}",
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: height * 0.15,
                                                child: Container(
                                                  height: height * 0.08,
                                                  width: width * 0.55,
                                                  padding: EdgeInsets.only(
                                                      left: width * 0.02),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      SizedBox(
                                                        height: height * 0.03,
                                                        child: FittedBox(
                                                          fit: BoxFit.fitWidth,
                                                          child: Text(
                                                            "Partida de ${Provider.of<UserProvider>(context).nextMatchList[index].matchCreator.firstName}",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: textBlue,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: width * 0.01),
                                                        height: height * 0.02,
                                                        width: width * 0.55,
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: FittedBox(
                                                          fit: BoxFit.fitHeight,
                                                          child: Row(
                                                            children: [
                                                              SvgPicture.asset(
                                                                r"assets\icon\clock.svg",
                                                                color:
                                                                    textDarkGrey,
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets.only(
                                                                    right: width *
                                                                        0.01),
                                                              ),
                                                              Text(
                                                                "${Provider.of<UserProvider>(context).nextMatchList[index].timeBegin} - ${Provider.of<UserProvider>(context).nextMatchList[index].timeFinish}",
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      textDarkGrey,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: width * 0.01),
                                                        height: height * 0.02,
                                                        width: width * 0.55,
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: FittedBox(
                                                          fit: BoxFit.fitHeight,
                                                          child: Row(
                                                            children: [
                                                              SvgPicture.asset(
                                                                r"assets\icon\location_ping.svg",
                                                                color:
                                                                    textDarkGrey,
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets.only(
                                                                    right: width *
                                                                        0.01),
                                                              ),
                                                              Text(
                                                                Provider.of<UserProvider>(
                                                                        context)
                                                                    .nextMatchList[
                                                                        index]
                                                                    .court
                                                                    .store
                                                                    .name,
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      textDarkGrey,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: width * 0.02),
                        height: height * 0.16,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () =>
                                  context.goNamed('recurrent_match_screen'),
                              child: Container(
                                alignment: Alignment.topCenter,
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.03,
                                    vertical: height * 0.02),
                                width: width * 0.47,
                                height: height * 0.15,
                                decoration: BoxDecoration(
                                  color: primaryLightBlue,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.restore,
                                      color: textWhite,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(right: width * 0.02),
                                    ),
                                    Flexible(
                                      child: Text(
                                        "Área do Mensalista",
                                        style: TextStyle(
                                          color: textWhite,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: Provider.of<UserProvider>(context,
                                              listen: false)
                                          .openMatchesCounter >
                                      0
                                  ? () => context.goNamed('open_matches_screen')
                                  : () {},
                              child: Container(
                                alignment: Alignment.topCenter,
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.03,
                                    vertical: height * 0.02),
                                width: width * 0.47,
                                height: height * 0.15,
                                decoration: BoxDecoration(
                                  color: primaryDarkBlue,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                      r"assets\icon\trophy.svg",
                                      color: textWhite,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(right: width * 0.02),
                                    ),
                                    Flexible(
                                      child: Text(
                                        Provider.of<UserProvider>(context,
                                                        listen: false)
                                                    .openMatchesCounter ==
                                                0
                                            ? "Não há partidas abertas perto de você"
                                            : Provider.of<UserProvider>(context,
                                                            listen: false)
                                                        .openMatchesCounter ==
                                                    1
                                                ? "Existe 1 partida aberta perto de você"
                                                : "Existem ${Provider.of<UserProvider>(context, listen: false).openMatchesCounter} partidas abertas perto de você",
                                        style: TextStyle(
                                          color: textWhite,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => context.goNamed('reward_screen'),
                        child: Container(
                          alignment: Alignment.topCenter,
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.03,
                              vertical: height * 0.02),
                          margin:
                              EdgeInsets.symmetric(horizontal: width * 0.02),
                          height: height * 0.15,
                          decoration: BoxDecoration(
                            color: secondaryYellow,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    r"assets\icon\star.svg",
                                    color: textWhite,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(right: width * 0.02),
                                  ),
                                  Text(
                                    "Recompensas (${Provider.of<UserProvider>(context, listen: false).userReward!.userRewardQuantity!}/${Provider.of<UserProvider>(context, listen: false).userReward!.rewardQuantity})",
                                    style: TextStyle(
                                      color: textWhite,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                height: height * 0.07,
                                alignment: Alignment.center,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: Provider.of<UserProvider>(context,
                                          listen: false)
                                      .userReward!
                                      .rewardQuantity,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: width * 0.015),
                                      padding: EdgeInsets.all(height * 0.01),
                                      height: height * 0.07,
                                      width: height * 0.07,
                                      decoration: BoxDecoration(
                                        color: secondaryPaper,
                                        borderRadius: BorderRadius.circular(
                                            height * 0.035),
                                      ),
                                      child: Provider.of<UserProvider>(context,
                                                      listen: false)
                                                  .userReward!
                                                  .userRewardQuantity! >
                                              index
                                          ? SvgPicture.asset(
                                              r"assets\icon\sandfriends_logo.svg",
                                            )
                                          : Container(),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
