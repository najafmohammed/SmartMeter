
import 'package:flutter/material.dart';
import 'package:smart_meter/Services/auth.dart';
import 'package:smart_meter/Shared/loading.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({this.toggleView });
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _showPassword = false;
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String email='';
  String password = '';
  String error='';
  @override
  Widget build(BuildContext context) {
    return loading ? Loading(): Scaffold(
      backgroundColor: Color(0xff7E4D8B),
      body: SingleChildScrollView(
        child: Form(key:_formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child:new Text(
                        "Sign In",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Poppins",fontWeight: FontWeight.w700,
                          fontSize: 45,
                          color:Color(0xffffffff),
                        ),
                      )
                  ),

                ],
              ),
              SizedBox(
                height: 70,
              ),
              Center(
                child: new Container(
                  height: 70,
                  width: 340,
                  child: new TextFormField(validator: (val) => val.isEmpty ? 'Enter an Email' : null,
                    onChanged:(val){
                      setState(()=>email=val);
                    },
                    style:TextStyle(
                      color:  Colors.white,
                      fontFamily: "Poppins",fontWeight: FontWeight.w500,
                    ),
                    decoration: new InputDecoration(
                      hintText: 'Enter Your email',
                      hintStyle: TextStyle(
                        color:Color(0xffffffff).withOpacity(0.30),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color:Color(0xffffffff).withOpacity(0.30),),
                      ),
                      labelText: 'Email',
                      labelStyle: new TextStyle(
                          fontFamily: "Poppins",
                          color:  Color(0xffffffff)
                      ),
                    ),
                    cursorColor:  Color(0xffffffff),
                  ),
                ),
              ),

              Center(
                child: Container(
                  height: 70,
                  width: 340,
                  child: TextFormField(
                    style:TextStyle(
                        fontFamily: "Poppins",fontWeight: FontWeight.w500,
                        color:  Colors.white
                    ),
                    //controller: widget.controller,
                    cursorColor:  Color(0xffffffff),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: new TextStyle(
                          fontFamily: "Poppins",
                          color:  Color(0xffffffff)
                      ),
                      hintText: 'Enter Your Password',
                      hintStyle: TextStyle(
                        color:Color(0xffffffff).withOpacity(0.30),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color:Color(0xffffffff).withOpacity(0.30),),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                        child: Icon(
                          _showPassword ? Icons.visibility : Icons.visibility_off,
                          color: Color(0xffffffff),
                        ),
                      ),
                    ),
                    obscureText: !_showPassword,
                    onChanged:(val){
                      setState(()=>password=val);
                    },
                    validator: (val) => val.length < 6 ? 'Enter a password 6+ chars long' : null,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new GestureDetector(
                        child:InkWell(

                          onTap: (){

                          },
                          splashColor:Colors.white,
                          child: Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: new Text(
                                "Forgot password?",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14,
                                  color:Color(0xffffffff).withOpacity(0.30),
                                ),
                              )
                          ),
                        ) ,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),

                  Center(
                    child: Container(
                      height: 45,
                      width: 340,
                      child: RaisedButton(
                        onPressed: ()async{
                          if(_formKey.currentState.validate()){
                            setState(() => loading = true);
                            dynamic result = await _auth.signInwithEmailAndPassword(email, password);
                            if(result == null){
                              setState(() {
                                error = 'could not sign in';
                                loading = false;
                              });
                            }
                          }
                        },
                        color: Colors.white,
                        splashColor:Color(0xff7E4D8B),
                        child: Text(
                          "Sign In",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Poppins",fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color:Color(0xff7E4D8B),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 130,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        "DON’T HAVE AN ACCOUNT ?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 12,
                          color:Color(0xffffffff),
                        ),
                      )

                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        onTap: (){widget.toggleView();
                        },
                        splashColor: Color(0xff7E4D8B),
                        child: new Text(
                          "REGISTER HERE",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Poppins",fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color:Color(0xffffffff),
                          ),
                        ),
                      )
                    ],
                  )


                ],
              ),

            ],

          ),
        ),
      ),
    );
  }
}