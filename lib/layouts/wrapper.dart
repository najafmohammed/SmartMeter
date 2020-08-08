import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_meter/Models/users.dart';
import 'package:smart_meter/layouts/Authenticate/Authenticate.dart';
import 'package:smart_meter/layouts/Home/Home.dart';
class Wrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    final user = Provider.of<User>(context);
    if(user == null){
      return SignIn();
    }
    else{
      return Home();
    }
  }

}