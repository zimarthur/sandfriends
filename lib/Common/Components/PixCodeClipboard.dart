import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';

class PixCodeClipboard extends StatefulWidget {
  final String pixCode;
  bool hasCopiedPixToClipboard;
  final VoidCallback onCopied;
  final Color mainColor;
  PixCodeClipboard({
    required this.pixCode,
    required this.hasCopiedPixToClipboard,
    required this.onCopied,
    required this.mainColor,
    super.key,
  });

  @override
  State<PixCodeClipboard> createState() => _PixCodeClipboardState();
}

class _PixCodeClipboardState extends State<PixCodeClipboard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Clipboard.setData(
          ClipboardData(
            text: widget.pixCode,
          ),
        );
        widget.onCopied();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(
              defaultBorderRadius,
            ),
          ),
          color: widget.hasCopiedPixToClipboard ? green : widget.mainColor,
        ),
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(
                  defaultPadding / 2,
                ),
                margin: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                      defaultBorderRadius,
                    ),
                    bottomLeft: Radius.circular(
                      defaultBorderRadius,
                    ),
                  ),
                  color: textWhite,
                ),
                child: Center(
                  child: Text(
                    widget.pixCode,
                    style: const TextStyle(
                        color: textDarkGrey, overflow: TextOverflow.ellipsis),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                vertical: defaultPadding / 3,
              ),
              width: 50,
              child: SvgPicture.asset(
                widget.hasCopiedPixToClipboard
                    ? r"assets/icon/confirm.svg"
                    : r"assets/icon/copy_to_clipboard.svg",
                color: textWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
