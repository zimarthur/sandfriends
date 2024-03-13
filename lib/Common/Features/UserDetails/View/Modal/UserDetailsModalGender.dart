import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Model/Gender.dart';
import '../../../../Providers/Categories/CategoriesProvider.dart';
import '../../../../Components/SFButton.dart';
import '../../../../Utils/Constants.dart';
import '../../ViewModel/UserDetailsViewModel.dart';

class UserDetailsModalGender extends StatefulWidget {
  final UserDetailsViewModel viewModel;
  const UserDetailsModalGender({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  State<UserDetailsModalGender> createState() => _UserDetailsModalGenderState();
}

class _UserDetailsModalGenderState extends State<UserDetailsModalGender> {
  late Gender currentGender;

  @override
  void initState() {
    currentGender = widget.viewModel.userEdited.gender == null
        ? Provider.of<CategoriesProvider>(context, listen: false).genders.first
        : widget.viewModel.userEdited.gender!;
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
                  .genders
                  .length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      currentGender = Provider.of<CategoriesProvider>(context,
                              listen: false)
                          .genders[index];
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
                        color: currentGender ==
                                Provider.of<CategoriesProvider>(context)
                                    .genders[index]
                            ? primaryBlue
                            : textLightGrey,
                        width: currentGender ==
                                Provider.of<CategoriesProvider>(context)
                                    .genders[index]
                            ? 2
                            : 1,
                      ),
                    ),
                    child: Text(
                      Provider.of<CategoriesProvider>(context, listen: false)
                          .genders[index]
                          .name,
                      style: TextStyle(
                          color: currentGender ==
                                  Provider.of<CategoriesProvider>(context)
                                      .genders[index]
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
            onTap: () => widget.viewModel.setUserGender(context, currentGender),
          )
        ],
      ),
    );
  }
}
