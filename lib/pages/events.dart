// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_icons/flutter_icons.dart';
// import 'package:news_app/blocs/categories_bloc.dart';
// import 'package:news_app/models/category.dart';
// import 'package:news_app/pages/category_based_articles.dart';
// import 'package:news_app/utils/cached_image_with_dark.dart';
// import 'package:news_app/utils/empty.dart';
// import 'package:news_app/utils/loading_cards.dart';
// import 'package:news_app/utils/next_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:easy_localization/easy_localization.dart';

// class Categories extends StatefulWidget {
//   Categories({Key? key}) : super(key: key);

//   @override
//   _CategoriesState createState() => _CategoriesState();
// }

// class _CategoriesState extends State<Categories>
//     with AutomaticKeepAliveClientMixin {
//   final scaffoldKey = GlobalKey<ScaffoldState>();
//   ScrollController? controller;

//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration(milliseconds: 0)).then((value) {
//       controller = new ScrollController()..addListener(_scrollListener);
//       context.read<CategoriesBloc>().getData(mounted);
//     });
//   }

//   @override
//   void dispose() {
//     controller!.removeListener(_scrollListener);
//     super.dispose();
//   }

//   void _scrollListener() {
//     final db = context.read<CategoriesBloc>();

//     if (!db.isLoading) {
//       if (controller!.position.pixels == controller!.position.maxScrollExtent) {
//         context.read<CategoriesBloc>().setLoading(true);
//         context.read<CategoriesBloc>().getData(mounted);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     final cb = context.watch<CategoriesBloc>();

//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: false,
//         automaticallyImplyLeading: false,
//         title: Text('categories').tr(),
//         elevation: 0,
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(
//               Feather.rotate_cw,
//               size: 22,
//             ),
//             onPressed: () {
//               context.read<CategoriesBloc>().onRefresh(mounted);
//             },
//           )
//         ],
//       ),
//       body: RefreshIndicator(
//         child: cb.hasData == false
//             ? ListView(
//                 children: [
//                   SizedBox(
//                     height: MediaQuery.of(context).size.height * 0.35,
//                   ),
//                   EmptyPage(
//                       icon: Feather.clipboard,
//                       message: 'Comming Soon',
//                       message1: ''),
//                 ],
//               )
//             : GridView.builder(
//                 controller: controller,
//                 padding:
//                     EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     mainAxisSpacing: 8,
//                     crossAxisSpacing: 8,
//                     childAspectRatio: 1.1),
//                 itemCount: cb.data.length != 0 ? cb.data.length + 1 : 10,
//                 itemBuilder: (_, int index) {
//                   if (index < cb.data.length) {
//                     return _ItemList(d: cb.data[index]);
//                   }
//                   return Opacity(
//                     opacity: cb.isLoading ? 1.0 : 0.0,
//                     child: cb.lastVisible == null
//                         ? LoadingCard(height: null)
//                         : Center(
//                             child: SizedBox(
//                                 width: 32.0,
//                                 height: 32.0,
//                                 child: new CupertinoActivityIndicator()),
//                           ),
//                   );
//                 },
//               ),
//         onRefresh: () async {
//           context.read<CategoriesBloc>().onRefresh(mounted);
//         },
//       ),
//     );
//   }

//   @override
//   bool get wantKeepAlive => true;
// }

// class _ItemList extends StatelessWidget {
//   final CategoryModel d;
//   const _ItemList({Key? key, required this.d}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       child: Container(
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(5),
//               boxShadow: <BoxShadow>[
//                 BoxShadow(
//                     blurRadius: 10,
//                     offset: Offset(0, 3),
//                     color: Theme.of(context).shadowColor)
//               ]),
//           child: Stack(
//             children: [
//               Hero(
//                 tag: 'category${d.timestamp}',
//                 child: Container(
//                   width: MediaQuery.of(context).size.width,
//                   child: CustomCacheImageWithDarkFilterBottom(
//                       imageUrl: d.thumbnailUrl, radius: 5.0),
//                 ),
//               ),
//               Align(
//                 alignment: Alignment.bottomLeft,
//                 child: Container(
//                   margin: EdgeInsets.only(left: 15, bottom: 15, right: 10),
//                   child: Text(
//                     d.name!,
//                     style: TextStyle(
//                         fontSize: 20,
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600,
//                         letterSpacing: -0.6),
//                   ),
//                 ),
//               )
//             ],
//           )),
//       onTap: () {
//         nextScreen(
//             context,
//             CategoryBasedArticles(
//               category: d.name,
//               categoryImage: d.thumbnailUrl,
//               tag: 'category${d.timestamp}',
//             ));
//       },
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:line_icons/line_icons.dart';
import 'package:news_app/pages/search.dart';
import 'package:news_app/pages/sign_up.dart';
import 'package:news_app/utils/cached_image.dart';
import 'package:news_app/utils/empty.dart';
import 'package:news_app/utils/sign_in_dialog.dart';
import 'package:news_app/widgets/post_container.dart';
import 'package:news_app/widgets/uploadContenttype.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:news_app/blocs/sign_in_bloc.dart';
import 'package:news_app/pages/uploadMedia.dart';
import 'package:news_app/utils/next_screen.dart';
import 'package:provider/provider.dart';

class Engage extends StatefulWidget {
  @override
  _EngageState createState() => _EngageState();
}

class _EngageState extends State<Engage> {
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final sb = context.watch<SignInBloc>();
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: sb.uid != null
                ? CustomCacheImage(
                    radius: 10,
                    height: MediaQuery.of(context).size.height * 0.10,
                    imageUrl: sb.imageUrl,
                  )
                : Image(
                    height: 100,
                    width: 50,
                    image: AssetImage('assets/images/userlogin.png'),
                    fit: BoxFit.fill,
                  )),
        title: InkWell(
          onTap: () {
            sb.uid != null ? botomsheet(sb) : openSignInDialog(context);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.grey, width: 2)),
                child: Center(
                    child: sb.uid != null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'What you want to upload? ${sb.name!}',
                              overflow: TextOverflow.ellipsis,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 13),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'What you want to upload?',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                sb.uid != null ? botomsheet(sb) : openSignInDialog(context);
              },
              icon: Icon((Icons.add_box_outlined))),
          // IconButton(
          //   onPressed: () {
          //     nextScreen(context, SearchPage());
          //   },
          //   icon: Icon(Icons.search),
          // ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('engageTab')
                  .orderBy('datanow', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return LinearProgressIndicator();
                } else if (snapshot.data!.docs.isEmpty)
                  return Expanded(
                    child: ListView(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                        ),
                        EmptyPage(
                            icon: LineIcons.book,
                            message: 'No Posts Found',
                            message1: 'Be the first to Post'),
                      ],
                    ),
                  );
                return Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var data = snapshot.data!.docs[index];
                        return PostContainer(
                          data: data,
                        );
                      }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  botomsheet(SignInBloc sb) {
    showBottomSheet(
        elevation: 4,
        backgroundColor: Colors.indigoAccent[50],
        context: context,
        builder: (context) {
          return Container(
            height: 150,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text('Select Upload Type'),
                ),
                Divider(
                  thickness: 1,
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    UploadType(
                      ontap: () {
                        sb.uid != null
                            ? nextScreen(
                                context,
                                UploadMedia(
                                  tag: 'text',
                                  data: sb,
                                ))
                            : openSignInDialog(context);
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Colors.red,
                      ),
                      type: 'Text',
                    ),
                    UploadType(
                      ontap: () {
                        sb.uid != null
                            ? nextScreen(
                                context,
                                UploadMedia(
                                  tag: 'image',
                                  data: sb,
                                ))
                            : openSignInDialog(context);
                      },
                      icon: Icon(
                        Icons.photo,
                        color: Colors.green,
                      ),
                      type: 'Image',
                    ),
                    UploadType(
                      ontap: () {
                        sb.uid != null
                            ? nextScreen(
                                context,
                                UploadMedia(
                                  tag: 'video',
                                  data: sb,
                                ))
                            : openSignInDialog(context);
                      },
                      icon: Icon(
                        Icons.video_call,
                        color: Colors.amber,
                      ),
                      type: 'Video',
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
