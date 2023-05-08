import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Utils/Constants.dart';
import '../../oldApp/widgets/SF_Button.dart';
import '../Model/Sport.dart';
import '../Providers/CategoriesProvider/CategoriesProvider.dart';

class SportSelector extends StatelessWidget {
  bool isRecurrentMatch;
  Function(Sport) onSportSelected;
  SportSelector({
    required this.isRecurrentMatch,
    required this.onSportSelected,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height - 75;
    return Container(
      color: isRecurrentMatch ? secondaryLightBlue : primaryBlue,
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
                        buttonType: isRecurrentMatch
                            ? ButtonType.LightBlueSecondary
                            : ButtonType.Secondary,
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
