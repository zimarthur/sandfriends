import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Components/SFAvatarStore.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';
import 'package:sandfriends/Common/Model/AvailableHour.dart';
import 'package:geolocator/geolocator.dart';

import '../../../Common/Providers/Environment/EnvironmentProvider.dart';
import '../../../Common/Model/AvailableStore.dart';
import '../../Model/Store/StoreComplete.dart';
import '../../Model/Store/StoreUser.dart';
import '../SFButton.dart';
import '../SFLoading.dart';
import '../../../Common/Utils/Constants.dart';
import 'AvailableHourCard.dart';

class AvailableStoreCard extends StatefulWidget {
  final AvailableStore availableStore;
  final AvailableHour? selectedAvailableHour;
  final Function(AvailableStore) onTapHour;
  final Function(StoreUser) onGoToCourt;
  final bool selectedParent;
  final bool isRecurrent;

  const AvailableStoreCard({
    Key? key,
    required this.availableStore,
    required this.selectedAvailableHour,
    required this.onTapHour,
    required this.onGoToCourt,
    required this.selectedParent,
    required this.isRecurrent,
  }) : super(key: key);

  @override
  State<AvailableStoreCard> createState() => _AvailableStoreCardState();
}

class _AvailableStoreCardState extends State<AvailableStoreCard> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: 220,
      padding: EdgeInsets.symmetric(horizontal: width * 0.03),
      margin: const EdgeInsets.only(bottom: 16),
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
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        imageUrl: Provider.of<EnvironmentProvider>(context,
                                listen: false)
                            .urlBuilder(
                          widget.availableStore.store.logo!,
                          isImage: true,
                        ),
                        height: 82,
                        width: 82,
                        placeholder: (context, url) => SizedBox(
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
                          child: const Center(
                            child: Icon(
                              Icons.dangerous,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(right: 12)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.availableStore.store.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: widget.isRecurrent
                                  ? primaryLightBlue
                                  : primaryBlue,
                            ),
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    r"assets/icon/location_ping.svg",
                                    color: widget.isRecurrent
                                        ? primaryLightBlue
                                        : primaryBlue,
                                    width: 20,
                                  ),
                                  SizedBox(
                                    width: width * 0.01,
                                  ),
                                  Expanded(
                                    child: Text(
                                      widget.availableStore.store
                                          .neighbourhoodAddress,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10,
                                        color: widget.isRecurrent
                                            ? primaryLightBlue
                                            : primaryBlue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (Provider.of<UserProvider>(context)
                                      .userLocation !=
                                  null)
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      r"assets/icon/distance_between.svg",
                                      color: widget.isRecurrent
                                          ? primaryLightBlue
                                          : primaryBlue,
                                      width: 20,
                                    ),
                                    SizedBox(
                                      width: width * 0.01,
                                    ),
                                    Expanded(
                                      child: Text(
                                        "${(Geolocator.distanceBetween(Provider.of<UserProvider>(context).userLocation!.latitude, Provider.of<UserProvider>(context).userLocation!.longitude, widget.availableStore.store.latitude, widget.availableStore.store.longitude) / 1000).toStringAsFixed(2)} km de você",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10,
                                          color: widget.isRecurrent
                                              ? primaryLightBlue
                                              : primaryBlue,
                                        ),
                                      ),
                                    ),
                                  ],
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
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
                        widget.onTapHour(availableStore);
                      },
                      isSelected: !widget.selectedParent ||
                              widget.selectedAvailableHour == null ||
                              widget.selectedAvailableHour!.hour.hour !=
                                  widget.availableStore.availableHours[index]
                                      .hour.hour
                          ? false
                          : true,
                      isRecurrent: widget.isRecurrent,
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
                color: widget.selectedParent
                    ? widget.isRecurrent
                        ? primaryLightBlue
                        : primaryBlue
                    : textDisabled,
                textPadding: const EdgeInsets.symmetric(vertical: 5),
                onTap: () {
                  if (widget.selectedParent) {
                    widget.onGoToCourt(
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
