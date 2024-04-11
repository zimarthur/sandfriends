import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sandfriends/Common/Utils/TypeExtensions.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../Components/SFAvatarUser.dart';
import '../../../../Utils/Constants.dart';
import '../../ViewModel/MatchViewModel.dart';
import 'package:auto_size_text/auto_size_text.dart';

class InformationSection extends StatelessWidget {
  final MatchViewModel viewModel;
  const InformationSection({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Detalhes da ${viewModel.isClass ? 'Aula' : 'Partida'}",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            const SizedBox(
              width: defaultPadding / 2,
            ),
            viewModel.match.canceled || viewModel.match.isPaymentExpired
                ? Expanded(
                    child: Text(
                      viewModel.match.canceled
                          ? "Cancelada"
                          : "Pagamento Expirado",
                      textAlign: TextAlign.end,
                      maxLines: 2,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.red),
                    ),
                  )
                : viewModel.match.date.isBefore(DateTime.now())
                    ? Expanded(
                        child: Text(
                          "Encerrada",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: textLightGrey,
                          ),
                        ),
                      )
                    : Container()
          ],
        ),
        Padding(
          padding: EdgeInsets.all(
            defaultPadding,
          ),
          child: Column(
            children: [
              if (viewModel.isClass) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Prof:",
                    ),
                    GestureDetector(
                      onTap: () => viewModel.openMemberCardModal(
                        context,
                        viewModel.match.tacher,
                      ),
                      child: Row(
                        children: [
                          SFAvatarUser(
                            height: 60,
                            user: viewModel.match.team!.teacher!,
                            showRank: false,
                          ),
                          SizedBox(
                            width: defaultPadding / 2,
                          ),
                          Text(
                            viewModel.match.team!.teacher!.fullName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Turma:",
                    ),
                    Text(
                      viewModel.match.team!.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Data:",
                  ),
                  Text(
                    DateFormat("dd/MM/yyyy").format(viewModel.match.date),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
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
                  const Text(
                    "Horário:",
                  ),
                  Text(
                    "${viewModel.match.timeBegin.hourString} - ${viewModel.match.timeEnd.hourString}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
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
                  const Text(
                    "Esporte:",
                  ),
                  Text(
                    viewModel.match.sport.description,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              if (viewModel.isUserTeacher || !viewModel.isClass) ...[
                const SizedBox(
                  height: defaultPadding,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Preço:",
                    ),
                    Text(
                      viewModel.match.userCost.formatPrice(),
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          decoration: viewModel.match.coupon != null
                              ? TextDecoration.lineThrough
                              : null),
                    ),
                  ],
                ),
              ],
              if (viewModel.match.coupon != null)
                Padding(
                  padding: const EdgeInsets.only(top: defaultPadding / 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            SvgPicture.asset(
                                r"assets/icon/discount_outline.svg"),
                            SizedBox(
                              width: defaultPadding / 4,
                            ),
                            Text(
                              viewModel.match.coupon!.couponCode,
                              style: const TextStyle(
                                fontSize: 12,
                                color: primaryBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                      Text(
                        viewModel.match.cost.formatPrice(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: green,
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
  }
}
