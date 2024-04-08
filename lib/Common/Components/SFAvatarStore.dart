import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Components/SFAvatarUser.dart';
import 'package:sandfriends/Common/Model/User/UserStore.dart';
import 'package:sandfriends/Sandfriends/Features/Home/View/User/UserCardHome.dart';

import '../Providers/Environment/EnvironmentProvider.dart';
import '../Utils/Constants.dart';
import 'SFLoading.dart';

class SFAvatarStore extends StatefulWidget {
  final double height;
  UserStore? user;
  final Uint8List? editImage;
  final bool isPlayerAvatar;
  final String? storeName;
  final String? storePhoto;
  bool enableShadow;

  SFAvatarStore({
    super.key,
    required this.height,
    this.editImage,
    this.user,
    this.isPlayerAvatar = false,
    this.enableShadow = false,
    this.storeName,
    this.storePhoto,
  });

  @override
  State<SFAvatarStore> createState() => _SFAvatarStoreState();
}

class _SFAvatarStoreState extends State<SFAvatarStore> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(widget.enableShadow ? 6 : 0),
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(
            widget.isPlayerAvatar ? widget.height * 0.5 : defaultBorderRadius),
        boxShadow: widget.enableShadow
            ? [
                BoxShadow(
                  color: divider,
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 0),
                ),
              ]
            : null,
      ),
      height: widget.height,
      width: widget.height,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.isPlayerAvatar
                ? widget.height * 0.45
                : defaultBorderRadius),
            color: primaryBlue,
          ),
          height: widget.height * 0.95,
          width: widget.height * 0.95,
          child: AspectRatio(
            aspectRatio: 1 / 1,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(widget.isPlayerAvatar
                    ? widget.height * 0.45
                    : defaultBorderRadius),
                child: widget.editImage != null
                    ? Image.memory(
                        widget.editImage!,
                        fit: BoxFit.cover,
                      )
                    : widget.storePhoto != null
                        ? CachedNetworkImage(
                            imageUrl: Provider.of<EnvironmentProvider>(context,
                                    listen: false)
                                .urlBuilder(
                              widget.storePhoto!,
                              isImage: true,
                            ),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Padding(
                              padding: EdgeInsets.all(widget.height * 0.3),
                              child: SFLoading(
                                size: widget.height * 0.4,
                              ),
                            ),
                            errorWidget: (context, url, error) {
                              print("ERRO ${error}");
                              return widget.isPlayerAvatar
                                  ? Center(
                                      child: SizedBox(
                                        height: widget.height * 0.4,
                                        width: widget.height * 0.4,
                                        child: FittedBox(
                                          fit: BoxFit.fitHeight,
                                          child: Text(
                                            "${widget.user!.firstName![0].toUpperCase()}${widget.user!.lastName![0].toUpperCase()}",
                                            style: TextStyle(
                                              color: secondaryPaper,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Center(
                                      child: SizedBox(
                                        height: widget.height * 0.4,
                                        width: widget.height * 0.4,
                                        child: FittedBox(
                                          fit: BoxFit.fitHeight,
                                          child: Text(
                                            widget.storeName![0].toUpperCase(),
                                            style: TextStyle(
                                              color: secondaryPaper,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                            },
                          )
                        : widget.user != null
                            ? widget.user!.photo != null
                                ? CachedNetworkImage(
                                    imageUrl: Provider.of<EnvironmentProvider>(
                                            context,
                                            listen: false)
                                        .urlBuilder(
                                      widget.user!.photo!,
                                      isImage: true,
                                    ),
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Padding(
                                      padding:
                                          EdgeInsets.all(widget.height * 0.3),
                                      child: SFLoading(
                                        size: widget.height * 0.4,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) {
                                      return Container(
                                        color: textLightGrey.withOpacity(0.5),
                                        height: widget.height * 0.4,
                                        width: widget.height * 0.4,
                                        child: const Center(
                                          child: Icon(
                                            Icons.dangerous,
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Center(
                                    child: SizedBox(
                                      height: widget.height * 0.4,
                                      width: widget.height * 0.4,
                                      child: FittedBox(
                                        fit: BoxFit.fitHeight,
                                        child: Text(
                                          "${widget.user!.firstName![0].toUpperCase()}${widget.user!.lastName![0].toUpperCase()}",
                                          style: TextStyle(
                                            color: secondaryPaper,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                            : Center(
                                child: SizedBox(
                                  height: widget.height * 0.4,
                                  width: widget.height * 0.4,
                                  child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      widget.storeName![0].toUpperCase(),
                                      style: TextStyle(
                                        color: secondaryPaper,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              )),
          ),
        ),
      ),
    );
  }
}
