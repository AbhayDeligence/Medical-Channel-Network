import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:news_app/utils/next_screen.dart';
import 'package:news_app/widgets/partner_details_product.dart';

class StorePartnerDetails extends StatefulWidget {
  final QueryDocumentSnapshot? data;

  const StorePartnerDetails({Key? key, this.data}) : super(key: key);

  @override
  _StorePartnerDetailsState createState() => _StorePartnerDetailsState();
}

class _StorePartnerDetailsState extends State<StorePartnerDetails> {
  @override
  Widget build(BuildContext context) {
    Map data = (widget.data!.data() as Map<String, dynamic>);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
          itemCount: data.containsKey('data') ? data['data'].length : 0,
          itemBuilder: (context, index) {
            var metaData = data['data'][index];
            return data.containsKey('data')
                ? Container(
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: InkWell(
                      onTap: () {
                        nextScreen(
                            context,
                            PartnerDetailsProduct(
                              data: data['data'][index],
                            ));
                      },
                      child: ListTile(
                        leading: Container(
                          height: 80,
                          width: 70,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            image: DecorationImage(
                                image: NetworkImage(metaData['compImg']),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        title: Text(
                          metaData['compName'],
                          textAlign: TextAlign.start,
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              metaData['compdesc'],
                              textAlign: TextAlign.start, 
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 12),
                            ),
                            // Text(
                            //   metaData['prodTitle'],
                            //   style: TextStyle(fontSize: 15),
                            // ),
                          ],
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      'NOTHING TO SHOW HERE..',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  );
          }),
    );
  }
}
