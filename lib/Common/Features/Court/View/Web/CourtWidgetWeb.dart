import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Features/Court/View/Web/CourtContactItem.dart';
import 'package:sandfriends/Common/Features/Court/View/Web/CourtWidgetWebPhoto.dart';
import 'package:sandfriends/Common/Managers/LinkOpener/LinkOpenerManager.dart';
import 'package:sandfriends/Common/Utils/TypeExtensions.dart';

import '../../../../../SandfriendsWebPage/Features/LandingPage/View/LandingPageFooter.dart';
import '../../../../../SandfriendsWebPage/Features/LandingPage/View/WebHeader.dart';
import '../../../../Components/SFButton.dart';
import '../../../../Components/SFLoading.dart';
import '../../../../Providers/Environment/EnvironmentProvider.dart';
import '../../../../Utils/Constants.dart';
import '../../../../Utils/SFDateTime.dart';
import '../../ViewModel/CourtViewModel.dart';

class CourtWidgetWeb extends StatefulWidget {
  const CourtWidgetWeb({super.key});

  @override
  State<CourtWidgetWeb> createState() => _CourtWidgetWebState();
}

class _CourtWidgetWebState extends State<CourtWidgetWeb> {
  @override
  Widget build(BuildContext context) {
    //final viewModel = Provider.of<CourtViewModel>(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double imageHeight = 400 > height * 0.4 ? height * 0.4 : 400;
    double pageHorizontalPadding =
        width * 0.9 > 1000 ? (width - 1000) / 2 : width * 0.1;
    return Consumer<CourtViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          children: [
            WebHeader(),
            Expanded(
              child: Container(
                color: secondaryPaper,
                width: width,
                padding:
                    EdgeInsets.symmetric(horizontal: pageHorizontalPadding),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Column(
                      children: [
                        SizedBox(
                          height: defaultPadding / 2,
                        ),
                        CourtWidgetWebPhoto(),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Row(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                        CourtContactItem(
                                          icon:
                                              r'assets/icon/location_ping.svg',
                                          text:
                                              viewModel.store!.completeAddress,
                                          onTap: () =>
                                              LinkOpenerManager().openLink(
                                            context,
                                            "https://maps.google.com/maps?q=${viewModel.store!.latitude},${viewModel.store!.longitude}",
                                          ),
                                          expandedText: true,
                                        ),
                                        SizedBox(
                                          height: defaultPadding / 2,
                                        ),
                                        Row(
                                          children: [
                                            CourtContactItem(
                                              icon: r'assets/icon/whatsapp.svg',
                                              text:
                                                  viewModel.store!.phoneNumber,
                                              onTap: () =>
                                                  LinkOpenerManager().openLink(
                                                context,
                                                "whatsapp://send?phone=${viewModel.store!.phoneNumber}",
                                              ),
                                              expandedText: false,
                                            ),
                                            SizedBox(
                                              width: defaultPadding,
                                            ),
                                            if (viewModel
                                                .store!.instagram.isNotEmpty)
                                              CourtContactItem(
                                                icon:
                                                    r'assets/icon/instagram.svg',
                                                text:
                                                    viewModel.store!.instagram,
                                                onTap: () => LinkOpenerManager()
                                                    .openLink(
                                                  context,
                                                  "https://www.instagram.com/${viewModel.store!.instagram}",
                                                ),
                                                expandedText: false,
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )),
                            SizedBox(
                              width: 300,
                              height: 128,
                              child: viewModel.selectedHourPrices.isEmpty
                                  ? Align(
                                      alignment: Alignment.topCenter,
                                      child: SFButton(
                                        buttonLabel: "Agendar Horário",
                                        onTap: () => viewModel
                                            .setCourtReservationModal(context),
                                        iconPath: r"assets/icon/calendar.svg",
                                      ),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                        color: primaryBlue,
                                        borderRadius: BorderRadius.circular(
                                          defaultBorderRadius,
                                        ),
                                      ),
                                      padding: EdgeInsets.all(
                                        defaultPadding,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                r"assets/icon/calendar.svg",
                                                color: textWhite,
                                                height: 20,
                                              ),
                                              SizedBox(
                                                width: defaultPadding / 2,
                                              ),
                                              Text(
                                                "Dia ${viewModel.selectedDate!.formatDate()} às ${viewModel.selectedHourPrices.first.hour.hourString}",
                                                style: TextStyle(
                                                  color: textWhite,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: defaultPadding / 4,
                                          ),
                                          Text(
                                            "A partir de ${viewModel.selectedHourPrices.first.price.formatPrice()}",
                                            style: TextStyle(
                                              color: textWhite,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          SizedBox(
                                            height: defaultPadding / 2,
                                          ),
                                          SFButton(
                                            buttonLabel: "Escolher quadra",
                                            onTap: () => viewModel
                                                .setCourtReservationModal(
                                                    context),
                                            isPrimary: false,
                                          )
                                        ],
                                      ),
                                    ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
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
                            Container(
                              width: 300,
                              child: Container(
                                padding: EdgeInsets.all(defaultPadding),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      defaultBorderRadius,
                                    ),
                                    color: primaryBlue.withOpacity(
                                      0.1,
                                    ),
                                    border: Border.all(color: primaryBlue)),
                                child: Column(
                                  children: [
                                    Text(
                                      "Horários de funcionamento",
                                      style: TextStyle(
                                          color: textBlue,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: defaultPadding / 2,
                                    ),
                                    viewModel.isLoadingOperationDays
                                        ? SFLoading()
                                        : viewModel.store!.operationDays == null
                                            ? Text(
                                                "Não foi possível carregar",
                                                style: TextStyle(
                                                  color: textDarkGrey,
                                                ),
                                              )
                                            : ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: viewModel.store!
                                                    .operationDays!.length,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical:
                                                            defaultPadding / 4),
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
                                                          style: TextStyle(
                                                            color: textDarkGrey,
                                                          ),
                                                        ),
                                                        Text(
                                                          viewModel
                                                              .store!
                                                              .operationDays![
                                                                  index]
                                                              .hoursDescription,
                                                          style: TextStyle(
                                                            color: textDarkGrey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: defaultPadding,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
