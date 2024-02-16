import 'package:flutter/src/widgets/framework.dart';
import 'package:sandfriends/Common/Managers/LinkOpener/GenericLinkOpener.dart';
import 'dart:js' as js;

class LinkOpener extends GenericLinkOpener {
  @override
  Function(BuildContext context, String link) get openLink =>
      (context, link) => js.context.callMethod('open', [link]);
}
