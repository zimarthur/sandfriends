import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/SharedComponents/ViewModel/DataProvider.dart';
import 'package:sandfriends/Utils/Constants.dart';

import '../../SharedComponents/Model/Sport.dart';
import '../../oldApp/widgets/SF_Button.dart';

class SportSelectorModal extends StatefulWidget {
  Sport? selectedSport;
  VoidCallback onClose;
  SportSelectorModal({
    required this.selectedSport,
    required this.onClose,
  });

  @override
  State<SportSelectorModal> createState() => _SportSelectorModalState();
}

class _SportSelectorModalState extends State<SportSelectorModal> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: height * 0.04,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: height * 0.05,
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: height * 0.01),
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                "Selecione seu esporte de preferência",
                style: TextStyle(color: textBlue, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.3,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: Provider.of<DataProvider>(context, listen: false)
                  .sports
                  .length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      widget.selectedSport =
                          Provider.of<DataProvider>(context, listen: false)
                              .sports[index];
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: height * 0.02),
                    padding: EdgeInsets.symmetric(
                        vertical: height * 0.02, horizontal: width * 0.05),
                    decoration: BoxDecoration(
                      color: secondaryBack,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Provider.of<DataProvider>(context, listen: false)
                                    .sports[index] ==
                                widget.selectedSport
                            ? primaryBlue
                            : textLightGrey,
                        width: Provider.of<DataProvider>(context, listen: false)
                                    .sports[index] ==
                                widget.selectedSport
                            ? 2
                            : 1,
                      ),
                    ),
                    child: Text(
                      Provider.of<DataProvider>(context, listen: false)
                          .sports[index]
                          .description,
                      style: TextStyle(
                          color:
                              Provider.of<DataProvider>(context, listen: false)
                                          .sports[index] ==
                                      widget.selectedSport
                                  ? textBlue
                                  : textDarkGrey),
                    ),
                  ),
                );
              },
            ),
          ),
          SFButton(
            buttonLabel: "Concluído",
            buttonType: ButtonType.Primary,
            textPadding: EdgeInsets.symmetric(
              vertical: height * 0.02,
            ),
            onTap: () => widget.onClose,
          )
        ],
      ),
    );
  }
}
