import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Components/SFButton.dart';
import 'package:sandfriends/Common/Features/Court/ViewModel/CourtViewModel.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';
import 'package:sandfriends/Common/Utils/SFDateTime.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/LandingPage/View/WebHeader.dart';

import '../../../../Components/SFLoading.dart';
import '../../../../Providers/Environment/EnvironmentProvider.dart';

class CourtWidgetWeb extends StatelessWidget {
  const CourtWidgetWeb({super.key});
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CourtViewModel>(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double imageHeight = 400 > height * 0.4 ? height * 0.4 : 400;
    return Column(
      children: [
        WebHeader(),
        Expanded(
          child: Stack(
            children: [
              Image.asset(
                r"assets/background_beach_tennis.png",
                height: imageHeight,
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),
              Container(
                height: height,
                width: width,
                padding: EdgeInsets.only(top: imageHeight - 50),
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            primaryBlue,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: primaryBlue,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: imageHeight - 100,
                  right: width * 0.1,
                  left: width * 0.1,
                  bottom: defaultPadding,
                ),
                padding: EdgeInsets.all(
                  defaultPadding,
                ),
                decoration: BoxDecoration(
                  color: secondaryPaper,
                  borderRadius: BorderRadius.circular(
                    defaultPadding,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: defaultPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: CachedNetworkImage(
                                    imageUrl: Provider.of<EnvironmentProvider>(
                                            context,
                                            listen: false)
                                        .urlBuilder(viewModel.store!.logo!,
                                            isImage: true),
                                    height: 128,
                                    width: 128,
                                    placeholder: (context, url) => SizedBox(
                                      height: 128,
                                      width: 128,
                                      child: Center(
                                        child: SFLoading(),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      height: 128,
                                      width: 128,
                                      color: textLightGrey.withOpacity(0.5),
                                      child: const Center(
                                        child: Icon(Icons.dangerous),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: defaultPadding,
                                ),
                                Expanded(
                                    child: SizedBox(
                                  height: 100,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        viewModel.store!.name,
                                        style: TextStyle(
                                          color: primaryBlue,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 22,
                                        ),
                                      ),
                                      SizedBox(
                                        height: defaultPadding / 2,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            r'assets/icon/location_ping.svg',
                                            color: textDarkGrey,
                                            width: 20,
                                          ),
                                          SizedBox(
                                            width: defaultPadding / 2,
                                          ),
                                          Expanded(
                                            child: Text(
                                              viewModel.store!.completeAddress,
                                              style: TextStyle(
                                                color: textDarkGrey,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: defaultPadding / 2,
                                      ),
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            r'assets/icon/whatsapp.svg',
                                            color: textDarkGrey,
                                            width: 20,
                                          ),
                                          SizedBox(
                                            width: defaultPadding / 2,
                                          ),
                                          Text(
                                            viewModel.store!.phoneNumber,
                                            style: TextStyle(
                                              color: textDarkGrey,
                                            ),
                                          ),
                                          SizedBox(
                                            width: defaultPadding,
                                          ),
                                          SvgPicture.asset(
                                            r'assets/icon/instagram.svg',
                                            color: textDarkGrey,
                                            width: 20,
                                          ),
                                          SizedBox(
                                            width: defaultPadding / 2,
                                          ),
                                          Text(
                                            viewModel.store!.instagram,
                                            style: TextStyle(
                                              color: textDarkGrey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ))
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
                                    Text(
                                      "Sobre a quadra",
                                      style: TextStyle(
                                        color: primaryBlue,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: defaultPadding / 2,
                                    ),
                                    Text(
                                      viewModel.store!.description,
                                      style: TextStyle(
                                        color: textDarkGrey,
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
                    Container(
                      width: 300,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 128,
                            child: SFButton(
                              buttonLabel: "Agendar Horário",
                              onTap: () {},
                              iconPath: r"assets/icon/calendar.svg",
                            ),
                          ),
                          SizedBox(
                            height: defaultPadding,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                      padding: EdgeInsets.all(defaultPadding),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            defaultBorderRadius,
                                          ),
                                          color: primaryBlue.withOpacity(
                                            0.1,
                                          ),
                                          border:
                                              Border.all(color: primaryBlue)),
                                      child: Column(
                                        children: [
                                          Text(
                                            "Horários de funcionamento",
                                            style: TextStyle(
                                              color: textBlue,
                                              fontSize: 12,
                                            ),
                                          ),
                                          SizedBox(
                                            height: defaultPadding / 2,
                                          ),
                                          viewModel.isLoadingOperationDays
                                              ? SFLoading()
                                              : viewModel.store!
                                                          .operationDays ==
                                                      null
                                                  ? Text(
                                                      "Não foi possível carregar",
                                                      style: TextStyle(
                                                        color: textDarkGrey,
                                                      ),
                                                    )
                                                  : ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount: viewModel
                                                          .store!
                                                          .operationDays!
                                                          .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Padding(
                                                          padding: const EdgeInsets
                                                              .symmetric(
                                                              vertical:
                                                                  defaultPadding /
                                                                      4),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                weekdayFull[viewModel
                                                                    .store!
                                                                    .operationDays![
                                                                        index]
                                                                    .weekday],
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      textDarkGrey,
                                                                ),
                                                              ),
                                                              Text(
                                                                viewModel
                                                                    .store!
                                                                    .operationDays![
                                                                        index]
                                                                    .hoursDescription,
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      textDarkGrey,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
