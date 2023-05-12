import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../SharedComponents/View/SFLoading.dart';
import '../../../Utils/Constants.dart';

class CourtPhotos extends StatefulWidget {
  int selectedPhotoIndex;
  Function(int) onSelectedPhotoChanged;
  List<String> imagesUrl;

  CourtPhotos({
    required this.selectedPhotoIndex,
    required this.onSelectedPhotoChanged,
    required this.imagesUrl,
  });

  @override
  State<CourtPhotos> createState() => _CourtPhotosState();
}

class _CourtPhotosState extends State<CourtPhotos> {
  final ScrollController photosScrollController = ScrollController();

  void _onScrollEvent() {
    if (photosScrollController.position.pixels.toInt() %
            (MediaQuery.of(context).size.width).toInt() ==
        0) {
      widget.onSelectedPhotoChanged((photosScrollController.position.pixels ~/
              (MediaQuery.of(context).size.width))
          .round());
    }
  }

  @override
  void initState() {
    photosScrollController.addListener(_onScrollEvent);
    super.initState();
  }

  @override
  void dispose() {
    photosScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        ListView.builder(
          controller: photosScrollController,
          scrollDirection: Axis.horizontal,
          physics: const PageScrollPhysics(),
          itemCount: widget.imagesUrl.length,
          itemBuilder: ((context, index) {
            return SizedBox(
              width: width,
              child: CachedNetworkImage(
                imageUrl: widget.imagesUrl[index],
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: width * 0.1,
                  child: Center(
                    child: SFLoading(),
                  ),
                ),
                errorWidget: (context, url, error) => Center(
                  child: Icon(Icons.dangerous),
                ),
              ),
            );
          }),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: height * 0.06),
          child: SizedBox(
            height: width * 0.02,
            width: width * 0.04 * widget.imagesUrl.length,
            child: ListView.builder(
              itemCount: widget.imagesUrl.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: ((context, index) {
                bool isIndex = widget.selectedPhotoIndex == index;
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.01,
                  ),
                  child: ClipOval(
                    child: Container(
                      color: isIndex ? primaryBlue : secondaryBack,
                      height: width * 0.02,
                      width: width * 0.02,
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
