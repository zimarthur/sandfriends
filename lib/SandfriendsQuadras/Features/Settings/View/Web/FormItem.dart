import 'package:flutter/material.dart';
import 'package:sandfriends_web/Utils/Constants.dart';

import '../../../../SharedComponents/View/SFTextfield.dart';

class FormItem extends StatefulWidget {
  String name;
  TextEditingController controller;
  bool hasSecondItem;
  String? secondName;
  TextEditingController? secondController;
  Widget? customWidget;
  final Function(String)? onChanged;
  final Function(String)? onChangedSecond;
  bool isAdmin;

  FormItem({
    super.key,
    required this.name,
    required this.controller,
    required this.onChanged,
    this.onChangedSecond,
    this.hasSecondItem = false,
    this.secondName,
    this.secondController,
    this.customWidget,
    required this.isAdmin,
  });

  @override
  State<FormItem> createState() => _FormItemState();
}

class _FormItemState extends State<FormItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              widget.name,
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(
            flex: 2,
            child: SFTextField(
              controller: widget.controller,
              labelText: '',
              pourpose: TextFieldPourpose.Standard,
              validator: (String? value) {
                return null;
              },
              enable: widget.isAdmin,
              onChanged: widget.onChanged,
            ),
          ),
          Expanded(
            flex: 3,
            child: widget.hasSecondItem
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 2 * defaultPadding),
                    child: widget.customWidget ??
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                widget.secondName!,
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: SFTextField(
                                controller: widget.secondController!,
                                labelText: '',
                                pourpose: TextFieldPourpose.Standard,
                                validator: (a) {
                                  return null;
                                },
                                onChanged: widget.onChangedSecond,
                                enable: widget.isAdmin,
                              ),
                            ),
                          ],
                        ))
                : Container(),
          ),
        ],
      ),
    );
  }
}
