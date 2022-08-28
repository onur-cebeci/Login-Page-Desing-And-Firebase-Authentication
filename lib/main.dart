import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_page/login_pages/auth_page.dart';
import 'package:login_page/login_pages/verify_email_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /*

  // if u are using FirebaseOptions ,You must should import

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


   */

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Fitness Time',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: const MainPage());
  }
}

class MainPage extends StatelessWidget {
  const MainPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('wrong'),
            );
          } else if (snapshot.hasData) {
            return const VerifyEmailPage();
          } else {
            return AuthPage();
          }
        },
      ),
    );
  }
}
