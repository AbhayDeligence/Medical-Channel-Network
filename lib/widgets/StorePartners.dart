import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:news_app/utils/next_screen.dart';

import 'store_partner_details.dart';

class StorePartners extends StatelessWidget {
  const StorePartners({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('SponsersTab').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text('Sponsers list is empty'),
              );
            } else {
              return Container(
                height: h / 1,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                            onTap: () {
                              nextScreen(
                                  context, StorePartnerDetails(data: data));
                            },
                            child: categories(data['title'])),
                        divider(),
                      ],
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget categories(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.blue[900],
        fontWeight: FontWeight.w500,
        fontSize: 17,
      ),
    );
  }

  Widget divider() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10),
      child: Divider(
        color: Colors.black,
        height: 2,
      ),
    );
  }
}
