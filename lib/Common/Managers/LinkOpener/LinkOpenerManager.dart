import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Managers/LinkOpener/LinkOpenerWeb.dart'
    if (dart.library.io) 'package:sandfriends/Common/Managers/LinkOpener/LinkOpenerMobile.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';

class LinkOpenerManager {
  final linkOpener = LinkOpener();

  void openLink(BuildContext context, String link) {
    linkOpener.openLink(context, link);
  }

  void openInstagram(BuildContext context, String instagram) {
    openLink(context, 'https://www.instagram.com/$instagram');
  }

  void openSandfriendsInstagram(BuildContext context) {
    openInstagram(context, instagramSandfriends);
  }

  void openWhatsApp(BuildContext context, String whatsapp) {
    openLink(context, "whatsapp://send?phone=$whatsapp");
  }

  void openSandfriendsWhatsApp(BuildContext context) {
    openWhatsApp(context, whatsAppNumber);
  }
}
