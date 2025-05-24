import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static Future openLink({
//    @required String url,
    @required url,
  }) =>
      _launchUrl(Uri.parse(url));
  // _launchUrl(url);

  static Future openEmail({
    required String toEmail,
    required String subject,
    required String body,
  }) async {
    final url =
        'mailto:$toEmail?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(body)}';

    await _launchUrl(url);
  }

  static Future openPhoneCall({required String phoneNumber}) async {
    final url = 'tel:$phoneNumber';

    await _launchUrl(url);
  }

  // static Future openSMS({@required phoneNumber}) async {
  static Future openSMS({required String phoneNumber}) async {
    final url = Uri.parse('sms:$phoneNumber');

    await _launchUrl(url);
  }

  static Future _launchUrl(url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}
