import 'package:flutter/material.dart';

import '../../../Utils/Constants.dart';
import '../../../Utils/Validators.dart';
import '../../../oldApp/widgets/SF_Button.dart';
import '../../../oldApp/widgets/SF_TextField.dart';
import '../ViewModel/MatchViewModel.dart';

class CreatorNotesSection extends StatefulWidget {
  MatchViewModel viewModel;
  CreatorNotesSection({
    required this.viewModel,
  });

  @override
  State<CreatorNotesSection> createState() => _CreatorNotesSectionState();
}

class _CreatorNotesSectionState extends State<CreatorNotesSection> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return widget.viewModel.hideCreatorNotes
        ? Container()
        : Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: height * 0.03),
                child: Container(
                  height: 1,
                  color: textLightGrey,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: height * 0.03,
                    margin: EdgeInsets.only(top: height * 0.01),
                    child: FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Text(
                        "Recado de ${widget.viewModel.match.matchCreator.firstName}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  widget.viewModel.controllerHasChanged
                      ? SFButton(
                          textPadding: EdgeInsets.all(width * 0.02),
                          buttonLabel: "Salvar",
                          buttonType: ButtonType.Primary,
                          onTap: () =>
                              widget.viewModel.saveCreatorNotes(context),
                        )
                      : Container(),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: height * 0.01),
                child: widget.viewModel.isUserMatchCreator == true &&
                        widget.viewModel.matchExpired == false
                    ? Form(
                        key: widget.viewModel.creatorNotesFormKey,
                        child: SFTextField(
                            onChanged: (value) =>
                                widget.viewModel.onCreatorNotesChanged(value),
                            hintText:
                                "Escreva algo para a quadra e para os outros jogadores!",
                            minLines: 5,
                            labelText: "",
                            pourpose: TextFieldPourpose.Multiline,
                            maxLines: 5,
                            controller: widget.viewModel.creatorNotesController,
                            validator: (a) => max255(a, "máx 255")),
                      )
                    : SizedBox(
                        child: Text(widget.viewModel.match.creatorNotes),
                        width: double.infinity),
              ),
            ],
          );
  }
}
