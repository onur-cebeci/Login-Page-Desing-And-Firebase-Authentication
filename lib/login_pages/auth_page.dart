import 'package:flutter/material.dart';
import 'package:login_page/login_pages/login_page.dart';
import 'package:login_page/login_pages/sing_up_page.dart';

class AuthPage extends StatefulWidget {
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  @override
  Widget build(BuildContext context) => isLogin
      ? LoginPage(onClicledSingUp: toggle)
      : SingUpPage(onClickedSignIn: toggle);

  void toggle() => setState(() => isLogin = !isLogin);
}
