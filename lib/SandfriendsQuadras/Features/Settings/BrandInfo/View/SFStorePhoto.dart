import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sandfriends_web/SharedComponents/Model/StorePhoto.dart';
import 'package:sandfriends_web/Utils/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../../../Common/Components/SFLoading.dart';
import '../../../../SharedComponents/ViewModel/EnvironmentProvider.dart';

class StorePhotoCard extends StatefulWidget {
  StorePhoto storePhoto;
  VoidCallback delete;
  bool isAdmin;

  StorePhotoCard({
    super.key,
    required this.storePhoto,
    required this.delete,
    required this.isAdmin,
  });

  @override
  State<StorePhotoCard> createState() => _StorePhotoCardState();
}

class _StorePhotoCardState extends State<StorePhotoCard> {
  double deleteButtonSize = 40.0;
  double imageHeight = 210;
  double imageWidth = 300;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (layoutContext, layoutConstraints) {
        return Container(
          height: layoutConstraints.maxHeight,
          width: imageWidth + (deleteButtonSize / 2),
          margin: EdgeInsets.only(right: defaultPadding * 2),
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(defaultBorderRadius),
                child: widget.storePhoto.isNewPhoto
                    ? Image.memory(
                        widget.storePhoto.newPhoto!,
                        width: imageWidth,
                        height: imageHeight,
                      )
                    : CachedNetworkImage(
                        imageUrl: Provider.of<EnvironmentProvider>(context,
                                listen: false)
                            .urlBuilder(
                          widget.storePhoto.photo,
                          isImage: true,
                        ),
                        width: imageWidth,
                        height: imageHeight,
                        placeholder: (context, url) => Center(
                          child: SFLoading(
                            size: 50,
                          ),
                        ),
                        errorWidget: (context, url, error) => Center(
                          child: Icon(Icons.error),
                        ),
                      ),
              ),
              if (widget.isAdmin)
                Positioned(
                  top: 0,
                  right: 0,
                  child: InkWell(
                    onTap: widget.delete,
                    child: Container(
                      height: deleteButtonSize,
                      width: deleteButtonSize,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryBlue,
                      ),
                      padding: const EdgeInsets.all(10),
                      child: SvgPicture.asset(
                        r'assets/icon/x.svg',
                        color: secondaryPaper,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
