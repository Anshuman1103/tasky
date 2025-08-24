import 'package:flutter/material.dart';
import 'package:tasky/screens/login_page.dart';
import 'package:tasky/screens/register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLoginPage = false;

  void toggleLoginPage() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(showRegisterPage: toggleLoginPage);
    } else {
      return RegisterPage(showLoginPage: toggleLoginPage);
    }
  }
}
