import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/Features/MatchSearchFilter/Model/CustomFilter.dart';
import 'package:sandfriends/Utils/Constants.dart';

class OrderByItemWidget extends StatefulWidget {
  OrderBy orderBy;
  OrderBy currentOrderBy;
  String icon;
  Function(OrderBy) onNewOrderBy;
  OrderByItemWidget(
      {required this.orderBy,
      required this.currentOrderBy,
      required this.icon,
      required this.onNewOrderBy,
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
                  color: isSelected ? primaryBlue.withAlpha(64) : null,
                  border: !isSelected ? Border.all(color: textDarkGrey) : null),
              child: Center(
                child: SvgPicture.asset(
                  widget.icon,
                  color: isSelected ? primaryBlue : textDarkGrey,
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
              color: isSelected ? textBlue : textDarkGrey,
            ),
          )
        ],
      ),
    );
  }
}
