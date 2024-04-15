import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/SandfriendsAulas/Features/ClassPlans/View/AddPlanWidget.dart';
import 'package:sandfriends/SandfriendsAulas/Features/ClassPlans/View/ClassPlanItem.dart';
import 'package:sandfriends/SandfriendsAulas/SharedComponents/AulasSectionTitleText.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../Common/Utils/Constants.dart';
import '../../../../Sandfriends/Providers/TeacherProvider/TeacherProvider.dart';
import '../ViewModel/ClassPlansScreenViewModel.dart';

class ClassPlansWidget extends StatefulWidget {
  ClassPlansScreenAulasViewModel viewModel;

  ClassPlansWidget({required this.viewModel, super.key});

  @override
  State<ClassPlansWidget> createState() => _ClassPlansWidgetState();
}

class _ClassPlansWidgetState extends State<ClassPlansWidget> {
  final ItemScrollController scrollController = ItemScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (Provider.of<TeacherProvider>(context).teacher.hasSetMinClassPlans ==
            false)
          Container(
            margin: EdgeInsets.only(top: defaultPadding),
            decoration: BoxDecoration(
              color: redBg,
              borderRadius: BorderRadius.circular(
                defaultBorderRadius,
              ),
              border: Border.all(
                color: redText,
              ),
            ),
            padding: EdgeInsets.all(defaultPadding / 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  r"assets/icon/attention.svg",
                  color: redText,
                  height: 25,
                ),
                SizedBox(
                  width: defaultPadding,
                ),
                Expanded(
                    child: Column(
                  children: [
                    Text(
                      "Seus planos ainda não estão completos",
                      style: TextStyle(
                        color: redText,
                      ),
                    ),
                    Text(
                      "Você precisa ter, pelo menos, um plano avulso nas modalidades individual, em dupla e em grupo",
                      style: TextStyle(
                        color: textDarkGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ))
              ],
            ),
          ),
        SizedBox(
          height: defaultPadding,
        ),
        AddPlanWidget(
          viewModel: widget.viewModel,
        ),
        SizedBox(
          height: defaultPadding,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SectionTitleText(
              title: "Meus planos",
            ),
            InkWell(
              onTap: () => widget.viewModel.setCurrentPlan(context),
              child: SvgPicture.asset(
                r"assets/icon/plus_circle.svg",
                height: 25,
              ),
            ),
          ],
        ),
        SizedBox(
          height: defaultPadding,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => widget.viewModel.closeAddPlan(),
            child: ScrollablePositionedList.builder(
                itemScrollController: scrollController,
                padding: EdgeInsets.zero,
                itemCount: Provider.of<TeacherProvider>(context)
                    .teacher
                    .classPlans
                    .length,
                itemBuilder: (context, index) {
                  return index >=
                          Provider.of<TeacherProvider>(context)
                              .teacher
                              .classPlans
                              .length
                      ? Container()
                      : ClassPlanItem(
                          onTap: () {
                            Future.delayed(
                                Duration(
                                    milliseconds: widget.viewModel.isEditingPlan
                                        ? 0
                                        : 300), () {
                              scrollController.scrollTo(
                                index: index,
                                duration: const Duration(
                                  milliseconds: 300,
                                ),
                              );
                            });
                            widget.viewModel.setCurrentPlan(
                              context,
                              editPlan: Provider.of<TeacherProvider>(context,
                                      listen: false)
                                  .teacher
                                  .classPlans[index],
                            );
                          },
                          onDelete: () => widget.viewModel.deletePlan(
                            context,
                          ),
                          classPlan: Provider.of<TeacherProvider>(context)
                              .teacher
                              .classPlans[index],
                          isSelected: widget.viewModel.currentPlan != null &&
                              widget.viewModel.currentPlan!.idClassPlan ==
                                  Provider.of<TeacherProvider>(context)
                                      .teacher
                                      .classPlans[index]
                                      .idClassPlan,
                        );
                }),
          ),
        ),
      ],
    );
  }
}
