import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Components/SFAvatarStore.dart';
import 'package:sandfriends/Common/Model/CreditCard/CreditCard.dart';
import 'package:sandfriends/Common/Model/CreditCard/CreditCardValidator.dart';
import 'package:sandfriends/Common/Providers/Categories/CategoriesProvider.dart';
import 'package:sandfriends/Common/Utils/Validators.dart';

import '../../../../../Common/Components/SFButton.dart';
import '../../../../../../Common/Components/SFTextField.dart';
import '../../../../Common/Components/CreditCard/CreditCardCard.dart';
import '../../../../Common/Model/School/School.dart';
import '../../../../Common/Model/School/SchoolStore.dart';
import '../../../../Common/Utils/Constants.dart';
import '../../../../Common/Utils/SFImage.dart';
import '../../Menu/ViewModel/StoreProvider.dart';

class AddSchoolModal extends StatefulWidget {
  School? school;
  VoidCallback onReturn;
  Function(School, Uint8List?) onAddOrEdit;
  AddSchoolModal({
    Key? key,
    required this.school,
    required this.onReturn,
    required this.onAddOrEdit,
  }) : super(key: key);

  @override
  State<AddSchoolModal> createState() => _AddSchoolModalState();
}

class _AddSchoolModalState extends State<AddSchoolModal> {
  final nameControler = TextEditingController();
  final addSchoolFormKey = GlobalKey<FormState>();
  bool isLogoHovered = false;
  int sportId = -1;
  Uint8List? schoolLogo;

  @override
  void initState() {
    if (widget.school != null) {
      nameControler.text = widget.school!.name;
      sportId = widget.school!.sport.idSport;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.school != null;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryDarkBlue, width: 1),
        boxShadow: const [BoxShadow(blurRadius: 1, color: primaryDarkBlue)],
      ),
      width: width * 0.9 > 500 ? 500 : width * 0.9,
      child: Form(
        key: addSchoolFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            Text(
              isEditing ? "Editar escola" : "Nova escola",
              style: TextStyle(
                color: primaryBlue,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MouseRegion(
                  onEnter: (pointer) => setState(() {
                    isLogoHovered = true;
                  }),
                  onExit: (pointer) => setState(() {
                    isLogoHovered = false;
                  }),
                  child: Stack(
                    children: [
                      SFAvatarStore(
                        height: 100,
                        storePhoto: widget.school?.logo ??
                            Provider.of<StoreProvider>(context, listen: false)
                                .store
                                ?.logo,
                        storeName:
                            Provider.of<StoreProvider>(context, listen: false)
                                .store!
                                .name,
                        editImage: schoolLogo,
                      ),
                      if (isLogoHovered)
                        Positioned(
                          top: 20,
                          right: 20,
                          child: InkWell(
                            onTap: () async {
                              final image = await selectImage(context, 1);

                              if (image != null) {
                                setState(() {
                                  schoolLogo = image;
                                });
                              }
                            },
                            child: Container(
                              height: 60,
                              width: 60,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    textDarkGrey,
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                              child: SvgPicture.asset(
                                r"assets/icon/edit.svg",
                                color: textWhite,
                                height: 25,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  width: defaultPadding,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nome",
                        style: TextStyle(
                          color: textDarkGrey,
                        ),
                      ),
                      SizedBox(
                        height: defaultPadding / 4,
                      ),
                      SFTextField(
                          labelText: "",
                          pourpose: TextFieldPourpose.Standard,
                          controller: nameControler,
                          validator: (value) =>
                              emptyCheck(value, "Digite o nome da escola"))
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: defaultPadding * 2,
            ),
            Text(
              "Esporte",
              style: TextStyle(
                color: textDarkGrey,
              ),
            ),
            const SizedBox(
              height: defaultPadding / 4,
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount:
                    Provider.of<CategoriesProvider>(context, listen: false)
                        .sports
                        .length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {},
                    child: Row(
                      children: [
                        Radio(
                            activeColor: isEditing ? textDarkGrey : primaryBlue,
                            value: Provider.of<CategoriesProvider>(context,
                                    listen: false)
                                .sports[index]
                                .idSport,
                            groupValue: sportId,
                            onChanged: (a) {
                              if (!isEditing) {
                                setState(() {
                                  sportId = Provider.of<CategoriesProvider>(
                                          context,
                                          listen: false)
                                      .sports[index]
                                      .idSport;
                                });
                              }
                            }),
                        SizedBox(
                          width: defaultPadding / 2,
                        ),
                        Text(
                          Provider.of<CategoriesProvider>(context,
                                  listen: false)
                              .sports[index]
                              .description,
                          style: TextStyle(
                            color: textDarkGrey,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            const SizedBox(
              height: defaultPadding * 2,
            ),
            SFButton(
              buttonLabel: isEditing ? "Salvar" : "Adicionar",
              textPadding: EdgeInsets.symmetric(
                vertical: height * 0.02,
              ),
              onTap: () {
                if (addSchoolFormKey.currentState?.validate() == true &&
                    sportId != -1) {
                  FocusScope.of(context).unfocus();
                  widget.onAddOrEdit(
                    SchoolStore(
                      idSchool: isEditing ? widget.school!.idSchool : -1,
                      name: nameControler.text,
                      creationDate: DateTime.now(),
                      sport: Provider.of<CategoriesProvider>(context,
                              listen: false)
                          .sports
                          .firstWhere(
                            (sport) => sport.idSport == sportId,
                          ),
                      logo: null,
                    ),
                    schoolLogo,
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
