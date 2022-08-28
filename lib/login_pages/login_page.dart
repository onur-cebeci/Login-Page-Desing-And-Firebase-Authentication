import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login_page/constant.dart';
import 'package:login_page/login_pages/forgot_password.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onClicledSingUp;
  const LoginPage({
    Key? key,
    required this.onClicledSingUp,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late final FirebaseAuth _auth = FirebaseAuth.instance;
  late final _user = _auth.currentUser;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: ExactAssetImage("assets/images/login.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 90),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.0),
                  ),
                ),
              ),
            ),
            buildForm(context),
          ],
        ),
      ),
    );
  }

  Form buildForm(BuildContext context) {
    return Form(
      key: formKey,
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('login_title',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        color: Colors.white,
                        inherit: false)),
                const SizedBox(height: 46),
                EmailFormField(),
                const SizedBox(height: 14),
                PasswordFormField(),
                const SizedBox(height: 40),
                customButton(context),
                const SizedBox(height: 28),
                resetPasswordButton(context),
                const SizedBox(height: 38),
                googleSingIn(context),
                const SizedBox(height: 18),
                SingUpButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container SingUpButton(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 52,
      child: MaterialButton(
        color: kLightColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        onPressed: widget.onClicledSingUp,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 15),
            const Text(
              'login_sing_up',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Container googleSingIn(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 52,
      child: MaterialButton(
        color: kShadowColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        onPressed: () {
          singInGoogle();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/icons/google.png"),
            const SizedBox(width: 15),
            const Text(
              'google_wit_login',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector resetPasswordButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const ForgotPasswordPage(),
      )),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 2 - 100,
            height: 1,
            color: kPrimaryColor,
          ),
          const SizedBox(width: 8),
          const Text(
            'login_forgot_password',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 8),
          Container(
            width: MediaQuery.of(context).size.width / 2 - 100,
            height: 1,
            color: kPrimaryColor,
          ),
        ],
      ),
    );
  }

  Container customButton(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 52,
      child: MaterialButton(
        color: kPrimaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        onPressed: () async {
          setState(() {
            singIn();
          });
        },
        child: const Text(
          'login_title',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  TextFormField PasswordFormField() {
    return TextFormField(
      obscureText: true,
      cursorColor: Colors.white,
      controller: passwordController,
      style: const TextStyle(color: Colors.white),
      decoration: const InputDecoration(
        fillColor: Colors.transparent,
        filled: true,
        labelStyle: TextStyle(color: Colors.white, fontSize: 18),
        labelText: 'login_password',
      ),
    );
  }

  TextFormField EmailFormField() {
    return TextFormField(
      controller: emailController,
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
          fillColor: Colors.transparent,
          filled: true,
          labelStyle: TextStyle(color: Colors.white, fontSize: 18),
          labelText: "Email"),
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Future<void> singIn() async {
    String emailAnswerText = 'email_or_password_false';
    final snackBar = SnackBar(
      content: Text(
        emailAnswerText,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
      ),
      backgroundColor: kPrimaryColor,
    );
    try {
      await _auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> singInGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
