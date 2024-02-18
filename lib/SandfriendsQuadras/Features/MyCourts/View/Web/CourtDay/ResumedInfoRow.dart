import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../../Common/Components/SFDropDown.dart';
import '../../../../../../Common/Model/OperationDay.dart';
import 'package:provider/provider.dart';

import '../../../../../../Common/Utils/Constants.dart';
import '../../../../../../Common/Utils/SFDateTime.dart';
import '../../../ViewModel/MyCourtsViewModel.dart';

class ResumedInfoRow extends StatefulWidget {
  OperationDay operationDay;
  bool isEditing;
  double rowHeight;
  Function(bool) setAllowRecurrent;

  ResumedInfoRow({
    super.key,
    required this.operationDay,
    required this.isEditing,
    required this.rowHeight,
    required this.setAllowRecurrent,
  });
  @override
  State<ResumedInfoRow> createState() => _ResumedInfoRowState();
}

class _ResumedInfoRowState extends State<ResumedInfoRow> {
  String priceText = "";
  String? priceRecurrentText;
  @override
  Widget build(BuildContext context) {
    if (widget.operationDay.isEnabled) {
      priceText = widget.operationDay.lowestPrice ==
              widget.operationDay.highestPrice
          ? "R\$${widget.operationDay.highestPrice}"
          : "R\$${widget.operationDay.lowestPrice} - R\$${widget.operationDay.highestPrice}";
      priceRecurrentText = widget.operationDay.lowestRecurrentPrice == null
          ? null
          : widget.operationDay.lowestRecurrentPrice ==
                  widget.operationDay.highestRecurrentPrice
              ? "R\$${widget.operationDay.lowestRecurrentPrice}"
              : "R\$${widget.operationDay.lowestRecurrentPrice} - R\$${widget.operationDay.highestRecurrentPrice}";
    }

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            weekday[widget.operationDay.weekday],
            style: const TextStyle(color: textDarkGrey),
            textAlign: TextAlign.center,
          ),
        ),
        widget.operationDay.isEnabled
            ? Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        "${widget.operationDay.startingHour.hourString} - ${widget.operationDay.endingHour.hourString}",
                        style: const TextStyle(color: textDarkGrey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.center,
                        child: widget.isEditing
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: defaultPadding / 2),
                                child: SFDropdown(
                                  labelText: widget.operationDay.allowReccurrent
                                      ? "Sim"
                                      : "Não",
                                  items: const ["Sim", "Não"],
                                  validator: (value) {
                                    return null;
                                  },
                                  onChanged: (newValue) {
                                    widget.setAllowRecurrent(newValue == "Sim");
                                  },
                                  textColor: textDarkGrey,
                                  enableBorder: true,
                                ),
                              )
                            : Text(
                                widget.operationDay.allowReccurrent
                                    ? "Sim"
                                    : "Não",
                                style: const TextStyle(color: textDarkGrey),
                              ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: widget.operationDay.allowReccurrent
                          ? RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: '$priceText\n',
                                style: const TextStyle(
                                  color: textLightGrey,
                                  fontFamily: 'Lexend',
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: priceRecurrentText,
                                    style: const TextStyle(
                                      color: textBlue,
                                      fontFamily: 'Lexend',
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Text(
                              priceText,
                              style: const TextStyle(color: textDarkGrey),
                              textAlign: TextAlign.center,
                            ),
                    ),
                    InkWell(
                      onTap: () =>
                          Provider.of<MyCourtsViewModel>(context, listen: false)
                              .setPriceListWidget(
                                  Provider.of<MyCourtsViewModel>(context,
                                      listen: false),
                                  context,
                                  widget.operationDay.prices,
                                  widget.operationDay.weekday),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(right: defaultPadding * 2),
                        child: SvgPicture.asset(
                          r'assets/icon/file.svg',
                          width: 20,
                          height: 20,
                          color: textDarkGrey,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const Expanded(
                flex: 3,
                child: Text(
                  "Fechado",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: red),
                ))
      ],
    );
  }
}
