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
              onTap: () => widget.viewModel.setCurrentPlan(),
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
                itemCount:
                    Provider.of<TeacherProvider>(context).classPlans.length,
                itemBuilder: (context, index) {
                  return index >=
                          Provider.of<TeacherProvider>(context)
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
                              editPlan: Provider.of<TeacherProvider>(context,
                                      listen: false)
                                  .classPlans[index],
                            );
                          },
                          onDelete: () => widget.viewModel.deletePlan(
                            context,
                          ),
                          classPlan: Provider.of<TeacherProvider>(context)
                              .classPlans[index],
                          isSelected: widget.viewModel.currentPlan != null &&
                              widget.viewModel.currentPlan!.idClassPlan ==
                                  Provider.of<TeacherProvider>(context)
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
