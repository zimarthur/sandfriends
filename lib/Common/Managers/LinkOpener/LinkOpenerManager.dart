import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Managers/LinkOpener/LinkOpenerWeb.dart'
    if (dart.library.io) 'package:sandfriends/Common/Managers/LinkOpener/LinkOpenerMobile.dart';

class LinkOpenerManager {
  final linkOpener = LinkOpener();

  void openLink(BuildContext context, String link) {
    linkOpener.openLink(context, link);
  }
}
