import 'package:flutter/material.dart';
import 'package:sandfriends_web/Features/MyCourts/ViewModel/MyCourtsViewModel.dart';
import 'package:sandfriends_web/Utils/Constants.dart';
import 'package:provider/provider.dart';
import '../../../../../SharedComponents/Model/Hour.dart';
import '../../../../../SharedComponents/Model/PriceRule.dart';
import '../../../../../SharedComponents/View/SFDropDown.dart';
import '../../../../../Common/Components/SFTextField.dart';

class PriceSelector extends StatefulWidget {
  PriceRule priceRule;
  bool editHour;
  bool allowRecurrent;
  double height;
  List<Hour> availableHours;
  Function(Hour, String?) onChangedStartingHour;
  Function(Hour, String?) onChangedEndingHour;
  Function(String, PriceRule, TextEditingController) onChangedPrice;
  Function(String, PriceRule, TextEditingController) onChangedRecurrentPrice;

  PriceSelector({
    super.key,
    required this.priceRule,
    this.editHour = false,
    required this.height,
    required this.availableHours,
    required this.allowRecurrent,
    required this.onChangedStartingHour,
    required this.onChangedEndingHour,
    required this.onChangedPrice,
    required this.onChangedRecurrentPrice,
  });

  @override
  State<PriceSelector> createState() => _PriceSelectorState();
}

class _PriceSelectorState extends State<PriceSelector> {
  TextEditingController priceController = TextEditingController();
  TextEditingController recurrentPriceController = TextEditingController();

  @override
  void initState() {
    priceController.text = widget.priceRule.price.toString();
    recurrentPriceController.text = widget.priceRule.priceRecurrent.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: widget.height * 0.05,
      ),
      height: widget.height * 0.9,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: widget.editHour
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SFDropdown(
                          enableBorder: true,
                          textColor: textDarkGrey,
                          labelText: widget.priceRule.startingHour.hourString,
                          items: widget.availableHours
                              .where(
                                (hour) =>
                                    hour.hour <
                                    widget.priceRule.endingHour.hour,
                              )
                              .map((hour) => hour.hourString)
                              .toList(),
                          validator: (a) {
                            return null;
                          },
                          onChanged: (newHour) => widget.onChangedStartingHour(
                              widget.priceRule.startingHour, newHour)),
                      const Text(
                        " - ",
                        style: TextStyle(color: textDarkGrey),
                      ),
                      SFDropdown(
                          enableBorder: true,
                          textColor: textDarkGrey,
                          labelText: widget.priceRule.endingHour.hourString,
                          items: widget.availableHours
                              .where(
                                (hour) =>
                                    hour.hour >
                                    widget.priceRule.startingHour.hour,
                              )
                              .map((hour) => hour.hourString)
                              .toList(),
                          validator: (a) {
                            return null;
                          },
                          onChanged: (newHour) => widget.onChangedEndingHour(
                              widget.priceRule.endingHour, newHour)),
                    ],
                  )
                : Text(
                    "${widget.priceRule.startingHour.hourString} - ${widget.priceRule.endingHour.hourString}",
                    style: const TextStyle(color: textDarkGrey),
                    textAlign: TextAlign.center,
                  ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: SFTextField(
                textAlign: TextAlign.center,
                plainTextField: true,
                prefixText: "R\$",
                sufixText: "/hora",
                labelText: "",
                pourpose: TextFieldPourpose.Numeric,
                controller: priceController,
                validator: (value) {
                  return null;
                },
                onChanged: (newPrice) => widget.onChangedPrice(
                    newPrice, widget.priceRule, priceController),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: widget.allowRecurrent
                  ? SFTextField(
                      textAlign: TextAlign.center,
                      plainTextField: true,
                      prefixText: "R\$",
                      sufixText: "/hora",
                      labelText: "",
                      pourpose: TextFieldPourpose.Numeric,
                      controller: recurrentPriceController,
                      validator: (value) {
                        return null;
                      },
                      onChanged: (newRecurrentPrice) =>
                          widget.onChangedRecurrentPrice(newRecurrentPrice,
                              widget.priceRule, recurrentPriceController),
                    )
                  : Container(),
            ),
          ),
        ],
      ),
    );
  }
}
