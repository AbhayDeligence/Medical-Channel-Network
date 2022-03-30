import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_app/blocs/sign_in_bloc.dart';
import 'package:news_app/pages/engagetab_comment.dart';
import 'package:news_app/pages/postVideo.dart';
import 'package:news_app/services/app_service.dart';
import 'package:news_app/utils/cached_image.dart';
import 'package:news_app/utils/next_screen.dart';
import 'package:news_app/utils/toast.dart';
import 'package:provider/provider.dart';

class PostContainer extends StatelessWidget {
  final QueryDocumentSnapshot? data;
  const PostContainer({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _PostHeader(
                  data: data,
                ),
                const SizedBox(height: 4.0),
                Text(
                  data!['textContent'],
                  textAlign: TextAlign.start,
                ),
                data!['postImgUrl'] != ''
                    ? const SizedBox(
                        height: 6.0,
                      )
                    : const SizedBox.shrink(),
                data!['videoUrl'] != null
                    ? const SizedBox(
                        height: 6.0,
                      )
                    : const SizedBox.shrink()
              ],
            ),
          ),
          if (data!['postImgUrl'] != '')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CustomCacheImage(
                imageUrl: data!['postImgUrl'],
                radius: 1,
                height: MediaQuery.of(context).size.height * 0.55,
                width: MediaQuery.of(context).size.width,
              ),
            )
          else if (data!['videoUrl'] != '')
            InkWell(
              onTap: () => nextScreen(
                  context,
                  PostVideo(
                    data: data,
                  )),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                  'https://img.youtube.com/vi/${AppService.getYoutubeVideoIdFromUrl(data!['videoUrl'])}/0.jpg'),
                              fit: BoxFit.fill)),
                      height: MediaQuery.of(context).size.height * 0.55,
                      width: MediaQuery.of(context).size.width,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Icon(
                        Icons.video_call,
                        color: Colors.grey,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SizedBox(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: _PostStats(data: data),
          ),
        ],
      ),
    );
  }
}

class _PostHeader extends StatefulWidget {
  final QueryDocumentSnapshot? data;
  const _PostHeader({Key? key, this.data}) : super(key: key);

  @override
  __PostHeaderState createState() => __PostHeaderState();
}

class __PostHeaderState extends State<_PostHeader> {
  File? imageFile;
  String? fileName;
  TextEditingController textcontroller = TextEditingController();
  TextEditingController videocontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final sb = context.watch<SignInBloc>();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomCacheImage(
          width: 40,
          imageUrl: widget.data!['userImage'],
          radius: 10,
          height: 40,
        ),
        SizedBox(width: 8.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.data!['username']),
              sb.headline != null
                  ? Text(
                      sb.headline!,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    )
                  : SizedBox.shrink(),
              Row(
                children: [
                  Text(
                    '${widget.data!['datanow']}  *  ',
                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  ),
                  Icon(
                    Icons.public,
                    color: Colors.grey[600],
                    size: 8,
                  ),
                ],
              ),
            ],
          ),
        ),
        PopupMenuButton(onSelected: (value) {
          if (widget.data!['userUID'] == sb.uid) {
            if (value == 'edit') {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        height: MediaQuery.of(context).size.height / 1.5,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Wrap(
                              children: [
                                Text(
                                  'Caption : ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextFormField(
                                  //controller: textcontroller,
                                  initialValue: widget.data!['textContent'],
                                  decoration: InputDecoration(),
                                  // validator: (String? value) {
                                  //   if (value!.isEmpty) {
                                  //     return "Can't be empty";
                                  //   }
                                  //   return null;
                                  // },
                                ),
                              ],
                            ),
                            if (widget.data!['postImgUrl'] != '')
                              InkWell(
                                onTap: pickImage,
                                child: Container(
                                    height: 200,
                                    width: 200,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: (imageFile == null
                                              ? CachedNetworkImageProvider(
                                                  widget.data!['postImgUrl'])
                                              : FileImage(
                                                  imageFile!)) as ImageProvider<
                                              Object>,
                                          fit: BoxFit.contain),
                                    )),
                              )
                            else if (widget.data!['videoUrl'] != '')
                              Wrap(
                                children: [
                                  Text(
                                    'Video Url : ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextFormField(
                                    //controller: videocontroller,
                                    initialValue:
                                        widget.data!['videoUrl'] ?? '',
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ],
                              )
                            else
                              SizedBox.shrink(),
                            InkWell(
                              onTap: () {
                                print(videocontroller);
                                print(textcontroller);
                              },
                              child: Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width * 0.6,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.deepPurple),
                                child: Center(
                                  child: Text(
                                    'Upload',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            } else if (value == 'report') {
              FirebaseFirestore.instance.collection('engageTab').doc().set({
                'reported': FieldValue.arrayUnion([sb.uid])
              }).then((value) => openToast1(context, 'Reported'));
            } else {
              FirebaseFirestore.instance
                  .collection('engageTab')
                  .doc(widget.data!.id)
                  .delete()
                  .then((value) => openToast1(context, 'Deleted'));
            }
          }
        }, itemBuilder: (context) {
          return [
            PopupMenuItem(
              value: 'edit',
              child: Text('Edit'),
            ),
            PopupMenuItem(
              value: 'report',
              child: Text('Report'),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
            ),
          ];
        }),
      ],
    );
  }

  Future pickImage() async {
    final _imagePicker = ImagePicker();
    var imagepicked = await _imagePicker.getImage(
      source: ImageSource.gallery,
      maxHeight: 200,
      maxWidth: 200,
    );

    if (imagepicked != null) {
      setState(() {
        imageFile = File(imagepicked.path);
        fileName = (imageFile!.path);
      });
    } else {
      print('No image selected!');
    }
  }
}

class _PostStats extends StatelessWidget {
  final QueryDocumentSnapshot? data;
  const _PostStats({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sb = context.watch<SignInBloc>();

    return Column(
      children: [
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                if (data!['likes'].contains(data!['userUID'])) {
                  FirebaseFirestore.instance
                      .collection('engageTab')
                      .doc(data!.id)
                      .update({
                    'likes': FieldValue.arrayRemove([data!['userUID']])
                  });
                } else {
                  FirebaseFirestore.instance
                      .collection('engageTab')
                      .doc(data!.id)
                      .update({
                    'likes': FieldValue.arrayUnion([data!['userUID']])
                  });
                }
              },
              child: Row(
                children: [
                  Icon(
                    Icons.favorite,
                    size: 25,
                    color: data!['likes'].contains(data!['userUID'])
                        ? Colors.red
                        : Colors.grey,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  //Text(data!['likes'].length.toString()),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                if (data!['userUID'] == sb.uid) {
                  nextScreen(
                      context,
                      EngagetabComments(
                        data: data,
                        myPost: true,
                      ));
                } else {
                  nextScreen(
                      context,
                      EngagetabComments(
                        data: data,
                        myPost: false,
                      ));
                }
              },
              child: Row(
                children: [
                  Icon(
                    Icons.message,
                    color: Colors.grey,
                    size: 20,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Comments',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
        // edited
        Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('engageTab')
                  .doc(data!.id)
                  .collection('Comments')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                var datacomment = snapshot.data!.docs;
                return Expanded(
                  child: Column(
                    children: [
                      datacomment.length > 1
                          ? const Divider(
                              color: Colors.grey,
                            )
                          : const SizedBox.shrink(),
                      datacomment.length > 0
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 1),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: CachedNetworkImageProvider(
                                        datacomment[0]['userImage']),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(datacomment[0]['userName'],
                                          textAlign: TextAlign.start,
                                          style: TextStyle(fontSize: 18)),
                                      Text(datacomment[0]['comment'],
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 15))
                                    ],
                                  ),
                                  const Spacer(),
                                  Text(datacomment[0]['date'],
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 10)),
                                ],
                              ),
                            )
                          : SizedBox.shrink(),
                      const Divider(
                        color: Colors.grey,
                      ),
                      datacomment.length > 1
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 1),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: CachedNetworkImageProvider(
                                        datacomment[1]['userImage']),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(datacomment[1]['userName'],
                                          textAlign: TextAlign.start,
                                          style: TextStyle(fontSize: 18)),
                                      Text(datacomment[1]['comment'],
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 15))
                                    ],
                                  ),
                                  const Spacer(),
                                  Text(datacomment[1]['date'],
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 10)),
                                ],
                              ),
                            )
                          : SizedBox.shrink(),
                      InkWell(
                        onTap: () {
                          if (data!['userUID'] == sb.uid) {
                            nextScreen(
                                context,
                                EngagetabComments(
                                  data: data,
                                  myPost: true,
                                ));
                          } else {
                            nextScreen(
                                context,
                                EngagetabComments(
                                  data: data,
                                  myPost: false,
                                ));
                          }
                        },
                        child: Row(
                          children: [
                            const Spacer(),
                            const Text(
                              'see more...',
                              style: TextStyle(color: Colors.blueAccent),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            )),
      ],
    );
  }
}
