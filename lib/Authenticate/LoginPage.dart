import 'package:flutter/material.dart';
import 'package:tomo/Authenticate/Methods.dart';
import 'package:tomo/Screens/HomeScreen.dart';
import 'package:tomo/todogroup/group_chat_screen.dart';
import 'SignUp.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.orange.shade100,
      body: isLoading
          ? Center(
              child: Container(
                height: size.height / 20,
                width: size.height / 20,
              
                child: CircularProgressIndicator(
                   backgroundColor:Colors.black,
                   valueColor: AlwaysStoppedAnimation<Color>(Colors.orange.shade100),
                ),
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(top: 25.0, left: 30.0, right: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50.0),
                      child: Text(
                        'Log In',
                        style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    TextField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(fontWeight: FontWeight.w500),
                          cursorColor: Colors.black,
                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            suffixIcon: Icon(Icons.check, color: Colors.black),
                            hintText: 'Your Email',
                            labelText: 'Your Email',
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.black))),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                        controller: _password,
                        obscureText: true,
                        style: TextStyle(fontWeight: FontWeight.w500),
                          cursorColor: Colors.black,
                        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),

                        
                            hintText: 'Password',
                            labelText: 'Password',
                            labelStyle:
                                TextStyle(fontWeight: FontWeight.w400, color: Colors.black))),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: RawMaterialButton(
                        onPressed: () {
                          if (_email.text.isNotEmpty &&
                              _password.text.isNotEmpty) {
                            setState(() {
                              isLoading = true;
                            });

                            logIn(_email.text, _password.text).then((user) {
                              if (user != null) {
                                print("Login Sucessfull");
                                setState(() {
                                  isLoading = false;
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => GrouptodoHomeScreen()));
                              } else {
                                print("Login Failed");
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            });
                          } else {
                            print("Please fill form correctly");
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            'Log In',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        elevation: 6.0,
                        fillColor: Colors.black,
                        shape: StadiumBorder(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUp()));
                            },
                            child: Text(
                              'Or create a account',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16.0),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
    );
  }
}
