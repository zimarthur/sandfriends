import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Model/Classes/School/School.dart';
import 'package:sandfriends/Common/Utils/TypeExtensions.dart';

import '../../../../Common/Components/SFAvatarStore.dart';
import '../../../../Common/Utils/Constants.dart';
import '../../Menu/ViewModel/StoreProvider.dart';

class SchoolDetails extends StatefulWidget {
  School school;
  VoidCallback onTap;
  VoidCallback onEdit;
  SchoolDetails({
    required this.onTap,
    required this.onEdit,
    required this.school,
    super.key,
  });

  @override
  State<SchoolDetails> createState() => _SchoolDetailsState();
}

class _SchoolDetailsState extends State<SchoolDetails> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: EdgeInsets.only(
        bottom: defaultPadding,
      ),
      decoration: BoxDecoration(
        color: primaryBlue,
        borderRadius: BorderRadius.circular(
          defaultBorderRadius,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onHover: (hover) {
                setState(() {
                  isHovered = hover;
                });
              },
              onTap: () => widget.onTap(),
              child: Container(
                decoration: BoxDecoration(
                  color: secondaryPaper,
                  borderRadius: BorderRadius.circular(
                    defaultBorderRadius,
                  ),
                  border: Border.all(
                      color: isHovered ? primaryBlue : divider,
                      width: isHovered ? 2 : 1),
                ),
                padding: EdgeInsets.all(
                  defaultPadding / 2,
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: Row(
                      children: [
                        SFAvatarStore(
                          height: 80,
                          storePhoto: widget.school.logo ??
                              Provider.of<StoreProvider>(context, listen: false)
                                  .store
                                  ?.logo,
                          storeName: widget.school.name,
                        ),
                        SizedBox(
                          width: defaultPadding / 2,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.school.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                                Text(
                                  widget.school.sport.description,
                                  style: TextStyle(
                                    color: textDarkGrey,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  "desde ${widget.school.creationDate.formatWrittenMonthYear()}",
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
                    )),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: defaultPadding / 2,
                          vertical: defaultPadding / 4),
                      color: divider,
                      width: 1,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: defaultPadding / 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      r"assets/icon/class.svg",
                                      color: primaryBlue,
                                      height: 20,
                                    ),
                                    SizedBox(
                                      width: defaultPadding / 2,
                                    ),
                                    Text(
                                      "2 professores",
                                      style: TextStyle(
                                        color: textDarkGrey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      r"assets/icon/user_group.svg",
                                      color: primaryBlue,
                                      height: 20,
                                    ),
                                    SizedBox(
                                      width: defaultPadding / 2,
                                    ),
                                    Text(
                                      "68 alunos",
                                      style: TextStyle(
                                        color: textDarkGrey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                            SizedBox(
                              width: defaultPadding / 2,
                            ),
                            Expanded(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "8 aulas/semana",
                                  style: TextStyle(
                                    color: textDarkGrey,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  "12 horas",
                                  style: TextStyle(
                                    color: textDarkGrey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            )),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: defaultPadding / 2,
                          vertical: defaultPadding / 4),
                      color: divider,
                      width: 1,
                    ),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              r"assets/icon/money.svg",
                              color: greenText,
                              height: 25,
                            ),
                            SizedBox(
                              width: defaultPadding / 2,
                            ),
                            Text(
                              r"R$ 450 (nesse mês)",
                              style: TextStyle(
                                color: greenText,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: defaultPadding / 4,
                        ),
                        Text(
                          r"R$ 320 (mês passado)",
                          style: TextStyle(
                            color: textDarkGrey,
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () => widget.onEdit(),
            child: SizedBox(
              width: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    r"assets/icon/edit.svg",
                    color: textWhite,
                  ),
                  SizedBox(
                    height: defaultPadding / 4,
                  ),
                  Text(
                    "Editar",
                    style: TextStyle(
                      color: textWhite,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
    ;
  }
}
