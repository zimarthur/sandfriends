import 'package:flutter/material.dart';
import '../../../../../../Common/Components/SFTextField.dart';
import '../../../../../Common/Utils/Constants.dart';

class PlayersResume extends StatefulWidget {
  VoidCallback collapse;
  VoidCallback expand;
  bool isExpanded;
  Function(String) onUpdatePlayerFilter;
  String playersQuantity;
  TextEditingController playerController;
  PlayersResume(
      {required this.collapse,
      required this.expand,
      required this.isExpanded,
      required this.onUpdatePlayerFilter,
      required this.playersQuantity,
      required this.playerController,
      super.key});

  @override
  State<PlayersResume> createState() => _PlayersResumeState();
}

class _PlayersResumeState extends State<PlayersResume> {
  @override
  void initState() {
    widget.playerController.addListener(() {
      widget.onUpdatePlayerFilter(widget.playerController.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.playerController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (drag) {
        if (drag.delta.dy < -5.0) {
          widget.collapse();
        } else if (drag.delta.dy > 5.0) {
          widget.expand();
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: double.infinity,
        height: widget.isExpanded ? 170 : 120,
        decoration: BoxDecoration(
          color: primaryBlue,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(
              defaultBorderRadius,
            ),
            bottomRight: Radius.circular(
              defaultBorderRadius,
            ),
          ),
        ),
        child: Column(
          children: [
            Expanded(
                child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedSize(
                      duration: Duration(milliseconds: 200),
                      child: widget.isExpanded
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(bottom: defaultPadding),
                              child: SFTextField(
                                labelText: "Pesquisar jogador",
                                pourpose: TextFieldPourpose.Standard,
                                controller: widget.playerController,
                                validator: (a) {},
                              ),
                            )
                          : Container()),
                  Flexible(
                    child: Text(
                      "Jogadores ativos",
                      style: TextStyle(
                        color: textWhite,
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Text(
                    widget.playersQuantity,
                    style: TextStyle(
                      color: textWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                ],
              ),
            )),
            Container(
              width: 50,
              height: 4,
              margin: EdgeInsets.symmetric(vertical: defaultPadding / 2),
              decoration: BoxDecoration(
                  color: secondaryPaper,
                  borderRadius: BorderRadius.circular(defaultPadding)),
            ),
          ],
        ),
      ),
    );
  }
}
