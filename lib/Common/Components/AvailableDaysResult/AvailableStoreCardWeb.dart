import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../Model/AvailableHour.dart';
import '../../Model/AvailableStore.dart';
import '../../Model/Store/Store.dart';
import '../../Providers/Environment/EnvironmentProvider.dart';
import '../../Utils/Constants.dart';
import '../SFLoading.dart';
import 'AvailableHourCard.dart';

class AvailableStoreCardWeb extends StatefulWidget {
  final AvailableStore availableStore;
  final AvailableHour? selectedAvailableHour;
  final Function(AvailableStore) onTapHour;
  final Function(Store) onGoToCourt;
  final bool selectedParent;
  final bool isRecurrent;
  final VoidCallback resetSelectedAvailableHour;

  const AvailableStoreCardWeb({
    Key? key,
    required this.availableStore,
    required this.selectedAvailableHour,
    required this.onTapHour,
    required this.onGoToCourt,
    required this.selectedParent,
    required this.isRecurrent,
    required this.resetSelectedAvailableHour,
  }) : super(key: key);

  @override
  State<AvailableStoreCardWeb> createState() => _AvailableStoreCardWebState();
}

class _AvailableStoreCardWebState extends State<AvailableStoreCardWeb> {
  ScrollController controller = ScrollController();
  bool isStoreHovered = false;
  @override
  Widget build(BuildContext context) {
    bool isStoreSelected = isStoreHovered | widget.selectedParent;
    return MouseRegion(
      onEnter: (pointer) {
        setState(() {
          isStoreHovered = true;
        });
      },
      onExit: (pointer) {
        setState(() {
          isStoreHovered = false;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        margin: EdgeInsets.symmetric(
            horizontal: defaultPadding, vertical: defaultPadding),
        height: 150,
        decoration: BoxDecoration(
            color: secondaryPaper,
            borderRadius: BorderRadius.circular(
              defaultBorderRadius,
            ),
            boxShadow: [
              BoxShadow(
                color: isStoreSelected ? primaryBlue : divider,
                blurRadius: 5,
                offset: Offset(
                  2.0,
                  5.0,
                ),
              )
            ],
            border: Border.all(color: isStoreSelected ? primaryBlue : divider)),
        padding: EdgeInsets.symmetric(
          horizontal: defaultPadding * 2,
          vertical: defaultPadding,
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          return Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: CachedNetworkImage(
                  imageUrl:
                      Provider.of<EnvironmentProvider>(context, listen: false)
                          .urlBuilder(
                    widget.availableStore.store.logo!,
                    isImage: true,
                  ),
                  height: constraints.maxHeight,
                  width: constraints.maxHeight,
                  placeholder: (context, url) => SizedBox(
                    height: constraints.maxHeight,
                    width: constraints.maxHeight,
                    child: Center(
                      child: SFLoading(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: textLightGrey.withOpacity(0.5),
                    height: constraints.maxHeight,
                    width: constraints.maxHeight,
                    child: const Center(
                      child: Icon(
                        Icons.dangerous,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: defaultPadding,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.availableStore.store.name,
                          style: TextStyle(
                            color: primaryBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: defaultPadding / 4,
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              r"assets/icon/location_ping.svg",
                              color: textDarkGrey,
                            ),
                            SizedBox(
                              width: defaultPadding / 2,
                            ),
                            Text(
                              widget.availableStore.store.neighbourhoodAddress,
                              style: TextStyle(
                                color: textDarkGrey,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () =>
                          widget.onGoToCourt(widget.availableStore.store),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Mais informações",
                            style: TextStyle(
                              color: textBlue,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          SvgPicture.asset(
                            r"assets/icon/chevron_right.svg",
                            color: textBlue,
                            height: 14,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: defaultPadding,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Horários disponíveis",
                      style: TextStyle(color: textDarkGrey),
                    ),
                    SizedBox(
                      height: defaultPadding,
                    ),
                    ConstrainedBox(
                      constraints:
                          BoxConstraints(maxWidth: constraints.maxWidth * 0.5),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              controller.animateTo(
                                controller.offset - constraints.maxWidth * 0.5,
                                duration: Duration(milliseconds: 100),
                                curve: Curves.easeIn,
                              );
                            },
                            child: SvgPicture.asset(
                              r"assets/icon/arrow_left_triangle.svg",
                              height: 30,
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 60,
                              child: ListView.builder(
                                controller: controller,
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemCount:
                                    widget.availableStore.availableHours.length,
                                itemBuilder: ((context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      left: index == 0 ? defaultPadding : 0,
                                      right: index ==
                                              widget.availableStore
                                                      .availableHours.length -
                                                  1
                                          ? defaultPadding
                                          : 0,
                                    ),
                                    child: AvailableHourCard(
                                      hourPrice: widget
                                          .availableStore
                                          .availableHours[index]
                                          .lowestHourPrice,
                                      onTap: (hourPrice) {
                                        List<AvailableHour> avHourList = [];
                                        avHourList.add(widget.availableStore
                                            .availableHours[index]);
                                        final availableStore = AvailableStore(
                                          availableHours: avHourList,
                                          store: widget.availableStore.store,
                                        );
                                        widget.onTapHour(availableStore);
                                      },
                                      isSelected: !widget.selectedParent ||
                                              widget.selectedAvailableHour ==
                                                  null ||
                                              widget.selectedAvailableHour!.hour
                                                      .hour !=
                                                  widget
                                                      .availableStore
                                                      .availableHours[index]
                                                      .hour
                                                      .hour
                                          ? false
                                          : true,
                                      isRecurrent: widget.isRecurrent,
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              controller.animateTo(
                                controller.offset + constraints.maxWidth * 0.5,
                                duration: Duration(milliseconds: 100),
                                curve: Curves.easeIn,
                              );
                            },
                            child: SvgPicture.asset(
                              r"assets/icon/arrow_right_triangle.svg",
                              height: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
