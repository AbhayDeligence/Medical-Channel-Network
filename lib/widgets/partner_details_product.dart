import 'package:flutter/material.dart';

class PartnerDetailsProduct extends StatefulWidget {
  final data;
  const PartnerDetailsProduct({Key? key, this.data}) : super(key: key);

  @override
  _PartnerDetailsProductState createState() => _PartnerDetailsProductState();
}

class _PartnerDetailsProductState extends State<PartnerDetailsProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                        image: NetworkImage(widget.data['compImg']))),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(widget.data['compName'],
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey)),
              Text(
                widget.data['compdesc'],
                textAlign: TextAlign.start,
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(
                color: Colors.black,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(widget.data['contactName'],
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black)),
                      Text(widget.data['contactMobile'],
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black)),
                      Text(widget.data['contactEmail'],
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black)),
                    ],
                  ),
                  Column(
                    children: [
                      OutlinedButton(
                          onPressed: () {},
                          child: const Text('Send Message',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold))),
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text('Request Demo',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(
                color: Colors.black,
              ),
              Text(widget.data['prodTitle'],
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey)),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: MediaQuery.of(context).size.height / 5,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                        image: NetworkImage(widget.data['prodImg']),
                        fit: BoxFit.contain)),
              ),
              Text(
                widget.data['prodDesc'],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
