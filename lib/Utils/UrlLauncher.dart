import 'package:url_launcher/url_launcher.dart';

void UrlLauncher(Uri url) async {
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  }
}
