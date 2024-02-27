import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../Common/Components/SFButton.dart';
import '../../../../../Common/Model/SandfriendsQuadras/StoreWorkingHours.dart';
import '../../../../../Common/Providers/CategoriesProvider/CategoriesProvider.dart';
import '../../../../../Common/Utils/Constants.dart';
import '../../../Menu/ViewModel/StoreProvider.dart';
import '../../../Menu/ViewModel/MenuProvider.dart';
import '../../ViewModel/MyCourtsViewModel.dart';
import 'HourSelector.dart';

class WorkingHoursModal extends StatefulWidget {
  MyCourtsViewModel viewModel;

  WorkingHoursModal({
    super.key,
    required this.viewModel,
  });

  @override
  State<WorkingHoursModal> createState() => _WorkingHoursWidgetState();
}

class _WorkingHoursWidgetState extends State<WorkingHoursModal> {
  List<StoreWorkingDay> storeWorkingDays = [];

  @override
  void initState() {
    if (widget.viewModel.storeWorkingDays.isEmpty) {
      for (int dayIndex = 0; dayIndex < 7; dayIndex++) {
        storeWorkingDays.add(
          StoreWorkingDay(
            weekday: dayIndex,
            startingHour:
                Provider.of<CategoriesProvider>(context, listen: false)
                    .hours
                    .reduce((a, b) => a.hour < b.hour ? a : b),
            endingHour: Provider.of<CategoriesProvider>(context, listen: false)
                .hours
                .reduce((a, b) => a.hour > b.hour ? a : b),
            isEnabled: true,
          ),
        );
      }
    } else {
      for (var storeWorkingDay in widget.viewModel.storeWorkingDays) {
        storeWorkingDays.add(
          StoreWorkingDay.copyFrom(
            storeWorkingDay,
          ),
        );
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = Provider.of<MenuProvider>(context).getScreenWidth(context);
    double height = Provider.of<MenuProvider>(context).getScreenHeight(context);
    return Container(
      height: height * 0.8,
      width: 500,
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        border: Border.all(
          color: divider,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Horário de funcionamento.",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              Text(
                "Configure o horário de funcionamento do seu estabelecimento",
                style: TextStyle(color: textDarkGrey, fontSize: 14),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (var storeWorkingDay in storeWorkingDays)
                          Expanded(
                            child: HourSelector(
                              storeWorkingDay: storeWorkingDay,
                              availableHours: Provider.of<CategoriesProvider>(
                                      context,
                                      listen: false)
                                  .hours,
                            ),
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: SFButton(
                  buttonLabel: "Voltar",
                  isPrimary: false,
                  onTap: () {
                    widget.viewModel.closeModal(context);
                  },
                ),
              ),
              const SizedBox(
                width: defaultPadding,
              ),
              Expanded(
                child: SFButton(
                  buttonLabel: "Salvar",
                  onTap: () {
                    widget.viewModel
                        .saveNewStoreWorkingDays(context, storeWorkingDays);
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
