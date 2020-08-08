import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
class DatabaseService {
  final String uid;

  //get the unique uid of the user
  DatabaseService({this.uid});

  final CollectionReference userPreferences = Firestore.instance.collection(
      'Users');

  Future  Getdata(String yearMonth) async {
    return await userPreferences.document(uid).collection('Readings').document(
        yearMonth).get();
  }
  //gen random data
  Future setData(String yearMonth) async {
    final _random = new Random();
    int next(int min, int max) => min + _random.nextInt(max - min);
    List value=[];
    for (int i=0;i<24;i++){
    value.add(next(0, 9));
    }
    for(int i=1;i<32;i++){
      await userPreferences.document(uid).collection('Readings').document(
          yearMonth).setData({
        i.toString():value,
      },merge: true);
    }
  }

  Future getWeekData(){

  }
}