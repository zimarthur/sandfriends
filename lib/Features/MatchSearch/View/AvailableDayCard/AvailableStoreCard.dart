import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/Features/MatchSearch/View/AvailableDayCard/AvailableHourCard.dart';
import 'package:sandfriends/Features/MatchSearch/ViewModel/MatchSearchViewModel.dart';
import 'package:sandfriends/SharedComponents/Model/AvailableHour.dart';
import 'package:sandfriends/Utils/Heros.dart';

import '../../../../SharedComponents/Model/AvailableStore.dart';
import '../../../../SharedComponents/View/SFLoading.dart';
import '../../../../Utils/Constants.dart';
import '../../../../oldApp/widgets/SF_Button.dart';

class AvailableStoreCard extends StatefulWidget {
  AvailableStore availableStore;
  Function(AvailableStore) onTap;
  MatchSearchViewModel viewModel;
  bool selectedParent;

  AvailableStoreCard({
    required this.availableStore,
    required this.onTap,
    required this.viewModel,
    required this.selectedParent,
  });

  @override
  State<AvailableStoreCard> createState() => _AvailableStoreCardState();
}

class _AvailableStoreCardState extends State<AvailableStoreCard> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: 200,
      padding: EdgeInsets.symmetric(horizontal: width * 0.03),
      margin: EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: secondaryPaper,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: divider,
            width: 0.5,
          ),
          boxShadow: const [
            BoxShadow(
              blurRadius: 2,
              offset: Offset(2, 3),
              color: divider,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: widget.availableStore.store.imageUrl,
                      height: 82,
                      width: 82,
                      placeholder: (context, url) => Container(
                        height: 82,
                        width: 82,
                        child: Center(
                          child: SFLoading(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: textLightGrey.withOpacity(0.5),
                        height: 82,
                        width: 82,
                        child: Center(
                          child: Icon(
                            Icons.dangerous,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(right: 12)),
                  Expanded(
                      child: SizedBox(
                    height: 82,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.availableStore.store.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: primaryBlue,
                          ),
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              r"assets\icon\location_ping.svg",
                              color: primaryBlue,
                            ),
                            SizedBox(
                              width: width * 0.01,
                            ),
                            Text(
                              widget.availableStore.store.address,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
                                color: primaryBlue,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Horários disponíveis",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: textDarkGrey),
                            ),
                            Text(
                              "Selecione o início do jogo",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                  color: textDarkGrey),
                            ),
                          ],
                        )
                      ],
                    ),
                  )),
                ],
              ),
            ),
            Container(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemCount: widget.availableStore.availableHours.length,
                itemBuilder: ((context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? width * 0.03 : 0,
                      right: index ==
                              widget.availableStore.availableHours.length - 1
                          ? width * 0.03
                          : 0,
                    ),
                    child: AvailableHourCard(
                      hourPrice: widget
                          .availableStore.availableHours[index].lowestHourPrice,
                      onTap: (hourPrice) {
                        List<AvailableHour> avHourList = [];
                        avHourList
                            .add(widget.availableStore.availableHours[index]);
                        final availableStore = AvailableStore(
                          availableHours: avHourList,
                          store: widget.availableStore.store,
                        );
                        widget.onTap(availableStore);
                      },
                      isSelected: !widget.selectedParent ||
                              widget.viewModel.selectedHour == null ||
                              widget.viewModel.selectedHour!.hour.hour !=
                                  widget.availableStore.availableHours[index]
                                      .hour.hour
                          ? false
                          : true,
                    ),
                  );
                }),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.03, vertical: height * 0.01),
              child: SFButton(
                buttonLabel: "Prosseguir",
                color: textDisabled,
                textPadding: const EdgeInsets.symmetric(vertical: 5),
                onTap: () {
                  if (widget.selectedParent) {
                    widget.viewModel.goToCourt(
                      context,
                      widget.availableStore.store,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
