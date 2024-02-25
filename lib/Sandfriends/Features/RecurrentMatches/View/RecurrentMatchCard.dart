import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Model/AppRecurrentMatch/AppRecurrentMatchUser.dart';
import 'package:sandfriends/Common/Model/HourPrice/HourPriceUser.dart';
import 'package:sandfriends/Common/Providers/CategoriesProvider/CategoriesProvider.dart';
import 'package:sandfriends/Common/Utils/TypeExtensions.dart';

import '../../../../Common/Components/PixCodeClipboard.dart';
import '../../../../Common/Model/AppRecurrentMatch/AppRecurrentMatch.dart';
import '../../../../Common/Model/PaymentStatus.dart';
import '../../../../Common/Model/SelectedPayment.dart';
import '../../../../Common/Providers/Environment/EnvironmentProvider.dart';
import '../../../../Common/Components/SFButton.dart';

import '../../../../Common/Components/SFLoading.dart';
import '../../../../Common/Utils/Constants.dart';
import '../../../../Common/Utils/SFDateTime.dart';
import 'RecurrentMatchCardDate.dart';

class RecurrentMatchCard extends StatefulWidget {
  final AppRecurrentMatchUser recurrentMatch;
  final bool expanded;
  const RecurrentMatchCard({
    Key? key,
    required this.recurrentMatch,
    required this.expanded,
  }) : super(key: key);

  @override
  State<RecurrentMatchCard> createState() => _RecurrentMatchCardState();
}

class _RecurrentMatchCardState extends State<RecurrentMatchCard> {
  bool hasCopiedPixToClipboard = false;
  DateTime liveDatetime = DateTime.now();

  String? get timeToExpirePayment {
    if (liveDatetime.isAfter(widget.recurrentMatch.validUntil)) return null;
    int difference =
        widget.recurrentMatch.validUntil.difference(DateTime.now()).inSeconds;
    return "${(difference ~/ 60).toString().padLeft(2, '0')}:${(difference % 60).toString().padLeft(2, '0')}";
  }

  late Timer _timer;

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (widget.recurrentMatch.isPaymentExpired == false) {
        setState(() {
          liveDatetime = DateTime.now();
        });
      } else {
        _timer.cancel();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return LayoutBuilder(builder: (layoutContext, layoutConstraints) {
      return Container(
        margin: EdgeInsets.symmetric(
          vertical: height * 0.01,
        ),
        height: widget.expanded ? layoutConstraints.maxHeight : 160,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: primaryLightBlue,
            width: 1,
          ),
          color: primaryLightBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Container(
              height: 25,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: primaryLightBlue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Text(
                "${weekday[widget.recurrentMatch.weekday]}:  ${widget.recurrentMatch.timeBegin.hourString} - ${widget.recurrentMatch.timeEnd.hourString}",
                style: const TextStyle(
                    color: textWhite, fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Container(
                        height: 100,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: CachedNetworkImage(
                                imageUrl: Provider.of<EnvironmentProvider>(
                                        context,
                                        listen: false)
                                    .urlBuilder(widget
                                        .recurrentMatch.court.store!.logo!),
                                height: 80,
                                width: 80,
                                placeholder: (context, url) => SizedBox(
                                  height: 80,
                                  width: 80,
                                  child: Center(
                                    child: SFLoading(),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  height: 80,
                                  width: 80,
                                  color: textLightGrey.withOpacity(0.5),
                                  child: const Center(
                                    child: Icon(Icons.dangerous),
                                  ),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                right: 20,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          r'assets/icon/location_ping.svg',
                                          color: textDarkGrey,
                                          width: 15,
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                right: width * 0.02)),
                                        Expanded(
                                          child: Text(
                                            widget.recurrentMatch.court.store!
                                                .name,
                                            style: const TextStyle(
                                              color: textDarkGrey,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "Partidas jogadas:",
                                              style: TextStyle(
                                                color: textDarkGrey,
                                              ),
                                            ),
                                            Text(
                                              "${widget.recurrentMatch.matchCounter}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: textDarkGrey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: defaultPadding / 8,
                                        ),
                                        areInTheSameDay(
                                                widget
                                                    .recurrentMatch.validUntil,
                                                widget.recurrentMatch
                                                    .creationDate)
                                            ? widget.expanded
                                                ? Container()
                                                : Text(
                                                    widget
                                                                .recurrentMatch
                                                                .nextRecurrentMatches
                                                                .first
                                                                .selectedPayment ==
                                                            SelectedPayment
                                                                .CreditCard
                                                        ? "Processando pagamento"
                                                        : "Aguardando pagamento",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: secondaryYellow),
                                                  )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text(
                                                    "Renovar até: ",
                                                    style: TextStyle(
                                                      color: textDarkGrey,
                                                    ),
                                                  ),
                                                  Text(
                                                    DateFormat("dd/MM/yy")
                                                        .format(
                                                      widget.recurrentMatch
                                                          .validUntil,
                                                    ),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: widget
                                                                  .recurrentMatch
                                                                  .validUntil
                                                                  .difference(
                                                                      DateTime
                                                                          .now())
                                                                  .inDays <
                                                              10
                                                          ? red
                                                          : textDarkGrey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.expanded)
                        Column(
                          children: [
                            const SizedBox(
                              height: defaultPadding,
                            ),
                            Column(
                              children: [
                                const SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Próximas partidas:",
                                        style: TextStyle(
                                          color: primaryLightBlue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: defaultPadding / 2,
                                ),
                                SizedBox(
                                  height: 80,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: widget.recurrentMatch
                                        .nextRecurrentMatches.length,
                                    itemBuilder: ((context, index) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(context,
                                                '/match_screen/${widget.recurrentMatch.nextRecurrentMatches[index].matchUrl}');
                                          },
                                          child: RecurrentMatchCardDate(
                                              day: widget
                                                  .recurrentMatch
                                                  .nextRecurrentMatches[index]
                                                  .date
                                                  .day,
                                              month: monthsPortuguese[widget
                                                      .recurrentMatch
                                                      .nextRecurrentMatches[
                                                          index]
                                                      .date
                                                      .month -
                                                  1]),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: defaultPadding,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Pagamentos:",
                                  style: TextStyle(
                                    color: primaryLightBlue,
                                  ),
                                ),
                                const SizedBox(
                                  height: defaultPadding / 2,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Status",
                                      style: TextStyle(
                                        color: textDarkGrey,
                                      ),
                                      textScaleFactor: 0.9,
                                    ),
                                    Text(
                                      widget.recurrentMatch.nextRecurrentMatches
                                                  .first.paymentStatus ==
                                              PaymentStatus.Pending
                                          ? widget
                                                      .recurrentMatch
                                                      .nextRecurrentMatches
                                                      .first
                                                      .selectedPayment ==
                                                  SelectedPayment.CreditCard
                                              ? "Processando pagamento"
                                              : "Aguardando pagamento"
                                          : "Pagamento confirmado",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: widget
                                                    .recurrentMatch
                                                    .nextRecurrentMatches
                                                    .first
                                                    .paymentStatus ==
                                                PaymentStatus.Pending
                                            ? secondaryYellow
                                            : Colors.green,
                                      ),
                                      textScaleFactor: 0.9,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: defaultPadding / 2,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${widget.recurrentMatch.nextRecurrentMatches.length} Partida(s) (${widget.recurrentMatch.nextRecurrentMatches.first.cost.formatPrice()}):",
                                      style: const TextStyle(
                                        color: textDarkGrey,
                                      ),
                                      textScaleFactor: 0.9,
                                    ),
                                    Text(
                                      widget.recurrentMatch.currentMonthPrice
                                          .formatPrice(),
                                      style: const TextStyle(
                                        color: textDarkGrey,
                                      ),
                                      textScaleFactor: 0.9,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: defaultPadding / 2,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Forma de pagamento",
                                      style: TextStyle(
                                        color: textDarkGrey,
                                      ),
                                      textScaleFactor: 0.9,
                                    ),
                                    Text(
                                      widget.recurrentMatch.nextRecurrentMatches
                                                  .first.selectedPayment ==
                                              SelectedPayment.Pix
                                          ? "Pix"
                                          : widget
                                                      .recurrentMatch
                                                      .nextRecurrentMatches
                                                      .first
                                                      .selectedPayment ==
                                                  SelectedPayment.CreditCard
                                              ? "Cartão de crédito\n${widget.recurrentMatch.nextRecurrentMatches.first.creditCard!.cardNumber}"
                                              : "Pagar no local",
                                      textAlign: TextAlign.end,
                                      style: const TextStyle(
                                        color: textDarkGrey,
                                      ),
                                      textScaleFactor: 0.9,
                                    ),
                                  ],
                                ),
                                if (widget.recurrentMatch.nextRecurrentMatches
                                            .first.paymentStatus ==
                                        PaymentStatus.Pending &&
                                    widget.recurrentMatch.nextRecurrentMatches
                                            .first.selectedPayment ==
                                        SelectedPayment.Pix)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: defaultPadding,
                                      ),
                                      Text(
                                        "Código Pix (${hasCopiedPixToClipboard ? "copiado!" : "toque para copiar"})",
                                        style: const TextStyle(
                                          color: textDarkGrey,
                                        ),
                                        textScaleFactor: 0.9,
                                      ),
                                      const SizedBox(
                                        height: defaultPadding,
                                      ),
                                      PixCodeClipboard(
                                        pixCode: widget
                                            .recurrentMatch
                                            .nextRecurrentMatches
                                            .first
                                            .pixCode!,
                                        hasCopiedPixToClipboard:
                                            hasCopiedPixToClipboard,
                                        onCopied: () => setState(() {
                                          hasCopiedPixToClipboard = true;
                                        }),
                                        mainColor: primaryLightBlue,
                                      ),
                                      const SizedBox(
                                        height: defaultPadding / 2,
                                      ),
                                      RichText(
                                        textScaleFactor: 0.9,
                                        text: TextSpan(
                                          text: 'Você tem ',
                                          style: const TextStyle(
                                            color: textDarkGrey,
                                            fontFamily: 'Lexend',
                                          ),
                                          children: [
                                            TextSpan(
                                              text: timeToExpirePayment,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: primaryLightBlue,
                                                fontFamily: 'Lexend',
                                              ),
                                            ),
                                            const TextSpan(
                                              text:
                                                  " minutos para finalizar o pagamento",
                                              style: TextStyle(
                                                color: textDarkGrey,
                                                fontFamily: 'Lexend',
                                              ),
                                            ),
                                            const TextSpan(text: "."),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                const SizedBox(
                                  height: defaultPadding,
                                )
                              ],
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
            widget.expanded
                ? Column(
                    children: [
                      if (areInTheSameMonth(widget.recurrentMatch.validUntil,
                              DateTime.now()) &&
                          widget.recurrentMatch.nextRecurrentMatches.first
                                  .paymentStatus ==
                              PaymentStatus.Confirmed)
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.05,
                          ),
                          child: SFButton(
                            buttonLabel: "Renovar Horário",
                            color: primaryLightBlue,
                            textPadding:
                                EdgeInsets.symmetric(vertical: height * 0.01),
                            onTap: () {
                              List<HourPriceUser> hourPrices = [];
                              Provider.of<CategoriesProvider>(context,
                                      listen: false)
                                  .hours
                                  .forEach((hour) {
                                if (hour.hour >=
                                        widget.recurrentMatch.timeBegin.hour &&
                                    hour.hour <
                                        widget.recurrentMatch.timeEnd.hour) {
                                  hourPrices.add(
                                    HourPriceUser(
                                      hour: hour,
                                      price: widget.recurrentMatch
                                          .nextRecurrentMatches.first.cost
                                          .toInt(),
                                    ),
                                  );
                                }
                              });
                              Navigator.pushNamed(
                                context,
                                "/checkout",
                                arguments: {
                                  'court': widget.recurrentMatch.court,
                                  'hourPrices': hourPrices,
                                  'sport': widget.recurrentMatch.sport,
                                  'date': null,
                                  'weekday': widget.recurrentMatch.weekday,
                                  'isRecurrent': true,
                                  'isRenovating': true,
                                },
                              );
                            },
                          ),
                        ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: defaultPadding),
                        child: SvgPicture.asset(
                          r"assets/icon/arrow_up.svg",
                          color: primaryLightBlue,
                        ),
                      ),
                    ],
                  )
                : Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: SvgPicture.asset(
                      r"assets/icon/arrow_down.svg",
                      color: primaryLightBlue,
                    ),
                  ),
          ],
        ),
      );
    });
  }
}
