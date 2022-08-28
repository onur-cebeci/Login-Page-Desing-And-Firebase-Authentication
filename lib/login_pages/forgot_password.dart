import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_page/constant.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        elevation: 0,
        title: const Text('password_reset'),
      ),
      body: Container(
        color: Colors.black87,
        child: Padding(
          padding: EdgeInsets.all(mediumPading),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "password_for_email_address",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                SizedBox(height: mediumPading),
                TextFormField(
                  controller: emailController,
                  cursorColor: Colors.white,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    fillColor: Colors.transparent,
                    filled: true,
                  ),
                  textInputAction: TextInputAction.done,
                  validator: (email) =>
                      email != null && !EmailValidator.validate(email)
                          ? 'enter_valid_email_address'
                          : null,
                ),
                SizedBox(height: mediumPading),
                ElevatedButton.icon(
                  onPressed: () {
                    resetPassword();
                  },
                  icon: Icon(Icons.email_outlined),
                  label: const Text(
                    'password_reset',
                    style: TextStyle(fontSize: 24),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future resetPassword() async {
    String emailAnswerText = 'renewal_link';
    final snackBar = SnackBar(
      backgroundColor: Colors.white70,
      content: Text(
        emailAnswerText,
        style: const TextStyle(
            color: kLightColor, fontSize: 17, fontWeight: FontWeight.w400),
      ),
    );
    String warnText = 'renewal_link';
    final snackBarWarn = SnackBar(
      backgroundColor: Colors.white70,
      content: Text(
        warnText,
        style: const TextStyle(
            color: Colors.black87, fontSize: 19, fontWeight: FontWeight.w500),
      ),
    );

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(snackBarWarn);
    }
  }
}
