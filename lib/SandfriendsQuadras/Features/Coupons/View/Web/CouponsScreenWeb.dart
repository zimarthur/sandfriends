import 'package:flutter/material.dart';
import 'package:sandfriends/SandfriendsQuadras/Features/Coupons/Model/EnumOrderByCoupon.dart';
import '../../../../../Common/Components/SFButton.dart';
import '../../../../../Common/Components/SFDropDown.dart';
import '../../../../../Common/Components/SFHeader.dart';
import '../../../../../Common/Components/Table/SFTable.dart';
import '../../../../../Common/Components/Table/SFTableHeader.dart';
import '../../../../../Common/Utils/Constants.dart';
import '../../../Menu/ViewModel/MenuProvider.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../ViewModel/CouponsViewModel.dart';

class CouponsScreenWeb extends StatefulWidget {
  const CouponsScreenWeb({super.key});

  @override
  State<CouponsScreenWeb> createState() => _CouponsScreenWebState();
}

class _CouponsScreenWebState extends State<CouponsScreenWeb> {
  final CouponsViewModel viewModel = CouponsViewModel();

  @override
  void initState() {
    viewModel.initViewModel(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = Provider.of<MenuProvider>(context).getScreenWidth(context);
    double height = Provider.of<MenuProvider>(context).getScreenHeight(context);
    return ChangeNotifierProvider<CouponsViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<CouponsViewModel>(
        builder: (context, viewModel, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: SFHeader(
                        header: "Cupons de desconto",
                        description:
                            "Acompanhe suas campanhas de cupons de desconto!"),
                  ),
                  SFButton(
                    buttonLabel: "Adicionar Cupom",
                    onTap: () => viewModel.openAddCouponModal(context),
                    iconFirst: true,
                    iconPath: r"assets/icon/discount_add.svg",
                    textPadding: const EdgeInsets.symmetric(
                      vertical: defaultPadding,
                      horizontal: defaultPadding * 2,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: defaultPadding,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Ordenar por: ",
                    style: TextStyle(
                      color: textDarkGrey,
                    ),
                  ),
                  SizedBox(
                    width: defaultPadding / 2,
                  ),
                  SFDropdown(
                      labelText: viewModel.couponOrderBy.text,
                      items: viewModel.availableCouponOrderBy
                          .map((e) => e.text)
                          .toList(),
                      validator: (value) {},
                      onChanged: (newOrder) => newOrder != null
                          ? viewModel.setCouponOrderBy(
                              context,
                              newOrder,
                            )
                          : null),
                ],
              ),
              SizedBox(
                height: defaultPadding / 2,
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (layoutContext, layoutConstraints) {
                    return SFTable(
                      height: layoutConstraints.maxHeight,
                      width: layoutConstraints.maxWidth,
                      headers: [
                        SFTableHeader("couponCode", "Cupom"),
                        SFTableHeader("couponValue", "Desconto"),
                        SFTableHeader("validDates", "Válido entre"),
                        SFTableHeader("validHour", "Horário"),
                        SFTableHeader("status", "Status"),
                        SFTableHeader("timesUsed", "Utilizações"),
                        SFTableHeader("profit", "Retorno"),
                        SFTableHeader("actions", ""),
                      ],
                      source: viewModel.couponsDataSource!,
                    );
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
