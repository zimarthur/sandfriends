import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends_web/Features/MyCourts/ViewModel/MyCourtsViewModel.dart';
import 'package:sandfriends_web/SharedComponents/View/SFButton.dart';
import 'package:sandfriends_web/Utils/Constants.dart';
import 'package:sandfriends_web/Utils/SFDateTime.dart';

import '../../../../SharedComponents/Model/HourPrice.dart';
import '../../../Menu/ViewModel/MenuProvider.dart';

class PriceListWidget extends StatelessWidget {
  int dayIndex;
  List<HourPrice> hourPriceList;
  MyCourtsViewModel viewModel;

  PriceListWidget({
    super.key,
    required this.dayIndex,
    required this.hourPriceList,
    required this.viewModel,
  });

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
        children: [
          Text(
            weekdayFull[dayIndex],
            style: const TextStyle(color: textBlue, fontSize: 22),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
            child: Row(
              children: const [
                Expanded(
                    flex: 1,
                    child: Text(
                      "Horário",
                      textAlign: TextAlign.center,
                    )),
                Expanded(
                    flex: 1,
                    child: Text(
                      "Avulso",
                      textAlign: TextAlign.center,
                    )),
                Expanded(
                    flex: 1,
                    child: Text(
                      "Mensalista",
                      textAlign: TextAlign.center,
                    )),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: hourPriceList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: defaultPadding / 4),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          "${hourPriceList[index].startingHour.hourString} - ${hourPriceList[index].endingHour.hourString}",
                          style: const TextStyle(color: textDarkGrey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          "R\$${hourPriceList[index].price}",
                          style: const TextStyle(color: textDarkGrey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          hourPriceList[index].recurrentPrice == null
                              ? "-"
                              : "R\$${hourPriceList[index].recurrentPrice}",
                          style: const TextStyle(color: textDarkGrey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          SFButton(
            buttonLabel: "Voltar",
            buttonType: ButtonType.Primary,
            onTap: () => viewModel.closeModal(context),
          )
        ],
      ),
    );
  }
}
