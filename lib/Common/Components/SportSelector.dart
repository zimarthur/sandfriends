import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Common/Utils/Constants.dart';
import '../../Common/Model/Sport.dart';
import '../Providers/Categories/CategoriesProvider.dart';
import 'SFButton.dart';

class SportSelector extends StatelessWidget {
  final bool isRecurrentMatch;
  final Function(Sport) onSportSelected;
  const SportSelector({
    Key? key,
    required this.isRecurrentMatch,
    required this.onSportSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height - 75;
    return Container(
      color: isRecurrentMatch ? primaryLightBlue : primaryBlue,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                  left: width * 0.1, right: width * 0.1, top: height * 0.1),
              width: width,
              height: height * 0.2,
              child: const FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  "O que você quer jogar?",
                  style: TextStyle(
                    color: textWhite,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount:
                      Provider.of<CategoriesProvider>(context, listen: false)
                          .sports
                          .length,
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: height * 0.05,
                    );
                  },
                  itemBuilder: ((context, index) {
                    return Container(
                      height: height * 0.1,
                      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                      child: SFButton(
                        buttonLabel: Provider.of<CategoriesProvider>(context,
                                listen: false)
                            .sports[index]
                            .description,
                        color:
                            isRecurrentMatch ? primaryLightBlue : primaryBlue,
                        isPrimary: false,
                        textPadding:
                            EdgeInsets.symmetric(vertical: height * 0.025),
                        onTap: () => onSportSelected(
                          Provider.of<CategoriesProvider>(context,
                                  listen: false)
                              .sports[index],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
