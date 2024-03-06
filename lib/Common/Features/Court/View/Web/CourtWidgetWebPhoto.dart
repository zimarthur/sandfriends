import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Components/SFLoading.dart';
import '../../../../Providers/Environment/EnvironmentProvider.dart';
import '../../../../Utils/Constants.dart';
import '../../ViewModel/CourtViewModel.dart';

class CourtWidgetWebPhoto extends StatefulWidget {
  const CourtWidgetWebPhoto({super.key});

  @override
  State<CourtWidgetWebPhoto> createState() => _CourtWidgetWebPhotoState();
}

class _CourtWidgetWebPhotoState extends State<CourtWidgetWebPhoto> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CourtViewModel>(context);
    return SizedBox(
      height: 300,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: LayoutBuilder(builder: (layoutContext, layoutConstraints) {
              return ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(defaultBorderRadius),
                  topLeft: Radius.circular(defaultBorderRadius),
                ),
                child: SizedBox(
                  width: layoutConstraints.maxWidth,
                  child: CachedNetworkImage(
                    width: layoutConstraints.maxWidth,
                    imageUrl:
                        Provider.of<EnvironmentProvider>(context, listen: false)
                            .urlBuilder(viewModel.store!.photos.first,
                                isImage: true),
                    fit: BoxFit.fitWidth,
                    placeholder: (context, url) => SizedBox(
                      child: Center(
                        child: SFLoading(),
                      ),
                    ),
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(Icons.dangerous),
                    ),
                  ),
                ),
              );
            }),
          ),
          SizedBox(
            width: defaultPadding / 2,
          ),
          Expanded(child: LayoutBuilder(
              builder: (secondColumnContext, secondColumConstraints) {
            return Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(defaultBorderRadius),
                    ),
                    child: CachedNetworkImage(
                      width: secondColumConstraints.maxWidth,
                      imageUrl: Provider.of<EnvironmentProvider>(context,
                              listen: false)
                          .urlBuilder(viewModel.store!.photos[1],
                              isImage: true),
                      fit: BoxFit.fitWidth,
                      placeholder: (context, url) => SizedBox(
                        child: Center(
                          child: SFLoading(),
                        ),
                      ),
                      errorWidget: (context, url, error) => const Center(
                        child: Icon(Icons.dangerous),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: defaultPadding / 2,
                ),
                Expanded(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(defaultBorderRadius),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: Provider.of<EnvironmentProvider>(context,
                                  listen: false)
                              .urlBuilder(viewModel.store!.photos[2],
                                  isImage: true),
                          fit: BoxFit.fitWidth,
                          width: secondColumConstraints.maxWidth,
                          placeholder: (context, url) => SizedBox(
                            child: Center(
                              child: SFLoading(),
                            ),
                          ),
                          errorWidget: (context, url, error) => const Center(
                            child: Icon(Icons.dangerous),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: InkWell(
                          onTap: () => viewModel.setCourtPhotoModal(),
                          child: Container(
                            decoration: BoxDecoration(
                              color: secondaryPaper,
                              borderRadius: BorderRadius.circular(
                                defaultBorderRadius,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 3,
                                  offset: Offset(0, 0),
                                  color: textDarkGrey,
                                )
                              ],
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: defaultPadding / 4,
                              horizontal: defaultPadding / 2,
                            ),
                            child: Center(
                                child: Text(
                              "Todas as fotos",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            )),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          }))
        ],
      ),
    );
  }
}
