import 'package:cloud_firestore/cloud_firestore.dart';

class DomainList {
  List? domains;

  DomainList({
    this.domains,
  });

  factory DomainList.fromFirestore(DocumentSnapshot snapshot) {
    Map d = snapshot.data() as Map<dynamic, dynamic>;
    return DomainList(domains: d['domains']);
  }
}
