import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CourtContactItem extends StatefulWidget {
  String title;
  String iconPath;
  VoidCallback onTap;
  Color themeColor;

  CourtContactItem({
    Key? key,
    required this.title,
    required this.iconPath,
    required this.onTap,
    required this.themeColor,
  }) : super(key: key);

  @override
  State<CourtContactItem> createState() => _CourtContactItemState();
}

class _CourtContactItemState extends State<CourtContactItem> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () => widget.onTap(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.02),
        child: Container(
          width: double.infinity,
          height: height * 0.06,
          decoration: BoxDecoration(
            color: widget.themeColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
            border:
                Border.all(color: widget.themeColor.withOpacity(0.4), width: 1),
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                child: SvgPicture.asset(
                  widget.iconPath,
                  height: height * 0.03,
                  width: height * 0.03,
                  color: widget.themeColor,
                ),
              ),
              SizedBox(
                height: height * 0.025,
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      color: widget.themeColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
