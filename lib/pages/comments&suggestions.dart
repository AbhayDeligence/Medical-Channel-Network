import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:news_app/blocs/sign_in_bloc.dart';
import 'package:news_app/utils/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

class CommentSugestion extends StatefulWidget {
  CommentSugestion({Key? key}) : super(key: key);

  @override
  State<CommentSugestion> createState() => _CommentSugestionState();
}

class _CommentSugestionState extends State<CommentSugestion> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  Future<void> send({SignInBloc? sb}) async {
    FirebaseFirestore.instance
        .collection('Comments&Suggestions')
        .doc()
        .set({
          'username': sb!.name,
          'userImage': sb.imageUrl,
          'uid': sb.uid,
          'c&s': _controller.text
        })
        .then((value) => _controller.clear())
        .then((value) => openToast1(context, 'Done'));
  }

  @override
  Widget build(BuildContext context) {
    final sb = context.watch<SignInBloc>();
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              send(sb: sb);
            } else {
              openToast1(context, 'Write something before send');
            }
          },
          child: Icon(Icons.send),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/icon.png'),
                            fit: BoxFit.contain))),
              ),
              const SizedBox(
                height: 80,
              ),
              ListTile(
                title: Text(
                  'Comments',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                subtitle: Text(
                  'Helping Us Prefect the Service \nPrior to the official release date in MAY of 2022, we welcome your input to make this app what is best for healthcare professionals. We hope to have a true peer-to-peer delivery. \nComments or suggestions',
                  textAlign: TextAlign.start,
                ),
                isThreeLine: true,
              ),
              const SizedBox(
                height: 60,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _controller,
                    autofocus: true,
                    style: TextStyle(color: Colors.black, fontSize: 15),
                    decoration: InputDecoration.collapsed(
                      hintText: "Comments & Suggestions",
                      border: InputBorder.none,
                    ),
                    maxLines: 8,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
