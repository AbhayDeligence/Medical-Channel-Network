import 'package:flutter/material.dart';

class Config {
  final String appName = 'Medical Channel Network';
  final String splashIcon = 'assets/images/splash.png';
  final String supportEmail = 'jon@jonlindgren.com';
  final String privacyPolicyUrl =
      'https://docs.google.com/document/d/e/2PACX-1vQYeT5GfxOVlJEoObN4-6LitTEvt-ezOVHbwgD7igxU07qff5EUk0E65ItYw6i0eCDG_t2B5lanp-8W/pub';
  final String ourWebsiteUrl = 'http://lindgrenmedia.com';
  final String iOSAppId = '1596502606';

  //social links
  // static const String facebookPageUrl = 'https://www.facebook.com/mrblab24';
  // static const String youtubeChannelUrl = 'https://www.youtube.com/channel/UCnNr2eppWVVo-NpRIy1ra7A';
  // static const String twitterUrl = 'https://twitter.com/FlutterDev';

  //app theme color
  final Color appColor = Colors.deepPurpleAccent;

  //Intro images
  final String introImage1 = 'assets/images/news1.png';
  final String introImage2 = 'assets/images/news6.png';
  final String introImage3 = 'assets/images/news7.png';

  //animation files
  final String doneAsset = 'assets/animation_files/done.json';

  //Language Setup
  final List<String> languages = ['English', 'Spanish', 'Arabic'];

  //initial categories - 4 only (Hard Coded : which are added already on your admin panel)
  final List initialCategories = [
    'Top Stories',
    'Nursing',
    'Medical Practice',
    'Technology'
  ];
}
