import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bitirmeprojesi/login.dart';

class UserName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: MaterialApp(
        title: 'My App',
        home: LoginPage(),
      ),
    );
  }
}

class UserProvider extends ChangeNotifier {
  String _username = '';

  String get username => _username;

  void setUsername(String username) {
    _username = username;
    notifyListeners();
  }
}