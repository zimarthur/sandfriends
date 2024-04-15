import 'package:flutter/material.dart';
import '../../../../../../Common/Utils/Constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../ViewModel/MenuProviderQuadras.dart';
import 'SFDrawerDivider.dart';
import 'SFDrawerListTile.dart';
import 'SFDrawerUserWidget.dart';

class SFDrawerWeb extends StatefulWidget {
  MenuProviderQuadras viewModel;
  SFDrawerWeb({
    required this.viewModel,
  });

  @override
  State<SFDrawerWeb> createState() => _SFDrawerWebState();
}

class _SFDrawerWebState extends State<SFDrawerWeb> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool fullSize = widget.viewModel.isDrawerExpanded;
    return Container(
      decoration: const BoxDecoration(
        color: primaryBlue,
        border: Border(
          right: BorderSide(
            color: primaryDarkBlue,
            width: 1,
          ),
        ),
      ),
      width: fullSize ? 250 : 82,
      height: height,
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        children: [
          InkWell(
            onTap: () => widget.viewModel.isDrawerExpanded =
                !widget.viewModel.isDrawerExpanded,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              alignment: fullSize ? Alignment.centerRight : Alignment.center,
              child: SvgPicture.asset(
                fullSize
                    ? r'assets/icon/double_arrow_left.svg'
                    : r'assets/icon/double_arrow_right.svg',
                height: 25,
                width: 25,
                color: secondaryPaper,
              ),
            ),
          ),
          SizedBox(
            height: defaultPadding,
          ),
          InkWell(
            onTap: () => widget.viewModel.quickLinkHome(context),
            onHover: (a) {},
            child: Image.asset(
              fullSize
                  ? r'assets/full_logo_negative_284.png'
                  : r'assets/logo_64.png',
            ),
          ),
          const SFDrawerDivider(),
          Expanded(
            child: ListView.builder(
              itemCount: widget.viewModel.mainDrawer.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    widget.viewModel.onTabClick(
                      widget.viewModel.mainDrawer[index].drawerPage,
                      context,
                    );
                  },
                  onHover: (value) {
                    widget.viewModel.setHoveredDrawerTitle(
                        value ? widget.viewModel.mainDrawer[index].title : "");
                  },
                  child: SFDrawerListTile(
                    title: widget.viewModel.mainDrawer[index].title,
                    svgSrc: widget.viewModel.mainDrawer[index].icon,
                    isSelected: widget.viewModel.mainDrawer[index] ==
                        widget.viewModel.selectedDrawerItem,
                    fullSize: fullSize,
                    isHovered: widget.viewModel.hoveredDrawerTitle ==
                        widget.viewModel.mainDrawer[index].title,
                    isNew: widget.viewModel.mainDrawer[index].isNew,
                  ),
                );
              },
            ),
          ),
          const SFDrawerDivider(),
          SFDrawerUserWidget(
            fullSize: fullSize,
            menuProvider: widget.viewModel,
          )
        ],
      ),
    );
  }
}
