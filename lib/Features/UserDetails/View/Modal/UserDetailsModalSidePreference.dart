import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../SharedComponents/Model/SidePreference.dart';
import '../../../../SharedComponents/Providers/CategoriesProvider/CategoriesProvider.dart';
import '../../../../Utils/Constants.dart';
import '../../../../oldApp/widgets/SF_Button.dart';
import '../../ViewModel/UserDetailsViewModel.dart';

class UserDetailsModalSidePreference extends StatefulWidget {
  UserDetailsViewModel viewModel;
  UserDetailsModalSidePreference({
    required this.viewModel,
  });

  @override
  State<UserDetailsModalSidePreference> createState() =>
      _UserDetailsModalSidePreferenceState();
}

class _UserDetailsModalSidePreferenceState
    extends State<UserDetailsModalSidePreference> {
  late SidePreference currentSidePreference;

  @override
  void initState() {
    currentSidePreference = widget.viewModel.userEdited.sidePreference == null
        ? Provider.of<CategoriesProvider>(context, listen: false)
            .sidePreferences
            .first
        : widget.viewModel.userEdited.sidePreference!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: height * 0.04,
      ),
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryDarkBlue, width: 1),
        boxShadow: const [BoxShadow(blurRadius: 1, color: primaryDarkBlue)],
      ),
      width: width * 0.9,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: height * 0.3,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: Provider.of<CategoriesProvider>(context, listen: false)
                  .sidePreferences
                  .length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      currentSidePreference = Provider.of<CategoriesProvider>(
                              context,
                              listen: false)
                          .sidePreferences[index];
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
                        color: currentSidePreference ==
                                Provider.of<CategoriesProvider>(context)
                                    .sidePreferences[index]
                            ? primaryBlue
                            : textLightGrey,
                        width: currentSidePreference ==
                                Provider.of<CategoriesProvider>(context)
                                    .sidePreferences[index]
                            ? 2
                            : 1,
                      ),
                    ),
                    child: Text(
                      Provider.of<CategoriesProvider>(context, listen: false)
                          .sidePreferences[index]
                          .name,
                      style: TextStyle(
                          color: currentSidePreference ==
                                  Provider.of<CategoriesProvider>(context)
                                      .sidePreferences[index]
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
            textPadding: EdgeInsets.symmetric(
              vertical: height * 0.02,
            ),
            onTap: () =>
                widget.viewModel.setUserSidePreference(currentSidePreference),
          )
        ],
      ),
    );
  }
}
