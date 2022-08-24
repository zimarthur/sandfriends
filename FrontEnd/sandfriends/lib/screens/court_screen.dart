import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/models/enums.dart';
import 'package:sandfriends/theme/app_theme.dart';
import 'package:sandfriends/widgets/SF_Scaffold.dart';
import 'package:photo_view/photo_view.dart';

import '../providers/match_provider.dart';

class CourtScreen extends StatefulWidget {
  const CourtScreen({Key? key}) : super(key: key);

  @override
  State<CourtScreen> createState() => _CourtScreenState();
}

class _CourtScreenState extends State<CourtScreen> {
  bool showModal = false;

  final imageList = [
    'assets/its/1.jpg',
    'assets/its/2.jpg',
    'assets/its/3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider(
      create: ((ctx) => MatchProvider()),
      child: SFScaffold(
        titleText: "Quadra",
        goNamed: 'match_search_screen',
        appBarType: AppBarType.Primary,
        showModal: showModal,
        child: Container(
          width: width,
          color: AppTheme.colors.secondaryPaper,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            child: ListView(
              children: [
                Container(
                  height: height * 0.25,
                  width: width * 0.9,
                  child: PhotoViewGallery.builder(
                    itemCount: imageList.length,
                    builder: (context, index) {
                      return PhotoViewGalleryPageOptions(
                        imageProvider: AssetImage(
                          imageList[index],
                        ),
                        minScale: PhotoViewComputedScale.contained * 0.8,
                        maxScale: PhotoViewComputedScale.covered * 2,
                      );
                    },
                    scrollPhysics: BouncingScrollPhysics(),
                    backgroundDecoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Theme.of(context).canvasColor,
                    ),
                    enableRotation: true,
                  ),
                ),
                Text(Provider.of<MatchProvider>(context, listen: false)
                    .selectedCourt!
                    .name),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
