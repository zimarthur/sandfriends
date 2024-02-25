import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/SandfriendsQuadras/Features/Coupons/Model/EnumOrderByCoupon.dart';
import '../../../../../Common/Components/SFDropDown.dart';
import '../../../../../Common/Utils/Constants.dart';
import '../../../Menu/View/Mobile/SFStandardHeader.dart';
import '../../ViewModel/CouponsViewModel.dart';
import 'CouponItem.dart';

class CouponsScreenMobile extends StatefulWidget {
  const CouponsScreenMobile({super.key});

  @override
  State<CouponsScreenMobile> createState() => _CouponsScreenMobileState();
}

class _CouponsScreenMobileState extends State<CouponsScreenMobile> {
  final CouponsViewModel viewModel = CouponsViewModel();
  @override
  void initState() {
    viewModel.initViewModel(context);

    super.initState();
  }

  double plusButtonHeight = 70;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CouponsViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<CouponsViewModel>(
        builder: (context, viewModel, _) {
          return Container(
            color: secondaryBack,
            child: Column(
              children: [
                SFStandardHeader(
                  title: "Cupons de desconto",
                  leftWidget: InkWell(
                    onTap: () => viewModel.toggleEdit(),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(defaultPadding),
                        margin: const EdgeInsets.only(left: defaultPadding / 2),
                        child: SvgPicture.asset(
                          r"assets/icon/edit.svg",
                          color: textWhite,
                          height: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: defaultPadding / 2,
                        horizontal: defaultPadding / 2),
                    child: LayoutBuilder(
                        builder: (layoutContext, layoutConstraints) {
                      return Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () => viewModel
                                    .toggleShowOnlyActiveCoupons(context),
                                child: Container(
                                  height: 80,
                                  padding: EdgeInsets.all(defaultPadding),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      defaultBorderRadius,
                                    ),
                                    color: blueText,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Cupons em operação",
                                          style: TextStyle(
                                            color:
                                                viewModel.showOnlyActiveCoupons
                                                    ? primaryLightBlue
                                                    : blueBg,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: defaultPadding,
                                      ),
                                      Text(
                                        "${viewModel.currentCoupons}",
                                        style: TextStyle(
                                          color: viewModel.showOnlyActiveCoupons
                                              ? primaryLightBlue
                                              : blueBg,
                                          fontSize: 24,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: defaultPadding,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Cupons",
                                    style: TextStyle(
                                      color: textDarkGrey,
                                    ),
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
                                height: defaultPadding / 4,
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: secondaryPaper,
                                    borderRadius: BorderRadius.circular(
                                      defaultBorderRadius,
                                    ),
                                  ),
                                  child: viewModel.coupons.isEmpty
                                      ? Center(
                                          child: Text(
                                            "Sem cupons",
                                            style: TextStyle(
                                              color: textDarkGrey,
                                            ),
                                          ),
                                        )
                                      : ListView.builder(
                                          itemCount: viewModel.coupons.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: index ==
                                                          viewModel.coupons
                                                                  .length -
                                                              1
                                                      ? plusButtonHeight
                                                      : 0),
                                              child: CouponItem(
                                                coupon:
                                                    viewModel.coupons[index],
                                                editMode: viewModel.editMode,
                                                onDisableCoupon: () => viewModel
                                                    .enableDisableCoupon(
                                                        context,
                                                        viewModel
                                                            .coupons[index],
                                                        true),
                                                onEnableCoupon: () => viewModel
                                                    .enableDisableCoupon(
                                                        context,
                                                        viewModel
                                                            .coupons[index],
                                                        false),
                                              ),
                                            );
                                          },
                                        ),
                                ),
                              ),
                              SizedBox(
                                height: defaultPadding / 2,
                              ),
                            ],
                          ),
                          Positioned(
                            bottom: 0,
                            left: (layoutConstraints.maxWidth -
                                    plusButtonHeight) /
                                2,
                            child: InkWell(
                              onTap: () =>
                                  viewModel.openAddCouponModal(context),
                              child: Container(
                                width: plusButtonHeight,
                                height: plusButtonHeight,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: blueText),
                                child: Center(
                                  child: SvgPicture.asset(
                                    r"assets/icon/plus.svg",
                                    height: 30,
                                    color: blueBg,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
