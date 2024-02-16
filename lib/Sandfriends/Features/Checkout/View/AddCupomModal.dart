import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/Common/Model/CreditCard/CreditCard.dart';
import 'package:sandfriends/Common/Model/CreditCard/CreditCardValidator.dart';
import 'package:sandfriends/Common/Utils/Validators.dart';

import '../../../../../Common/Components/SFButton.dart';
import '../../../../../Common/Components/SFTextField.dart';
import '../../../../Common/Utils/Constants.dart';

class AddCupomModal extends StatefulWidget {
  final TextEditingController cupomController;
  final VoidCallback onAddCupom;
  final VoidCallback onReturn;

  AddCupomModal({
    Key? key,
    required this.cupomController,
    required this.onAddCupom,
    required this.onReturn,
  }) : super(key: key);

  @override
  State<AddCupomModal> createState() => _CvvModalState();
}

class _CvvModalState extends State<AddCupomModal> {
  final cupomFormKey = GlobalKey<FormState>();
  final FocusNode cupomFocus = FocusNode();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(cupomFocus);
    });
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
      child: Form(
        key: cupomFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () => widget.onReturn(),
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding / 2),
                  child: SvgPicture.asset(
                    r"assets/icon/cancel.svg",
                    color: textDarkGrey,
                    height: 20,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                SvgPicture.asset(
                  r"assets/icon/discount.svg",
                  color: primaryBlue,
                ),
                SizedBox(
                  width: defaultPadding / 2,
                ),
                const Text(
                  "Cupom de desconto",
                  style: TextStyle(
                      color: primaryBlue, fontWeight: FontWeight.bold),
                  textScaleFactor: 1.2,
                ),
              ],
            ),
            const SizedBox(
              height: defaultPadding / 2,
            ),
            const Text(
              "Acompanhe o Sandfriends nas redes sociais para ficar por dentro dos cupons de desconto!",
              style: TextStyle(
                color: textDarkGrey,
              ),
              textScaleFactor: 0.9,
            ),
            const SizedBox(
              height: 2 * defaultPadding,
            ),
            SFTextField(
              labelText: "cupom",
              focusNode: cupomFocus,
              pourpose: TextFieldPourpose.Standard,
              controller: widget.cupomController,
              validator: (value) => emptyCheck(value, "Digite um cupom"),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: height * 0.03),
            ),
            SFButton(
              buttonLabel: "Adicionar cupom",
              textPadding: EdgeInsets.symmetric(
                vertical: height * 0.02,
              ),
              onTap: () {
                if (cupomFormKey.currentState?.validate() == true) {
                  widget.onAddCupom();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
