import 'package:flutter/material.dart';

import '../../../SharedComponents/Model/Sport.dart';
import '../../../Utils/Constants.dart';

class SportSelectorModal extends StatefulWidget {
  final List<Sport> sports;
  final Sport? selectedSport;
  final Function(Sport) onSelectedSport;
  const SportSelectorModal({
    Key? key,
    required this.sports,
    required this.selectedSport,
    required this.onSelectedSport,
  }) : super(key: key);

  @override
  State<SportSelectorModal> createState() => _SportSelectorModalState();
}

class _SportSelectorModalState extends State<SportSelectorModal> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryDarkBlue, width: 1),
        boxShadow: const [BoxShadow(blurRadius: 1, color: primaryDarkBlue)],
      ),
      width: width * 0.9,
      padding: EdgeInsets.symmetric(
          vertical: width * 0.02, horizontal: width * 0.04),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: height * 0.05,
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: height * 0.01),
            child: const FittedBox(
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
              itemCount: widget.sports.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => widget.onSelectedSport(
                    widget.sports[index],
                  ),
                  child: Container(
                    margin: EdgeInsets.only(bottom: height * 0.02),
                    padding: EdgeInsets.symmetric(
                        vertical: height * 0.02, horizontal: width * 0.05),
                    decoration: BoxDecoration(
                      color: secondaryBack,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: widget.sports[index] == widget.selectedSport
                            ? primaryBlue
                            : textLightGrey,
                        width: widget.sports[index] == widget.selectedSport
                            ? 2
                            : 1,
                      ),
                    ),
                    child: Text(
                      widget.sports[index].description,
                      style: TextStyle(
                          color: widget.sports[index] == widget.selectedSport
                              ? textBlue
                              : textDarkGrey),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
