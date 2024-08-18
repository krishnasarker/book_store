import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseStore{

  //get collection of data
  final CollectionReference myData=FirebaseFirestore.instance.collection("myData");


}