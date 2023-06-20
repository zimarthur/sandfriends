import 'package:flutter/material.dart';

import '../../../../SharedComponents/View/SFButton.dart';
import '../../../../SharedComponents/View/SFTextField.dart';
import '../../../../Utils/Constants.dart';
import '../../../../Utils/Validators.dart';
import '../../ViewModel/HomeViewModel.dart';

class AppRatingModal extends StatefulWidget {
  HomeViewModel viewModel;
  AppRatingModal({
    required this.viewModel,
  });

  @override
  State<AppRatingModal> createState() => _AppRatingModalState();
}

class _AppRatingModalState extends State<AppRatingModal> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryDarkBlue, width: 1),
        boxShadow: [BoxShadow(blurRadius: 1, color: primaryDarkBlue)],
      ),
      width: width * 0.9,
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.05,
        vertical: height * 0.02,
      ),
      child: Form(
        key: widget.viewModel.feedbackFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Envie seu feedback!",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: textBlue,
                  ),
                  textScaleFactor: 1.2,
                ),
                SizedBox(
                  height: height * 0.005,
                ),
                Text(
                  "Escreva aqui sua crítica ou sugestão",
                  style: TextStyle(color: textDarkGrey),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                SFTextField(
                  minLines: 5,
                  maxLines: 6,
                  labelText: "",
                  pourpose: TextFieldPourpose.Multiline,
                  controller: widget.viewModel.feedbackController,
                  validator: (value) => max255(value, "Escreva um comentário"),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                SFButton(
                  textPadding: EdgeInsets.symmetric(
                    horizontal: width * 0.04,
                    vertical: height * 0.02,
                  ),
                  buttonLabel: "Enviar",
                  onTap: () => widget.viewModel.validateFeedback(context),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: height * 0.02),
              child: Text(
                "ou",
                style: TextStyle(
                  color: textDarkGrey,
                ),
                textScaleFactor: 0.9,
              ),
            ),
            SFButton(
              buttonLabel: "Fale com a gente pelo whats",
              isPrimary: false,
              onTap: () => widget.viewModel.contactSupport(),
              iconPath: r"assets\icon\whatsapp.svg",
              textPadding: EdgeInsets.symmetric(
                horizontal: width * 0.04,
                vertical: height * 0.02,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
