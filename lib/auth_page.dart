import 'package:flutter/material.dart';
import 'package:myapp/signin_widget.dart';
import 'package:myapp/signup_widget.dart';

class AuthPage extends StatefulWidget {
  AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
      ? SignInWidget(onClickedSignUp: toggle)
      : SignUpWidget(onClickedSignIn: toggle);

  void toggle() => setState(() => isLogin = !isLogin);
}
