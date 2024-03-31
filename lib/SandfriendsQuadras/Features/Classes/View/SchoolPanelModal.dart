import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Components/SFAvatarStore.dart';
import 'package:sandfriends/Common/Components/SFAvatarUser.dart';
import 'package:sandfriends/Common/Model/CreditCard/CreditCard.dart';
import 'package:sandfriends/Common/Model/CreditCard/CreditCardValidator.dart';
import 'package:sandfriends/Common/Providers/Categories/CategoriesProvider.dart';
import 'package:sandfriends/Common/Utils/TypeExtensions.dart';
import 'package:sandfriends/Common/Utils/Validators.dart';

import '../../../../../Common/Components/SFButton.dart';
import '../../../../../../Common/Components/SFTextField.dart';
import '../../../../Common/Components/CreditCard/CreditCardCard.dart';
import '../../../../Common/Model/School/School.dart';
import '../../../../Common/Model/Teacher.dart';
import '../../../../Common/Utils/Constants.dart';
import '../../../../Common/Utils/SFImage.dart';
import '../../Menu/ViewModel/StoreProvider.dart';

class SchoolPanelModal extends StatefulWidget {
  School school;
  VoidCallback onReturn;
  VoidCallback onAddTeacher;

  SchoolPanelModal({
    required this.school,
    required this.onReturn,
    required this.onAddTeacher,
    Key? key,
  }) : super(key: key);

  @override
  State<SchoolPanelModal> createState() => _SchoolPanelModalState();
}

class _SchoolPanelModalState extends State<SchoolPanelModal> {
  @override
  Widget build(BuildContext context) {
    final school = Provider.of<StoreProvider>(context)
        .schools
        .firstWhere((element) => element.idSchool == widget.school.idSchool);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        border: Border.all(color: divider, width: 1),
        boxShadow: const [BoxShadow(blurRadius: 1, color: divider)],
      ),
      width: width * 0.9 > 1100 ? 1100 : width * 0.9,
      height: height * 0.9 > 800 ? 800 : height * 0.9,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: secondaryBackWeb,
                borderRadius: BorderRadius.circular(
                  defaultBorderRadius,
                ),
                border: Border.all(
                  color: divider,
                ),
              ),
              padding: EdgeInsets.all(
                defaultPadding,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      SFAvatarStore(
                        height: 100,
                        storePhoto: school.logo ??
                            Provider.of<StoreProvider>(context, listen: false)
                                .store
                                ?.logo,
                        storeName: school.name,
                      ),
                      SizedBox(
                        width: defaultPadding,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                school.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                              SizedBox(
                                height: defaultPadding,
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    school.sport.iconLocation,
                                    height: 25,
                                  ),
                                  SizedBox(
                                    width: defaultPadding / 2,
                                  ),
                                  Text(
                                    school.sport.description,
                                    style: TextStyle(
                                      color: textDarkGrey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: defaultPadding / 4,
                              ),
                              Text(
                                "desde ${school.creationDate.formatWrittenMonthYear()}",
                                style: TextStyle(
                                  color: textDarkGrey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(
            width: 300,
            padding: EdgeInsets.all(
              defaultPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () => widget.onReturn(),
                    child: SvgPicture.asset(
                      r"assets/icon/x.svg",
                      color: textDarkGrey,
                    ),
                  ),
                ),
                SizedBox(
                  height: defaultPadding,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Professores",
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                        color: textDarkGrey,
                      ),
                    ),
                    InkWell(
                      onTap: () => widget.onAddTeacher(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: primaryBlue,
                          shape: BoxShape.circle,
                        ),
                        height: 30,
                        width: 30,
                        child: Center(
                          child: Text(
                            "+",
                            style: TextStyle(
                              color: textWhite,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: defaultPadding,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: school.teachers.length,
                      itemBuilder: (context, index) {
                        Teacher teacher = school.teachers[index];
                        return SizedBox(
                          height: 70,
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                  left: 60,
                                  top: defaultPadding / 2,
                                  bottom: defaultPadding / 2,
                                ),
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            teacher.user.fullName,
                                            style: TextStyle(
                                              color: primaryBlue,
                                            ),
                                          ),
                                          if (teacher.entryDate != null)
                                            Text(
                                              "desde ${teacher.entryDate!.formatWrittenMonthYear()}",
                                              style: TextStyle(
                                                color: textDarkGrey,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    if (teacher.waitingApproval)
                                      Container(
                                        decoration: BoxDecoration(
                                          color: secondaryYellowDark50,
                                          borderRadius: BorderRadius.circular(
                                            defaultBorderRadius / 2,
                                          ),
                                        ),
                                        padding: EdgeInsets.all(
                                          defaultPadding / 4,
                                        ),
                                        child: Text(
                                          "Solic.\nenviada",
                                          style: TextStyle(
                                            color: secondaryYellowDark,
                                            fontSize: 10,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                  ],
                                ),
                              ),
                              SFAvatarStore(
                                height: 50,
                                user: teacher.user,
                              ),
                            ],
                          ),
                        );
                      }),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
