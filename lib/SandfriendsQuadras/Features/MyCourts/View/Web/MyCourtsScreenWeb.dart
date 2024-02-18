import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../Common/Components/SFButton.dart';
import '../../../../../Common/Components/SFHeader.dart';
import '../../../../../Common/Utils/Constants.dart';
import '../../../Menu/ViewModel/MenuProvider.dart';
import '../../../Menu/ViewModel/DataProvider.dart';
import '../../ViewModel/MyCourtsViewModel.dart';
import 'CourtDay/CourtDay.dart';
import 'CourtDay/ResumedInfoRowHeader.dart';
import 'CourtInfo.dart';
import 'MyCourtsTabSelector.dart';
import 'NoHoursFound.dart';

class MyCourtsScreenWeb extends StatefulWidget {
  bool? quickLinkWorkingHours;
  MyCourtsScreenWeb({super.key, this.quickLinkWorkingHours = false});

  @override
  State<MyCourtsScreenWeb> createState() => _MyCourtsScreenWebState();
}

class _MyCourtsScreenWebState extends State<MyCourtsScreenWeb> {
  final MyCourtsViewModel viewModel = MyCourtsViewModel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.init(context);
      if (widget.quickLinkWorkingHours == true) {
        viewModel.setWorkingHoursWidget(context, viewModel);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = Provider.of<MenuProvider>(context).getScreenWidth(context);
    double height = Provider.of<MenuProvider>(context).getScreenHeight(context);
    double courtInfoWidth = width * 0.3 < 300 ? 300 : width * 0.3;
    double courtWeekdayWidth = width -
        courtInfoWidth -
        5 * defaultPadding -
        4; // o 4 foi por causa da borda

    return ChangeNotifierProvider<MyCourtsViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<MyCourtsViewModel>(
        builder: (context, viewModel, _) {
          return Container(
            color: secondaryBack,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: SFHeader(
                        header: "Minhas quadras",
                        description:
                            "Configure as quadras do seu estabelecimento!",
                      ),
                    ),
                    SFButton(
                      buttonLabel: "Horário de funcionamento",
                      isPrimary: false,
                      iconFirst: true,
                      iconPath: r"assets/icon/clock.svg",
                      onTap: () {
                        viewModel.setWorkingHoursWidget(context, viewModel);
                      },
                      textPadding: const EdgeInsets.symmetric(
                        vertical: defaultPadding,
                        horizontal: defaultPadding,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      height: 2,
                      width: double.infinity,
                      color: divider,
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        children: [
                          MyCourtsTabSelector(
                            title: "Nova Quadra",
                            isSelected: viewModel.selectedCourtIndex == -1
                                ? true
                                : false,
                            iconPath: r'assets/icon/plus.svg',
                            onTap: () {
                              viewModel.switchTabs(-1);
                            },
                            mouseCursor: Provider.of<DataProvider>(context)
                                        .storeWorkingDays ==
                                    null
                                ? SystemMouseCursors.basic
                                : SystemMouseCursors.click,
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: Provider.of<DataProvider>(context)
                                  .courts
                                  .length,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return MyCourtsTabSelector(
                                  title: Provider.of<DataProvider>(context)
                                      .courts[index]
                                      .description,
                                  isSelected:
                                      viewModel.selectedCourtIndex == index
                                          ? true
                                          : false,
                                  onTap: () {
                                    setState(() {
                                      viewModel.switchTabs(index);
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                          if (viewModel.selectedCourtIndex != -1 &&
                              viewModel.courtInfoChanged)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: defaultPadding / 4),
                              child: SFButton(
                                buttonLabel: "Salvar",
                                textPadding: const EdgeInsets.symmetric(
                                  horizontal: defaultPadding,
                                ),
                                onTap: () =>
                                    viewModel.saveCourtChanges(context),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: divider,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(defaultBorderRadius),
                        bottomRight: Radius.circular(defaultBorderRadius),
                      ),
                    ),
                    child: Container(
                      margin:
                          const EdgeInsets.only(bottom: 2, left: 2, right: 2),
                      padding: const EdgeInsets.all(defaultPadding),
                      decoration: const BoxDecoration(
                        color: secondaryPaper,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(defaultBorderRadius),
                          bottomRight: Radius.circular(defaultBorderRadius),
                        ),
                      ),
                      child: viewModel.storeWorkingDays.isEmpty
                          ? SizedBox(
                              width: width,
                              child: NoHoursFound(),
                            )
                          : Row(
                              children: [
                                SizedBox(
                                  width: courtInfoWidth,
                                  height: height,
                                  child: CourtInfo(
                                    viewModel: viewModel,
                                  ),
                                ),
                                const SizedBox(
                                  width: defaultPadding,
                                ),
                                Expanded(
                                  child: LayoutBuilder(
                                    builder: (ctx, cnst) {
                                      double myHeight = (cnst.maxHeight -
                                                      6 * defaultPadding) /
                                                  8 >
                                              50
                                          ? (cnst.maxHeight -
                                                  6 * defaultPadding) /
                                              8
                                          : 50;
                                      return Column(
                                        children: [
                                          Container(
                                            height: myHeight,
                                            padding: const EdgeInsets.all(2),
                                            margin: const EdgeInsets.only(
                                                right: 50),
                                            width: courtWeekdayWidth,
                                            child: const ResumedInfoRowHeader(),
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount: viewModel.currentCourt
                                                  .operationDays.length,
                                              itemBuilder: (context, index) {
                                                return Column(
                                                  children: [
                                                    CourtDay(
                                                      width: courtWeekdayWidth,
                                                      height: myHeight,
                                                      operationDay: viewModel
                                                          .currentCourt
                                                          .operationDays[index],
                                                      viewModel: viewModel,
                                                    ),
                                                    if (index !=
                                                        viewModel
                                                                .currentCourt
                                                                .operationDays
                                                                .length -
                                                            1)
                                                      const SizedBox(
                                                        height: defaultPadding,
                                                      )
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                    ),
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
