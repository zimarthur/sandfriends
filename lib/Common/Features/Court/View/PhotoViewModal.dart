import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Components/SFLoading.dart';
import 'package:sandfriends/Common/Providers/Environment/EnvironmentProvider.dart';
import '../../../Utils/Constants.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoViewModal extends StatefulWidget {
  List<String> imagesUrl;
  VoidCallback onClose;
  PhotoViewModal({
    required this.imagesUrl,
    required this.onClose,
    super.key,
  });

  @override
  State<PhotoViewModal> createState() => _PhotoViewModalState();
}

class _PhotoViewModalState extends State<PhotoViewModal> {
  int currentPhoto = 1;
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryDarkBlue, width: 1),
        boxShadow: const [BoxShadow(blurRadius: 1, color: primaryDarkBlue)],
      ),
      width: width > 600 ? 600 : width * 0.9,
      height: height > 400 ? 400 : height * 0.6,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              Text(
                "$currentPhoto/${widget.imagesUrl.length}",
                style: TextStyle(
                  color: primaryBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: () => widget.onClose(),
                child: SvgPicture.asset(
                  r"assets/icon/x.svg",
                  color: textDarkGrey,
                  height: 20,
                ),
              ),
            ],
          ),
          Expanded(
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      if (currentPhoto == 1) {
                        pageController.jumpToPage(widget.imagesUrl.length);
                        currentPhoto = widget.imagesUrl.length;
                      } else {
                        pageController.previousPage(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                        );
                        currentPhoto--;
                      }
                    });
                  },
                  child: SvgPicture.asset(
                    r"assets/icon/arrow_left_triangle.svg",
                    height: 30,
                  ),
                ),
                SizedBox(
                  width: defaultPadding / 2,
                ),
                Expanded(
                  child: PhotoViewGallery.builder(
                    scrollPhysics: const BouncingScrollPhysics(),
                    builder: (BuildContext context, int index) {
                      return PhotoViewGalleryPageOptions(
                        imageProvider: CachedNetworkImageProvider(
                          Provider.of<EnvironmentProvider>(context,
                                  listen: false)
                              .urlBuilder(
                            widget.imagesUrl[index],
                            isImage: true,
                          ),
                        ),
                        initialScale: PhotoViewComputedScale.contained * 0.8,
                      );
                    },
                    itemCount: widget.imagesUrl.length,
                    loadingBuilder: (context, event) =>
                        Center(child: SFLoading()),
                    backgroundDecoration: BoxDecoration(color: secondaryPaper),
                    pageController: pageController,
                  ),
                ),
                SizedBox(
                  width: defaultPadding / 2,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      if (currentPhoto == widget.imagesUrl.length) {
                        pageController.jumpToPage(0);
                        currentPhoto = 1;
                      } else {
                        pageController.nextPage(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                        );
                        currentPhoto++;
                      }
                    });
                  },
                  child: SvgPicture.asset(
                    r"assets/icon/arrow_right_triangle.svg",
                    height: 30,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
