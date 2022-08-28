import 'dart:ui';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_page/constant.dart';

class SingUpPage extends StatefulWidget {
  final Function() onClickedSignIn;

  const SingUpPage({
    Key? key,
    required this.onClickedSignIn,
  }) : super(key: key);
  @override
  _SingUpPageState createState() => _SingUpPageState();
}

class _SingUpPageState extends State<SingUpPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController passwordControllerAgain = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: const Icon(Icons.arrow_back),
          onTap: widget.onClickedSignIn,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Form(
        key: formKey,
        child: Container(
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
              Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('login_sing_up',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 32,
                                color: Colors.white,
                                inherit: false)),
                        const SizedBox(height: 46),
                        TextFormField(
                          controller: emailController,
                          cursorColor: Colors.white,
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              fillColor: Colors.transparent,
                              filled: true,
                              labelStyle:
                                  TextStyle(color: Colors.white, fontSize: 14),
                              labelText: 'email_login'),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (email) =>
                              email != null && !EmailValidator.validate(email)
                                  ? 'enter_valid_email_address'
                                  : null,
                        ),
                        SizedBox(height: smallPading),
                        TextFormField(
                          obscureText: true,
                          controller: passwordController,
                          cursorColor: Colors.white,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            fillColor: Colors.transparent,
                            filled: true,
                            labelStyle:
                                TextStyle(color: Colors.white, fontSize: 14),
                            labelText: 'select_password',
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) =>
                              value != null && value.length < 6
                                  ? 'min_six_char'
                                  : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          obscureText: true,
                          controller: passwordControllerAgain,
                          cursorColor: Colors.white,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            fillColor: Colors.transparent,
                            filled: true,
                            labelStyle:
                                TextStyle(color: Colors.white, fontSize: 14),
                            labelText: 'sign_up_again_password',
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (_) => passwordController.text.trim() !=
                                  passwordControllerAgain.text.trim()
                              ? 'same_alert'
                              : null,
                        ),
                        const SizedBox(height: 28),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 52,
                          child: MaterialButton(
                            color: kPrimaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28)),
                            onPressed: () {
                              singUp();
                            },
                            child: const Text(
                              'login_sing_up',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future singUp() async {
    String emailAnswerText = 'already_exists';
    final snackBar = SnackBar(
      content: Text(
        emailAnswerText,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
      ),
      backgroundColor: kPrimaryColor,
    );
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
