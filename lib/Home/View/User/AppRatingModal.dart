import 'package:flutter/material.dart';
import 'package:sandfriends/Home/ViewModel/HomeViewModel.dart';
import 'package:sandfriends/Utils/Constants.dart';

import '../../../Utils/Validators.dart';
import '../../../oldApp/widgets/SF_Button.dart';
import '../../../oldApp/widgets/SF_TextField.dart';

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
      height: height * 0.6,
      child: Form(
        key: widget.viewModel.feedbackFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: height * 0.4,
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.04,
              ),
              child: Column(
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
                  Text(
                    "Escreva aqui sua crítica ou sugestão",
                    style: TextStyle(color: textDarkGrey),
                  ),
                  SFTextField(
                    minLines: 5,
                    maxLines: 6,
                    labelText: "",
                    pourpose: TextFieldPourpose.Multiline,
                    controller: widget.viewModel.feedbackController,
                    validator: max255,
                  ),
                  SFButton(
                    textPadding: EdgeInsets.symmetric(
                      horizontal: width * 0.04,
                      vertical: height * 0.02,
                    ),
                    buttonLabel: "Enviar",
                    buttonType: ButtonType.Primary,
                    onTap: () => widget.viewModel.validateFeedback(context),
                  )
                ],
              ),
            ),
            Text(
              "ou",
              style: TextStyle(
                color: textDarkGrey,
              ),
              textScaleFactor: 0.9,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.05,
              ),
              child: SFButton(
                buttonLabel: "Fale com a gente pelo whats",
                buttonType: ButtonType.Secondary,
                onTap: () => widget.viewModel.contactSupport(),
                iconPath: r"assets\icon\whatsapp.svg",
                textPadding: EdgeInsets.symmetric(
                  horizontal: width * 0.04,
                  vertical: height * 0.02,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
