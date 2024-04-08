import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';
import 'package:sandfriends/Sandfriends/Providers/TeacherProvider/TeacherProvider.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';
import 'package:sandfriends/SandfriendsAulas/Features/Home/View/Onboarding/EnumOnboardingSteps.dart';

class OnboardingTeacher extends StatefulWidget {
  const OnboardingTeacher({super.key});

  @override
  State<OnboardingTeacher> createState() => _OnboardingTeacherState();
}

class _OnboardingTeacherState extends State<OnboardingTeacher> {
  List<OnboardingSteps> onboarding = [
    OnboardingSteps.Profile,
    OnboardingSteps.ClassPlans,
    OnboardingSteps.Team,
    OnboardingSteps.School,
  ];
  @override
  Widget build(BuildContext context) {
    int? index;
    if (Provider.of<UserProvider>(context).user!.photo == null ||
        Provider.of<UserProvider>(context).user!.photo!.isEmpty ||
        Provider.of<UserProvider>(context).user!.phoneNumber == null ||
        Provider.of<UserProvider>(context).user!.phoneNumber!.isEmpty) {
      index = 0;
    } else if (Provider.of<TeacherProvider>(context)
            .teacher
            .hasSetMinClassPlans ==
        false) {
      index = 1;
    } else if (Provider.of<TeacherProvider>(context).teacher.teams.isEmpty) {
      index = 2;
    } else if (Provider.of<TeacherProvider>(context)
        .teacher
        .teacherSchools
        .isEmpty) {
      index = 3;
    }
    return index == null
        ? Container()
        : Container(
            margin: EdgeInsets.symmetric(
              vertical: defaultPadding,
              horizontal: defaultPadding / 2,
            ),
            decoration: BoxDecoration(
              color: blueBg,
              borderRadius: BorderRadius.circular(
                defaultBorderRadius,
              ),
              border: Border.all(
                color: blueText,
                width: 0.5,
              ),
            ),
            padding: EdgeInsets.all(defaultPadding / 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      r"assets/icon/check_circle.svg",
                      color: blueText,
                      height: 20,
                    ),
                    SizedBox(
                      width: defaultPadding / 2,
                    ),
                    Text(
                      "Você está quase lá!",
                      style: TextStyle(
                        color: blueText,
                      ),
                    ),
                  ],
                ),
                Text(
                  "Veja as etapas restantes para terminar de configurar sua conta",
                  style: TextStyle(
                    color: textDarkGrey,
                    fontWeight: FontWeight.w300,
                    fontSize: 12,
                  ),
                ),
                SizedBox(
                  height: defaultPadding / 2,
                ),
                GestureDetector(
                  onTap: () => onboarding[index!].onNavigate(context),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: secondaryPaper,
                      borderRadius: BorderRadius.circular(
                        defaultBorderRadius,
                      ),
                      border: Border.all(
                        color: divider,
                      ),
                    ),
                    padding: EdgeInsets.all(
                      defaultPadding / 2,
                    ),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          onboarding[index].icon,
                          height: 40,
                        ),
                        SizedBox(
                          height: defaultPadding / 2,
                        ),
                        Text(
                          onboarding[index].title,
                          style: TextStyle(
                            color: primaryBlue,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: defaultPadding / 4,
                        ),
                        Text(
                          onboarding[index].description,
                          style: TextStyle(
                            color: textDarkGrey,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int i = 0; i < onboarding.length; i++)
                              Container(
                                height: 10,
                                width: i == index ? 30 : 10,
                                decoration: BoxDecoration(
                                    color: i == index ? primaryBlue : divider,
                                    borderRadius: BorderRadius.circular(5)),
                                margin: EdgeInsets.symmetric(
                                    horizontal: defaultPadding / 4),
                              )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
