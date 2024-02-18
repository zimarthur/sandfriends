import 'package:flutter/material.dart';
import '../../../../../Common/Components/SFButton.dart';
import '../../../../../Common/Components/SFDivider.dart';
import '../../../../../../Common/Components/SFTextField.dart';
import '../../../../../Common/Utils/Constants.dart';
import '../../ViewModel/MyCourtsViewModel.dart';

class CourtInfo extends StatefulWidget {
  MyCourtsViewModel viewModel;
  CourtInfo({
    super.key,
    required this.viewModel,
  });

  @override
  State<CourtInfo> createState() => _CourtInfoState();
}

class _CourtInfoState extends State<CourtInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: secondaryBack,
          border: Border.all(
            color: divider,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(defaultBorderRadius)),
      padding: const EdgeInsets.all(
        defaultPadding,
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: defaultPadding / 4,
            ),
            child: Text(
              "Informações",
              style: TextStyle(
                color: primaryBlue,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: defaultPadding,
            ),
            child: SFDivider(),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "Nome desta quadra",
                              style: TextStyle(
                                color: textDarkGrey,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: SFTextField(
                              labelText: "",
                              pourpose: TextFieldPourpose.Standard,
                              controller: widget.viewModel.nameController,
                              validator: (value) {
                                return null;
                              },
                              hintText: "Ex: Quadra 1",
                              onChanged: (newText) =>
                                  widget.viewModel.onChangedCourtName(newText),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 2 * defaultPadding,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "Tipo",
                              style: TextStyle(
                                color: textDarkGrey,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Radio(
                                      value: true,
                                      activeColor: primaryBlue,
                                      groupValue: widget
                                          .viewModel.currentCourt.isIndoor,
                                      onChanged: (isIndoor) => widget.viewModel
                                          .onChangedIsIndoor(isIndoor),
                                    ),
                                    const SizedBox(
                                      width: defaultPadding,
                                    ),
                                    const Text(
                                      "Coberta",
                                      style: TextStyle(
                                        color: textDarkGrey,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Radio(
                                      value: false,
                                      activeColor: primaryBlue,
                                      groupValue: widget
                                          .viewModel.currentCourt.isIndoor,
                                      onChanged: (isIndoor) => widget.viewModel
                                          .onChangedIsIndoor(isIndoor),
                                    ),
                                    const SizedBox(
                                      width: defaultPadding,
                                    ),
                                    const Text(
                                      "Descoberta",
                                      style: TextStyle(
                                        color: textDarkGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 2 * defaultPadding,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "Esportes:",
                              style: TextStyle(
                                color: textDarkGrey,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: defaultPadding / 2,
                                vertical: defaultBorderRadius / 4,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  defaultBorderRadius,
                                ),
                                border: Border.all(
                                  color: divider,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                children: [
                                  for (var sport
                                      in widget.viewModel.currentCourt.sports)
                                    Row(
                                      children: [
                                        Checkbox(
                                            value: sport.isAvailable,
                                            activeColor: primaryBlue,
                                            onChanged: (newValue) =>
                                                widget.viewModel.onChangedSport(
                                                    sport, newValue)),
                                        const SizedBox(
                                          width: defaultPadding,
                                        ),
                                        Text(
                                          sport.sport.description,
                                          style: const TextStyle(
                                            color: textDarkGrey,
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          widget.viewModel.selectedCourtIndex == -1
              ? SFButton(
                  buttonLabel: "Adicionar quadra",
                  onTap: () {
                    widget.viewModel.addCourt(context);
                  },
                )
              : SFButton(
                  buttonLabel: "Excluir quadra",
                  color: red,
                  onTap: () {
                    widget.viewModel.deleteCourt(context);
                  },
                )
        ],
      ),
    );
  }
}
