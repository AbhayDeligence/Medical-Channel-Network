import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:line_icons/line_icons.dart';
import 'package:news_app/blocs/sign_in_bloc.dart';
import 'package:news_app/utils/empty.dart';
import 'package:news_app/utils/toast.dart';
import 'package:provider/provider.dart';

class EngagetabComments extends StatefulWidget {
  final QueryDocumentSnapshot? data;
  final bool? myPost;
  EngagetabComments({Key? key, this.data, this.myPost}) : super(key: key);

  @override
  State<EngagetabComments> createState() => _EngagetabCommentsState();
}

class _EngagetabCommentsState extends State<EngagetabComments> {
  var textCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final sb = context.watch<SignInBloc>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('comments').tr(),
        titleSpacing: 0,
        actions: [
          IconButton(
              icon: Icon(
                Feather.rotate_cw,
                size: 22,
              ),
              onPressed: () {})
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('engageTab')
                      .doc(widget.data!.id)
                      .collection('Comments')
                      .orderBy('date', descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData)
                      return Container(
                        height: 5,
                        child: LinearProgressIndicator(
                          minHeight: 2,
                        ),
                      );
                    else if (snapshot.data!.docs.length == 0)
                      return Expanded(
                        child: ListView(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.35,
                            ),
                            EmptyPage(
                                icon: LineIcons.comments,
                                message: 'no comments found'.tr(),
                                message1: 'be the first to comment'.tr()),
                          ],
                        ),
                      );
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var data = snapshot.data!.docs[index];
                        return InkWell(
                          onLongPress: () {
                            if (sb.uid == data['uid'] ||
                                widget.myPost == true) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Delete !'),
                                      content: Text('Are you sure ?'),
                                      actions: [
                                        OutlinedButton(
                                            onPressed: () {
                                              FirebaseFirestore.instance
                                                  .collection('engageTab')
                                                  .doc(widget.data!.id)
                                                  .collection('Comments')
                                                  .doc(data.id)
                                                  .delete()
                                                  .then((value) =>
                                                      Navigator.pop(context))
                                                  .then((value) => openToast(
                                                      context, 'Deleted !!'));
                                            },
                                            child: Text('Yes')),
                                        OutlinedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('No'),
                                        ),
                                      ],
                                    );
                                  });
                            } else {}
                          },
                          child: ListTile(
                            trailing: Text(
                              data['date'],
                              style: TextStyle(fontSize: 9),
                            ),
                            title: Text(
                              data['userName'],
                              style: TextStyle(fontSize: 14),
                            ),
                            subtitle: Text(
                              data['comment'],
                              style: TextStyle(color: Colors.grey),
                            ),
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  CachedNetworkImageProvider(data['userImage']),
                            ),
                          ),
                        );
                      },
                    );
                  })),
          const Divider(
            height: 1,
            color: Colors.black26,
          ),
          SafeArea(
            child: Container(
              height: 65,
              padding: EdgeInsets.only(top: 8, bottom: 10, right: 20, left: 20),
              width: double.infinity,
              color: Theme.of(context).primaryColorLight,
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).splashColor,
                    borderRadius: BorderRadius.circular(25)),
                child: TextFormField(
                  decoration: InputDecoration(
                      errorStyle: TextStyle(fontSize: 0),
                      contentPadding:
                          EdgeInsets.only(left: 15, top: 10, right: 5),
                      border: InputBorder.none,
                      hintText: 'write a comment'.tr(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.send,
                          size: 20,
                        ),
                        onPressed: () {
                          var date =
                              DateFormat("dd-MM-yyyy").format(DateTime.now());

                          if (textCtrl.text.isNotEmpty)
                            FirebaseFirestore.instance
                                .collection('engageTab')
                                .doc(widget.data!.id)
                                .collection('Comments')
                                .doc()
                                .set({
                              'comment': textCtrl.text,
                              'date': date,
                              'userName': sb.name,
                              'userImage': sb.imageUrl,
                              'uid': sb.uid
                            }).then((value) => textCtrl.clear());
                          else
                            openToast(context, 'Enter Some Text First');
                        },
                      )),
                  controller: textCtrl,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
