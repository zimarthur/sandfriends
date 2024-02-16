import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/Sandfriends/Features/MatchSearchFilter/Model/CustomFilter.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';

class OrderByItemWidget extends StatefulWidget {
  OrderBy orderBy;
  OrderBy currentOrderBy;
  String icon;
  Function(OrderBy) onNewOrderBy;
  Color primaryColor;
  OrderByItemWidget(
      {required this.orderBy,
      required this.currentOrderBy,
      required this.icon,
      required this.onNewOrderBy,
      required this.primaryColor,
      super.key});

  @override
  State<OrderByItemWidget> createState() => _OrderByItemWidgetState();
}

class _OrderByItemWidgetState extends State<OrderByItemWidget> {
  @override
  Widget build(BuildContext context) {
    bool isSelected = widget.currentOrderBy == widget.orderBy;
    return InkWell(
      onTap: () => widget.onNewOrderBy(widget.orderBy),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? widget.primaryColor.withAlpha(64) : null,
                  border: !isSelected ? Border.all(color: textDarkGrey) : null),
              child: Center(
                child: SvgPicture.asset(
                  widget.icon,
                  color: isSelected ? widget.primaryColor : textDarkGrey,
                ),
              ),
            ),
          ),
          SizedBox(
            height: defaultPadding / 2,
          ),
          Text(
            widget.orderBy == OrderBy.distance ? "Distância" : "Preço",
            style: TextStyle(
              color: isSelected ? widget.primaryColor : textDarkGrey,
            ),
          )
        ],
      ),
    );
  }
}
