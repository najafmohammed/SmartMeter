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
int monthTotal=0;
    int dayTotal=0;
    for(int i=1;i<32;i++){
      for (int j=0;j<24;j++){
        int temp=next(0, 9);
        monthTotal+=temp;
        dayTotal+=temp;
        value.add(temp);
      }
      await userPreferences.document(uid).collection('Readings').document(
          yearMonth).setData({
        i.toString():{'value':value,'daytotal':dayTotal},
        'total':monthTotal,
      },merge: true);
      dayTotal=0;
      value.clear();
    }
  }

  Future getWeekData(){

  }
}