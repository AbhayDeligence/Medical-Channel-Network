import 'package:flutter/material.dart';
import 'package:news_app/widgets/StorePartners.dart';
import 'package:news_app/widgets/storeEvents.dart';
import 'package:news_app/widgets/storeStore.dart';

class StorePage extends StatefulWidget {
  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: SafeArea(
                child: TabBar(
                  indicatorColor: Colors.deepPurple,
                  labelColor: Colors.deepPurple[600],
                  tabs: [
                    Tab(
                      text: 'Partners',
                    ),
                    Tab(
                      text: 'Events',
                    ),
                    Tab(
                      text: 'Store',
                    ),
                  ],
                ),
              ),
            ),
            body: TabBarView(
              children: [
                StorePartners(),
                StoreEvents(),
                StoreStore(),
              ],
            )),
      ),
    );
  }
}
