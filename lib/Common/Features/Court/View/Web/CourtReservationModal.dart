import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Components/SFButton.dart';
import 'package:sandfriends/Common/Components/SFLoading.dart';
import 'package:sandfriends/Common/Features/Court/View/AvailableCourtsPrices.dart';
import 'package:sandfriends/Common/Features/Court/View/Web/ReservationStepWidget.dart';
import 'package:sandfriends/Common/Model/SelectedPayment.dart';
import 'package:sandfriends/Common/Utils/TypeExtensions.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/Authentication/ProfileOverlay/View/ProfileOverlay.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/LandingPage/View/SearchFilter.dart';

import '../../../../../Sandfriends/Features/Checkout/View/Payment/CheckoutPayment.dart';
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
      width: width > 1200 ? 1200 : width * 0.9,
      height: height > 600 ? 600 : height * 0.8,
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
                                    courtHeight: 120,
                                    themeColor: primaryBlue,
                                    viewModel: viewModel,
                                    showArrow: true,
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
                                                  viewModel.reservationEndTime!,
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
                            child: Provider.of<UserProvider>(context).user ==
                                    null
                                ? LoginSignup(
                                    parentScreen: viewModel,
                                  )
                                : Row(
                                    children: [
                                      SFAvatarUser(
                                        height: 40,
                                        user: Provider.of<UserProvider>(context)
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
                                  ),
                          ),
                          ReservationStepWidget(
                            step: "3",
                            description: "Forma de pagamento",
                            isActive: Provider.of<UserProvider>(context).user !=
                                    null &&
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
                                    child: SFButton(
                                      buttonLabel: "Inserir cupom",
                                      iconPath:
                                          r"assets/icon/discount_outline.svg",
                                      onTap: () =>
                                          viewModel.onAddCupom(context),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
