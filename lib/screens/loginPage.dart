import 'package:flutter/material.dart';
import 'package:flutter_sandbox/controllers/localUserController.dart';
import 'package:flutter_sandbox/screens/homePage.dart';
import 'package:flutter_sandbox/xmpp/client.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xmpp_stone/xmpp_stone.dart';

import '../models/localUserDataModel.dart';
import '../utils/exceptions.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // maintains validators and state of form fields
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  bool _isInvalidAsyncServer = false;
  bool _isInvalidAsyncUser = false;

  bool _isLoading = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void toggleSpinner() {
    _isLoading = !_isLoading;
  }

  void toggleServerError() {
    _isInvalidAsyncServer = !_isInvalidAsyncServer;
  }

  void toggleEmailError() {
    _isInvalidAsyncUser = !_isInvalidAsyncUser;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/login.png'), fit: BoxFit.cover),
        ),
        child: Form(
          key: _loginFormKey,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Container(),
                Container(
                  padding: const EdgeInsets.only(left: 35, top: 130),
                  child: const Text(
                    'My Dudes',
                    style: TextStyle(color: Colors.white, fontSize: 58),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 35, right: 35),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 30,
                              ),
                              TextFormField(
                                controller: emailController,
                                style: const TextStyle(color: Colors.black),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Can not be empty!';
                                  }
                                  if (_isInvalidAsyncServer) {
                                    return 'Cant establish connection to server';
                                  }

                                  return null;
                                },
                                decoration: InputDecoration(
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    hintText: "Email",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              TextFormField(
                                controller: passwordController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Can not be empty!';
                                  }
                                  if (_isInvalidAsyncUser) {
                                    return 'Cant authenticate';
                                  }
                                  return null;
                                },
                                style: const TextStyle(),
                                obscureText: true,
                                decoration: InputDecoration(
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    hintText: "Password",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () async {
                                      // dismiss keyboard during async call
                                      FocusScope.of(context).requestFocus(new FocusNode());

                                      if (_loginFormKey.currentState!.validate()) {
                                        try {
                                          setState(() {
                                            toggleSpinner();
                                          });

                                          await LocalUserController()
                                              .login(
                                                emailController.text,
                                                passwordController.text,
                                              )
                                              .then((value) => {Navigator.pushReplacementNamed(context, '/home')});
                                        } on XMPPAuthenticationException {
                                          _loginFormKey.currentState!.save();
                                          setState(() {
                                            toggleSpinner();
                                            toggleEmailError();
                                          });
                                          _loginFormKey.currentState!.validate();
                                          toggleEmailError();
                                        } on XMPPServerConnectionException {
                                          _loginFormKey.currentState!.save();
                                          setState(() {
                                            toggleSpinner();
                                            toggleServerError();
                                          });

                                          _loginFormKey.currentState!.validate();
                                          toggleServerError();
                                        }
                                      }
                                    },
                                    style: const ButtonStyle(),
                                    child: const Text(
                                      'Sign In',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(decoration: TextDecoration.underline, color: Color(0xff4c505b), fontSize: 18),
                                    ),
                                  ),
                                  _isLoading
                                      ? const Center(
                                          child: SpinKitFadingCircle(
                                          color: Colors.green,
                                          size: 50.0,
                                        ))
                                      : Row()
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
