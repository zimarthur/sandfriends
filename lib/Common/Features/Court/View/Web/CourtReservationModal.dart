import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Components/SFButton.dart';
import 'package:sandfriends/Common/Components/SFLoading.dart';
import 'package:sandfriends/Common/Components/SFTextField.dart';
import 'package:sandfriends/Common/Features/Court/View/AvailableCourtsPrices.dart';
import 'package:sandfriends/Common/Features/Court/View/Web/ReservationStepWidget.dart';
import 'package:sandfriends/Common/Model/SelectedPayment.dart';
import 'package:sandfriends/Common/Utils/TypeExtensions.dart';
import 'package:sandfriends/Sandfriends/Features/Checkout/View/Toolbar/CheckoutBottomToolbarDiscount.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/Authentication/ProfileOverlay/View/ProfileOverlay.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/LandingPage/View/SearchFilter.dart';

import '../../../../../Sandfriends/Features/Checkout/View/Payment/CheckoutPayment.dart';
import '../../../../../Sandfriends/Features/Checkout/View/Toolbar/CheckoutBottomToolbar.dart';
import '../../../../../Sandfriends/Features/Checkout/View/Toolbar/CheckoutBottomToolbarItem.dart';
import '../../../../Components/SFAvatarUser.dart';
import '../../../../Providers/Categories/CategoriesProvider.dart';
import '../../../../Utils/Constants.dart';
import '../../ViewModel/CourtViewModel.dart';

class CourtReservationModal extends StatefulWidget {
  VoidCallback onClose;
  CourtReservationModal({required this.onClose, super.key});

  @override
  State<CourtReservationModal> createState() => _CourtReservationModalState();
}

class _CourtReservationModalState extends State<CourtReservationModal> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final viewModel = Provider.of<CourtViewModel>(context);
    return Container(
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryDarkBlue, width: 1),
        boxShadow: const [BoxShadow(blurRadius: 1, color: primaryDarkBlue)],
      ),
      width: width > 1500 ? 1500 : width * 0.9,
      height: height > 800 ? 800 : height * 0.9,
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Column(
                  children: [
                    SearchFilter(
                      store: viewModel.store,
                      scaleFactor: 0.9,
                      onTapLocation: () {},
                      onTapDate: () => viewModel.openDateSelectorModal(context),
                      onTapTime: () => viewModel.openTimeSelectorModal(context),
                      city: null,
                      dates: [viewModel.selectedDate],
                      time: viewModel.timeFilter,
                      onSearch: () => viewModel.searchMatches(context),
                      direction: Axis.horizontal,
                    ),
                    Expanded(
                      child: viewModel.isLoading
                          ? Center(
                              child: SFLoading(),
                            )
                          : viewModel.courtAvailableHours.isEmpty
                              ? const Center(
                                  child: Text(
                                    "Nenhum horário disponível",
                                    style: TextStyle(
                                      color: textDarkGrey,
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: defaultPadding,
                                  ),
                                  child: AvailableCourtsPrices(
                                    courtHeight: 110,
                                    themeColor: primaryBlue,
                                    viewModel: viewModel,
                                    showArrow: true,
                                    canScroll: true,
                                  ),
                                ),
                    ),
                  ],
                ),
              )),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(
                    defaultBorderRadius,
                  ),
                  bottomRight: Radius.circular(
                    defaultBorderRadius,
                  ),
                ),
                color: secondaryBackWeb,
                border: Border(
                  left: BorderSide(
                    color: divider,
                  ),
                ),
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () => widget.onClose(),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: SvgPicture.asset(
                        r"assets/icon/x.svg",
                        color: textDarkGrey,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: defaultPadding,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Column(
                          children: [
                            ReservationStepWidget(
                              step: "1",
                              description:
                                  "Escolha a quadra e horário da partida",
                              isActive: true,
                              child: viewModel.selectedHourPrices.isEmpty
                                  ? Container()
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          viewModel.selectedCourt!.description,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: textDarkGrey,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              r"assets/icon/calendar.svg",
                                              color: primaryDarkBlue,
                                            ),
                                            SizedBox(
                                              width: defaultPadding / 2,
                                            ),
                                            Text(
                                              "${viewModel.selectedDate?.formatDate()} | ${viewModel.reservationStartTime!.hourString} - ${Provider.of<CategoriesProvider>(context, listen: false).getHourEnd(
                                                    viewModel
                                                        .reservationEndTime!,
                                                  ).hourString}",
                                              style: TextStyle(
                                                color: primaryDarkBlue,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                            ),
                            ReservationStepWidget(
                              step: "2",
                              description: "Quem está reservando",
                              isActive: viewModel.selectedCourt != null,
                              child: Provider.of<UserProvider>(context)
                                      .isDoneWithUserRequest
                                  ? Row(
                                      children: [
                                        SFAvatarUser(
                                          height: 40,
                                          user:
                                              Provider.of<UserProvider>(context)
                                                  .user!,
                                          showRank: false,
                                        ),
                                        SizedBox(
                                          width: defaultPadding,
                                        ),
                                        Text(
                                          Provider.of<UserProvider>(context)
                                              .user!
                                              .fullName,
                                          style: TextStyle(
                                            color: primaryDarkBlue,
                                          ),
                                        ),
                                      ],
                                    )
                                  : ProfileOverlay(
                                      mustCloseWhenDone: false,
                                    ),
                            ),
                            ReservationStepWidget(
                              step: "3",
                              description: "Forma de pagamento",
                              isActive: Provider.of<UserProvider>(context)
                                      .isDoneWithUserRequest &&
                                  viewModel.selectedCourt != null,
                              child: CheckoutPayment(
                                viewModel: viewModel,
                                showTitle: false,
                                showOnlySelected: true,
                              ),
                            ),
                            ReservationStepWidget(
                              step: "4",
                              description: "Tem cupom de desconto?",
                              isActive: viewModel.selectedPayment !=
                                  SelectedPayment.NotSelected,
                              child: viewModel.selectedPayment ==
                                      SelectedPayment.PayInStore
                                  ? Text(
                                      "Os cupons de desconto são válidos somente para pagemento online",
                                      style: TextStyle(
                                        color: textDarkGrey,
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                          top: defaultPadding / 2),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: SFTextField(
                                                  labelText: "Insira o cupom",
                                                  pourpose: TextFieldPourpose
                                                      .Standard,
                                                  controller:
                                                      viewModel.cupomController,
                                                  validator: (a) {})),
                                          SizedBox(
                                            width: defaultPadding / 2,
                                          ),
                                          InkWell(
                                            onTap: () =>
                                                viewModel.onAddCupom(context),
                                            child: Container(
                                              padding: EdgeInsets.all(
                                                  defaultPadding / 2),
                                              decoration: BoxDecoration(
                                                color: primaryDarkBlue,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  defaultBorderRadius / 2,
                                                ),
                                              ),
                                              child: Center(
                                                child: SvgPicture.asset(
                                                  r"assets/icon/plus.svg",
                                                  color: textWhite,
                                                  height: 25,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: divider,
                    height: 2,
                  ),
                  SizedBox(
                    height: defaultPadding / 2,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("O que você está levando"),
                            if (viewModel.selectedDate != null)
                              CheckoutBottomToolbarItem(
                                date: viewModel.selectedDate!,
                                price: viewModel.matchPrice,
                              ),
                            if (viewModel.appliedCoupon != null)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Cupom: ${viewModel.appliedCoupon!.couponCode}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: red,
                                    ),
                                  ),
                                  Text(
                                    "R\$ -${viewModel.appliedCoupon!.calculateDiscount(viewModel.matchPrice).toStringAsFixed(2).replaceAll(".", ",")}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: red,
                                    ),
                                  ),
                                ],
                              ),
                            SizedBox(
                              height: defaultPadding / 2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Total"),
                                Text(
                                  viewModel.finalMatchPrice.formatPrice(),
                                  style: TextStyle(
                                    color: green,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: defaultPadding,
                      ),
                      SFButton(
                        buttonLabel: "Agendar",
                        color: viewModel.selectedPayment !=
                                SelectedPayment.NotSelected
                            ? primaryBlue
                            : disabled,
                        textPadding: EdgeInsets.all(defaultPadding / 2),
                        onTap: () => viewModel.validateReservation(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
