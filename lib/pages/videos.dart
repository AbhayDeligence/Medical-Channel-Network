import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:line_icons/line_icons.dart';
import 'package:news_app/blocs/notification_bloc.dart';
import 'package:news_app/blocs/videos_bloc.dart';
import 'package:news_app/cards/card4.dart';
import 'package:news_app/cards/card5.dart';
import 'package:news_app/pages/search.dart';
import 'package:news_app/utils/app_name.dart';
import 'package:news_app/utils/empty.dart';
import 'package:news_app/utils/loading_cards.dart';
import 'package:news_app/utils/next_screen.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'notifications.dart';

class VideoArticles extends StatefulWidget {
  VideoArticles({Key? key}) : super(key: key);

  @override
  _VideoArticlesState createState() => _VideoArticlesState();
}

class _VideoArticlesState extends State<VideoArticles>
    with AutomaticKeepAliveClientMixin {
  ScrollController? controller;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _orderBy = 'timestamp';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0)).then((value) {
      controller = new ScrollController()..addListener(_scrollListener);
      context.read<VideosBloc>().getData(mounted, _orderBy);
    });
  }

  @override
  void dispose() {
    controller!.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    final db = context.read<VideosBloc>();

    if (!db.isLoading) {
      if (controller!.position.pixels == controller!.position.maxScrollExtent) {
        context.read<VideosBloc>().setLoading(true);
        context.read<VideosBloc>().getData(mounted, _orderBy);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final vb = context.watch<VideosBloc>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: AppName(fontSize: 17.0),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              AntDesign.search1,
              size: 22,
            ),
            onPressed: () async {
              nextScreen(
                  context,
                  SearchPage(
                    tag: 'lecture',
                  ));
            },
          ),
          Badge(
            position: BadgePosition.topEnd(top: 14, end: 15),
            badgeColor: Colors.redAccent,
            animationType: BadgeAnimationType.fade,
            showBadge: context.watch<NotificationBloc>().savedNlength <
                    context.watch<NotificationBloc>().notificationLength
                ? true
                : false,
            badgeContent: Container(),
            child: IconButton(
              icon: const Icon(
                LineIcons.bell,
                size: 25,
              ),
              onPressed: () {
                context.read<NotificationBloc>().saveNlengthToSP();
                nextScreen(context, NotificationsPage());
              },
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        child: vb.hasData == false
            ? ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                  ),
                  EmptyPage(
                      icon: Feather.clipboard,
                      message: 'no articles found'.tr(),
                      message1: ''),
                ],
              )
            : ListView.separated(
                padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                controller: controller,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: vb.data.length != 0 ? vb.data.length + 1 : 5,
                separatorBuilder: (BuildContext context, int index) => SizedBox(
                  height: 15,
                ),
                itemBuilder: (_, int index) {
                  if (index < vb.data.length) {
                    if (index.isOdd)
                      return Card4(d: vb.data[index], heroTag: 'video$index');
                    else
                      return Card5(
                        d: vb.data[index],
                        heroTag: 'video$index',
                      );
                  }
                  return Opacity(
                    opacity: vb.isLoading ? 1.0 : 0.0,
                    child: vb.lastVisible == null
                        ? const LoadingCard(height: 250)
                        : Center(
                            child: SizedBox(
                                width: 32.0,
                                height: 32.0,
                                child: new CupertinoActivityIndicator()),
                          ),
                  );
                },
              ),
        onRefresh: () async {
          context.read<VideosBloc>().onRefresh(mounted, _orderBy);
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
