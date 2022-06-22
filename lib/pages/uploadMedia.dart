import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_app/blocs/sign_in_bloc.dart';
import 'package:news_app/services/app_service.dart';

import 'package:news_app/utils/snacbar.dart';
import 'package:news_app/utils/toast.dart';
import 'package:provider/provider.dart';

class UploadMedia extends StatefulWidget {
  final String? tag;
  final SignInBloc? data;
  UploadMedia({this.tag, this.data});
  @override
  State<UploadMedia> createState() => _UploadMediaState();
}

class _UploadMediaState extends State<UploadMedia> {
  final FirebaseFirestore _fb = FirebaseFirestore.instance;
  File? imageFile;
  String? fileName;
  final _formKey = GlobalKey<FormState>();
  final formKey = GlobalKey<FormState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController controller = TextEditingController();
  TextEditingController videoController = TextEditingController();
  String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                  key: _formKey,
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextFormField(
                        maxLength: 500,
                        maxLines: 2,
                        controller: controller,
                        decoration:
                            InputDecoration(hintText: 'Enter Caption Here...'),
                        validator: (String? value) {
                          if (value!.isEmpty || value.length == 0) {
                            return 'Field can\'t be empty';
                          }
                          return null;
                        },
                      ),
                    ),
                  )),
              if (widget.tag == 'image')
                InkWell(
                  onTap: pickImage,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    height: MediaQuery.of(context).size.height / 4,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey[800]!),
                        color: Colors.grey[500],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: (imageFile == null
                                    ? CachedNetworkImageProvider(
                                        widget.data!.imageUrl!)
                                    : FileImage(imageFile!))
                                as ImageProvider<Object>,
                            fit: BoxFit.contain)),
                  ),
                )
              else if (widget.tag == 'video')
                Column(
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      height: MediaQuery.of(context).size.height / 4,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: videoController,
                              decoration: InputDecoration(
                                  hintText: 'Video Url Required'),
                              validator: (value) {
                                if (value!.isEmpty || value.length == 0) {
                                  return 'Video Url Required';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              else
                const SizedBox(),
              SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: uploaddata,
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
      ),
    );
  }

  void uploaddata() async {
    var date = DateFormat("dd-MM-yyyy").format(DateTime.now());
    if (widget.tag == 'text') {
      if (_formKey.currentState!.validate()) {
        await _fb
            .collection('engageTab')
            .doc()
            .set({
              'reported': [],
              'videoUrl': '',
              'postImgUrl': '',
              'textContent': controller.text,
              'username': widget.data!.name,
              'userImage': widget.data!.imageUrl,
              'userUID': widget.data!.uid,
              'datanow': date,
              'likes': [],
              'headline': widget.data!.headline
            })
            .onError((error, stackTrace) =>
                openSnacbar(_scaffoldKey, 'Something went wrong..'))
            .then((value) => openToast1(context, 'Uploaded Successfully...'))
            .then((value) => Navigator.pop(context));
        controller.clear();
      } else {
        openToast1(context, 'Enter some text before uploading....');
      }
    } else if (widget.tag == 'image') {
      uploadPicture()
          .then((value) => _fb.collection('engageTab').doc().set({
                'reported': [],
                'postImgUrl': imageUrl,
                'textContent': controller.text,
                'username': widget.data!.name,
                'userImage': widget.data!.imageUrl,
                'userUID': widget.data!.uid,
                'datanow': date,
                'videoUrl': '',
                'likes': [],
                'headline': widget.data!.headline
              }))
          .then((value) => openToast1(context, 'Uploaded Successfully...'))
          .then((value) => Navigator.pop(context));
    } else {
      if (formKey.currentState!.validate())
        _fb
            .collection('engageTab')
            .doc()
            .set({
              'postImgUrl': '',
              'reported': [],
              'textContent': controller.text,
              'username': widget.data!.name,
              'userImage': widget.data!.imageUrl,
              'userUID': widget.data!.uid,
              'datanow': date,
              'videoUrl': videoController.text,
              'likes': [],
              'headline': widget.data!.headline
            })
            .then((value) => openToast1(context, 'Uploaded Successfully...'))
            .then((value) => Navigator.pop(context));
    }
  }

  Future pickImage() async {
    final _imagePicker = ImagePicker();
    var imagepicked = await _imagePicker.getImage(
        source: ImageSource.gallery, maxHeight: 200, maxWidth: 200);

    if (imagepicked != null) {
      setState(() {
        imageFile = File(imagepicked.path);
        fileName = (imageFile!.path);
      });
    } else {
      print('No image selected!');
    }
  }

  Future uploadPicture() async {
    final SignInBloc sb = context.read<SignInBloc>();
    Reference storageReference =
        FirebaseStorage.instance.ref().child('Profile Pictures/${sb.uid}');
    UploadTask uploadTask = storageReference.putFile(imageFile!);

    await uploadTask.whenComplete(() async {
      var _url = await storageReference.getDownloadURL();
      var _imageUrl = _url.toString();
      setState(() {
        imageUrl = _imageUrl;
      });
    });
  }

  handleUpdateData() async {
    await AppService().checkInternet().then((hasInternet) async {
      if (hasInternet == false) {
        openSnacbar(_scaffoldKey, 'no internet');
      } else {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();

          imageFile == null
              ? openSnacbar(_scaffoldKey, 'Image not selected')
              : openSnacbar(_scaffoldKey, 'done');
        }
      }
    });
  }
}
