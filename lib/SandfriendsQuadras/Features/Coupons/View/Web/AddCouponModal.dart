import 'package:flutter/material.dart';
import 'package:sandfriends_web/Features/Calendar/View/Web/Match/DatePicker.dart';
import 'package:sandfriends_web/Features/Calendar/ViewModel/CalendarViewModel.dart';
import 'package:sandfriends_web/Features/Menu/ViewModel/DataProvider.dart';
import 'package:sandfriends_web/SharedComponents/Model/Coupon.dart';
import 'package:sandfriends_web/SharedComponents/Model/EnumDiscountType.dart';
import 'package:sandfriends_web/SharedComponents/Model/Gender.dart';
import 'package:sandfriends_web/SharedComponents/Model/Rank.dart';
import 'package:sandfriends_web/SharedComponents/View/DatePickerModal.dart';
import 'package:sandfriends_web/SharedComponents/View/SFDropDown.dart';
import 'package:sandfriends_web/Utils/Responsive.dart';
import 'package:sandfriends_web/Utils/Validators.dart';
import 'package:provider/provider.dart';
import '../../../../../Common/Model/Court.dart';
import '../../../../../Common/Model/Hour.dart';
import '../../../../../Common/Model/Sport.dart';
import '../../../../../Common/Components/SFButton.dart';
import '../../../../../Common/Components/SFTextField.dart';
import '../../../../../Common/Utils/Constants.dart';
import '../../../../SharedComponents/Model/Player.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class AddCouponModal extends StatefulWidget {
  VoidCallback onReturn;
  Function(Coupon) onCreateCoupon;

  AddCouponModal({
    required this.onReturn,
    required this.onCreateCoupon,
  });

  @override
  State<AddCouponModal> createState() => _AddCouponModalState();
}

class _AddCouponModalState extends State<AddCouponModal> {
  String couponCode = "";
  String couponValue = "";
  EnumDiscountType discountType = EnumDiscountType.Fixed;
  DateTime? startDate;
  DateTime? endDate;
  late Hour startingHour;
  late Hour endingHour;
  bool onDatePicker = false;

  bool get canAddCoupon =>
      couponCode.isNotEmpty && startDate != null && couponValue.isNotEmpty;

  List<Hour> availableHours = [];
  final formKey = GlobalKey<FormState>();
  TextEditingController couponController = TextEditingController();
  TextEditingController couponValueController = TextEditingController();

  @override
  void initState() {
    availableHours =
        Provider.of<DataProvider>(context, listen: false).availableHours;
    startingHour = availableHours.first;
    endingHour = availableHours.last;
    couponController.addListener(() {
      setState(() {
        couponCode = couponController.text;
      });
    });
    couponValueController.addListener(() {
      setState(() {
        couponValue = couponValueController.text;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    couponController.removeListener(() {});
    couponValueController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return onDatePicker
        ? DatePickerModal(
            onDateSelected: (start, end) {
              setState(() {
                startDate = start;
                endDate = end;
                onDatePicker = false;
              });
            },
            onReturn: () => setState(() {
              onDatePicker = false;
            }),
            title: "Selecione a data de início e fim do cupom",
            actionButtonTitle: "Selecionar",
            allowPastDates: false,
          )
        : Container(
            width: Responsive.isMobile(context) ? width * 0.95 : 500,
            padding: const EdgeInsets.all(defaultPadding),
            decoration: BoxDecoration(
              color: secondaryPaper,
              borderRadius: BorderRadius.circular(defaultBorderRadius),
              border: Border.all(
                color: divider,
                width: 1,
              ),
            ),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          r"assets/icon/discount_add.svg",
                          height: 30,
                        ),
                        SizedBox(
                          width: defaultPadding / 2,
                        ),
                        Text(
                          "Criar novo cupom",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: textBlue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: defaultPadding / 2,
                    ),
                    Text(
                      "Alavanque suas vendas e faça com que novos jogadores conheçam sua quadras com cupons de desconto",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: textDarkGrey,
                      ),
                    ),
                    const SizedBox(
                      height: defaultPadding * 2,
                    ),
                    Row(
                      children: [
                        if (!Responsive.isMobile(context))
                          Expanded(child: Text("Nome do cupom:")),
                        Expanded(
                          child: SFTextField(
                            labelText: Responsive.isMobile(context)
                                ? "Nome do cupom"
                                : "",
                            hintText: "Ex: SAND10",
                            textAlign: TextAlign.end,
                            pourpose: TextFieldPourpose.Standard,
                            controller: couponController,
                            onChanged: (newName) {
                              setState(() {
                                couponCode = newName;
                              });
                            },
                            validator: (a) =>
                                emptyCheck(a, "Digite o nome do cupom"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Responsive.isMobile(context)
                            ? Expanded(child: Container())
                            : Expanded(child: Text("Datas válidas:")),
                        InkWell(
                          onTap: () => setState(() {
                            onDatePicker = true;
                          }),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: defaultPadding / 2,
                              horizontal: defaultPadding,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                defaultBorderRadius,
                              ),
                              border: startDate != null
                                  ? Border.all(color: primaryBlue, width: 2)
                                  : Border.all(
                                      color: divider,
                                    ),
                              color: startDate != null ? blueBg : null,
                            ),
                            child: Center(
                              child: Text(
                                startDate != null
                                    ? "${DateFormat("dd/MM/yyyy").format(startDate!)}" +
                                        "${endDate != null ? " - ${DateFormat('dd/MM/yyyy').format(endDate!)}" : ""}"
                                    : "Selecionar data",
                                style: TextStyle(
                                  color: startDate != null
                                      ? blueText
                                      : textDarkGrey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    Row(
                      children: [
                        if (!Responsive.isMobile(context))
                          Text(
                            "Horários válidos:",
                          ),
                        Expanded(
                          child: Container(),
                        ),
                        Text(
                          "Entre",
                          style: TextStyle(color: textDarkGrey),
                        ),
                        SizedBox(
                          width: defaultPadding / 2,
                        ),
                        SFDropdown(
                          labelText: startingHour.hourString,
                          items: availableHours
                              .where((hour) => hour.hour < endingHour.hour)
                              .map((hour) => hour.hourString)
                              .toList(),
                          validator: (a) {
                            return null;
                          },
                          onChanged: (newStartingHour) {
                            setState(() {
                              startingHour = availableHours.firstWhere(
                                  (element) =>
                                      element.hourString == newStartingHour);
                            });
                          },
                        ),
                        SizedBox(
                          width: defaultPadding / 2,
                        ),
                        Text(
                          "e",
                          style: TextStyle(color: textDarkGrey),
                        ),
                        SizedBox(
                          width: defaultPadding / 2,
                        ),
                        SFDropdown(
                          labelText: endingHour.hourString,
                          items: availableHours
                              .where((hour) => hour.hour > startingHour.hour)
                              .map((hour) => hour.hourString)
                              .toList(),
                          validator: (newEndingHour) {
                            return null;
                          },
                          onChanged: (newEndingHour) {
                            setState(() {
                              endingHour = availableHours.firstWhere(
                                  (element) =>
                                      element.hourString == newEndingHour);
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    Row(
                      children: [
                        if (!Responsive.isMobile(context))
                          Expanded(child: Text("Valor do cupom:")),
                        Expanded(
                          child: SFTextField(
                            labelText: Responsive.isMobile(context)
                                ? "Valor do cupom"
                                : "",
                            pourpose: TextFieldPourpose.Numeric,
                            controller: couponValueController,
                            validator: (a) => priceValidator(
                              a,
                              "Digite o valor do cupom",
                              min: 1,
                              max: 100,
                            ),
                            textAlign: TextAlign.center,
                            prefixText: discountType == EnumDiscountType.Fixed
                                ? "R\$"
                                : null,
                            sufixText:
                                discountType == EnumDiscountType.Percentage
                                    ? "%"
                                    : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () => setState(() {
                            discountType = EnumDiscountType.Fixed;
                          }),
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                defaultBorderRadius,
                              ),
                              border: discountType == EnumDiscountType.Fixed
                                  ? Border.all(color: primaryBlue, width: 2)
                                  : Border.all(
                                      color: divider,
                                    ),
                              color: discountType == EnumDiscountType.Fixed
                                  ? blueBg
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                "R\$",
                                style: TextStyle(
                                  color: discountType == EnumDiscountType.Fixed
                                      ? blueText
                                      : textDarkGrey,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: defaultPadding / 2,
                        ),
                        InkWell(
                          onTap: () => setState(() {
                            discountType = EnumDiscountType.Percentage;
                          }),
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                defaultBorderRadius,
                              ),
                              border:
                                  discountType == EnumDiscountType.Percentage
                                      ? Border.all(color: primaryBlue, width: 2)
                                      : Border.all(
                                          color: divider,
                                        ),
                              color: discountType == EnumDiscountType.Percentage
                                  ? blueBg
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                "%",
                                style: TextStyle(
                                  color: discountType ==
                                          EnumDiscountType.Percentage
                                      ? blueText
                                      : textDarkGrey,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    const SizedBox(
                      height: 2 * defaultPadding,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SFButton(
                            buttonLabel: "Voltar",
                            buttonType: ButtonType.Secondary,
                            onTap: widget.onReturn,
                          ),
                        ),
                        const SizedBox(
                          width: defaultPadding,
                        ),
                        Expanded(
                          child: SFButton(
                            buttonLabel: "Adicionar cupom",
                            buttonType: canAddCoupon
                                ? ButtonType.Primary
                                : ButtonType.Disabled,
                            onTap: () {
                              if (canAddCoupon) {
                                if (formKey.currentState?.validate() == true) {
                                  widget.onCreateCoupon(
                                    Coupon(
                                      idCoupon: 0,
                                      couponCode: couponController.text,
                                      value: double.parse(
                                        couponValueController.text,
                                      ),
                                      discountType: discountType,
                                      isValid: true,
                                      creationDate: DateTime.now(),
                                      startingDate: startDate!,
                                      endingDate: endDate ?? startDate!,
                                      hourBegin: startingHour,
                                      hourEnd: endingHour,
                                      timesUsed: 0,
                                      profit: 0,
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
