import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_page/constant.dart';
import 'package:login_page/home_page.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({
    Key? key,
  }) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();
      Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    String emailVerifyText = 'renewal_link';
    final snackBar = SnackBar(
      content: Text(
        emailVerifyText,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
      ),
      backgroundColor: kPrimaryColor,
    );
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 8));
      setState(() => canResendEmail = true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified == true
      ? const HomePage()
      : Scaffold(
          appBar: AppBar(
            leading: Container(),
            backgroundColor: Colors.black87,
            title: const Text('verification_title'),
          ),
          body: Padding(
            padding: EdgeInsets.all(mediumPading),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'renewal_link',
                  style: TextStyle(fontSize: mediumPading),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: mediumPading),
                MaterialButton(
                  color: kPrimaryColor,
                  onPressed: canResendEmail ? sendVerificationEmail : null,
                  child: Row(
                      children: const [Icon(Icons.email), Text('send_again')]),
                ),
                MaterialButton(
                  color: Colors.transparent,
                  onPressed: () => FirebaseAuth.instance.signOut(),
                  child: const Text('cancel'),
                ),
              ],
            ),
          ),
        );
}
