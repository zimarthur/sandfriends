import 'package:flutter/material.dart';

abstract class GenericLinkOpener {
  Function(BuildContext, String) get openLink;
}
