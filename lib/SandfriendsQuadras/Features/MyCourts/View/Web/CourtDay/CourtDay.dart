import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Model/HourPrice/HourPriceStore.dart';
import '../../../../../../Common/Components/SFDivider.dart';
import '../../../../../../Common/Model/OperationDayStore.dart';
import '../../../../../../Common/Providers/CategoriesProvider/CategoriesProvider.dart';
import '../../../../../../Common/Utils/Constants.dart';
import '../../../ViewModel/MyCourtsViewModel.dart';
import 'PriceRuleRadio.dart';
import 'PriceSelector.dart';
import 'PriceSelectorHeader.dart';
import 'ResumedInfoRow.dart';

class CourtDay extends StatefulWidget {
  double width;
  double height;
  OperationDayStore operationDay;
  MyCourtsViewModel viewModel;

  CourtDay({
    super.key,
    required this.width,
    required this.height,
    required this.operationDay,
    required this.viewModel,
  });

  @override
  State<CourtDay> createState() => _CourtDayState();
}

class _CourtDayState extends State<CourtDay> {
  double borderSize = 2;
  double editIconWidth = 50;

  TextEditingController controller = TextEditingController();
  double arrowHeight = 25;

  List<HourPriceStore> priceRules = [];

  bool forceIsPriceCustom = false;

  @override
  Widget build(BuildContext context) {
    double mainRowHeight = widget.height - 2 * borderSize;
    double secondaryRowHeight = mainRowHeight * 0.7;
    int numberRules = widget.operationDay.priceRules.length;
    double standardHeight =
        mainRowHeight * 2 + secondaryRowHeight + mainRowHeight;
    double customHeight =
        mainRowHeight * 2 + secondaryRowHeight + numberRules * mainRowHeight;
    bool isPriceCustom =
        widget.operationDay.priceRules.length > 1 || forceIsPriceCustom;
    double expandedHeight = isPriceCustom
        ? customHeight - mainRowHeight - 2
        : standardHeight - mainRowHeight - 2;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: widget.operationDay.isExpanded
          ? isPriceCustom
              ? customHeight + borderSize + arrowHeight
              : standardHeight + borderSize + arrowHeight
          : widget.height,
      width: widget.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
          color: primaryBlue),
      padding: EdgeInsets.all(borderSize),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: widget.operationDay.isExpanded
                        ? isPriceCustom
                            ? customHeight
                            : standardHeight
                        : mainRowHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(defaultBorderRadius),
                      color: secondaryPaper,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                right: widget.operationDay.isExpanded
                                    ? editIconWidth
                                    : 0),
                            height: mainRowHeight,
                            child: ResumedInfoRow(
                                operationDay: widget.operationDay,
                                isEditing: widget.operationDay.isExpanded,
                                rowHeight: mainRowHeight,
                                setAllowRecurrent: (newValue) {
                                  Provider.of<MyCourtsViewModel>(context,
                                          listen: false)
                                      .setAllowRecurrent(
                                    widget.operationDay,
                                    newValue,
                                  );
                                }),
                          ),
                          AnimatedSize(
                              duration: const Duration(milliseconds: 200),
                              child: widget.operationDay.isExpanded
                                  ? Container(
                                      height: expandedHeight,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: defaultPadding),
                                      child: Column(
                                        children: [
                                          const SFDivider(),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            height: mainRowHeight,
                                            child: const Text(
                                              "Regra de preço",
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    PriceSelectorRadio(
                                                        height:
                                                            secondaryRowHeight,
                                                        isPriceStandard:
                                                            isPriceCustom,
                                                        onChangeIsCustom:
                                                            (value) {
                                                          setState(() {
                                                            if (value != null) {
                                                              forceIsPriceCustom =
                                                                  value;
                                                            }
                                                          });
                                                          Provider.of<MyCourtsViewModel>(
                                                                  context,
                                                                  listen: false)
                                                              .setIsPriceStandard(
                                                            widget.operationDay,
                                                            value!,
                                                          );
                                                        }),
                                                  ],
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height:
                                                            secondaryRowHeight,
                                                        child:
                                                            PriceSelectorHeader(
                                                          allowRecurrent: widget
                                                              .operationDay
                                                              .allowReccurrent,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: ListView.builder(
                                                          itemCount: widget
                                                              .operationDay
                                                              .priceRules
                                                              .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return PriceSelector(
                                                              allowRecurrent: widget
                                                                  .operationDay
                                                                  .allowReccurrent,
                                                              priceRule: widget
                                                                  .operationDay
                                                                  .priceRules[index],
                                                              height:
                                                                  mainRowHeight,
                                                              availableHours: Provider.of<
                                                                          CategoriesProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .hours
                                                                  .where(
                                                                      (hour) {
                                                                var validDay = widget
                                                                    .viewModel
                                                                    .storeWorkingDays
                                                                    .firstWhere((workingDay) =>
                                                                        workingDay
                                                                            .weekday ==
                                                                        widget
                                                                            .operationDay
                                                                            .weekday);
                                                                return hour.hour >=
                                                                        validDay
                                                                            .startingHour!
                                                                            .hour &&
                                                                    hour.hour <=
                                                                        validDay
                                                                            .endingHour!
                                                                            .hour;
                                                              }).toList(),
                                                              editHour:
                                                                  isPriceCustom,
                                                              onChangedStartingHour: (oldHour,
                                                                      newHour) =>
                                                                  widget
                                                                      .viewModel
                                                                      .onChangedRuleStartingHour(
                                                                context,
                                                                widget
                                                                    .operationDay,
                                                                oldHour,
                                                                newHour,
                                                              ),
                                                              onChangedEndingHour: (oldHour,
                                                                      newHour) =>
                                                                  widget
                                                                      .viewModel
                                                                      .onChangedRuleEndingHour(
                                                                context,
                                                                widget
                                                                    .operationDay,
                                                                oldHour,
                                                                newHour,
                                                              ),
                                                              onChangedPrice: (newPrice,
                                                                      priceRule,
                                                                      controller) =>
                                                                  widget.viewModel.onChangedPrice(
                                                                      newPrice,
                                                                      priceRule,
                                                                      widget
                                                                          .operationDay,
                                                                      false,
                                                                      controller),
                                                              onChangedRecurrentPrice: (newPrice,
                                                                      priceRule,
                                                                      controller) =>
                                                                  widget.viewModel.onChangedPrice(
                                                                      newPrice,
                                                                      priceRule,
                                                                      widget
                                                                          .operationDay,
                                                                      true,
                                                                      controller),
                                                            );
                                                          },
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox()),
                        ],
                      ),
                    ),
                  ),
                ),
                widget.operationDay.isExpanded
                    ? Container()
                    : InkWell(
                        onTap: () {
                          if (widget.operationDay.isEnabled) {
                            setState(() {
                              widget.operationDay.isExpanded =
                                  !widget.operationDay.isExpanded;
                            });
                          }
                        },
                        child: SizedBox(
                          width: editIconWidth,
                          child: SvgPicture.asset(
                            r'assets/icon/edit.svg',
                            color: Colors.white,
                            height: 16,
                          ),
                        ),
                      )
              ],
            ),
          ),
          widget.operationDay.isExpanded
              ? InkWell(
                  onTap: () {
                    setState(() {
                      widget.operationDay.isExpanded =
                          !widget.operationDay.isExpanded;
                    });
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: SvgPicture.asset(
                      r'assets/icon/chevron_up.svg',
                      color: Colors.white,
                      height: arrowHeight,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
