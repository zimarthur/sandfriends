import 'package:flutter/material.dart';
import 'package:sandfriends/oldApp/theme/app_theme.dart';

class SFModal extends StatefulWidget {
  final Widget child;
  final VoidCallback onTapBackground;

  const SFModal({
    required this.child,
    required this.onTapBackground,
  });

  @override
  State<SFModal> createState() => _SFModalState();
}

class _SFModalState extends State<SFModal> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: [
          InkWell(
            onTap: widget.onTapBackground,
            child: Container(
              width: width,
              height: height,
              color: AppTheme.colors.primaryBlue.withOpacity(0.4),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.colors.secondaryPaper,
              borderRadius: BorderRadius.circular(16),
              border:
                  Border.all(color: AppTheme.colors.primaryDarkBlue, width: 1),
              boxShadow: [
                BoxShadow(blurRadius: 1, color: AppTheme.colors.primaryDarkBlue)
              ],
            ),
            width: width * 0.9,
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
