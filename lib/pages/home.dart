import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_app/blocs/notification_bloc.dart';
import 'package:news_app/pages/explore.dart';
import 'package:news_app/pages/profile.dart';
import 'package:news_app/pages/videos.dart';
import 'package:provider/provider.dart';

import 'events.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  PageController _pageController = PageController();

  // List<IconData> iconList = [
  //   Feather.home,
  //   Feather.youtube,
  //   Feather.grid,
  //   Feather.user,
  //   Icons.shopping_bag_outlined
  // ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(index,
        curve: Curves.easeIn, duration: Duration(milliseconds: 250));
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0)).then((value) async {
      await context
          .read<NotificationBloc>()
          .initFirebasePushNotification(context)
          .then((value) =>
              context.read<NotificationBloc>().handleNotificationlength());
      // .then((value) => adb.checkAdsEnable())
      // .then((value)async{
      //   if(adb.interstitialAdEnabled == true || adb.bannerAdEnabled == true){
      //     adb.initiateAds();
      //   }
      // });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future _onWillPop() async {
    if (_currentIndex != 0) {
      setState(() => _currentIndex = 0);
      _pageController.animateToPage(0,
          duration: Duration(milliseconds: 200), curve: Curves.easeIn);
    } else {
      await SystemChannels.platform
          .invokeMethod<void>('SystemNavigator.pop', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await _onWillPop(),
      child: Scaffold(
        bottomNavigationBar: _bottomNavigationBar(),
        body: PageView(
          controller: _pageController,
          allowImplicitScrolling: false,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Explore(),
            VideoArticles(),
            Engage(),
            StorePage(),
          ],
        ),
      ),
    );
  }

  BottomNavigationBar _bottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: (index) => onTabTapped(index),
      currentIndex: _currentIndex,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      iconSize: 25,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/images/1.png'),
              size: 25,
            ),
            label: 'Home'),
        BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/images/2.png'),
              size: 25,
            ),
            label: 'Lectures'),
        BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/images/4.png'),
              size: 25,
            ),
            label: 'Engage'),
        BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/images/3.png'),
              size: 25,
            ),
            label: 'Store'),
      ],
    );
  }
}
