import 'package:flutter/src/widgets/framework.dart';
import 'package:sandfriends/Common/Managers/LinkOpener/GenericLinkOpener.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkOpener extends GenericLinkOpener {
  @override
  Function(BuildContext context, String link) get openLink =>
      (context, link) => launchUrl(Uri.parse(link));
}
