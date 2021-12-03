import 'package:flutter/material.dart';
import 'package:login/controllers/user_controller.dart';
import 'package:login/pages/home_page.dart';
import 'package:login/pages/login_page.dart';
import 'package:login/widgets/splash_loading_widget.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(builder: (context, userController, child) {
      switch (userController.authState) {
        case AuthState.signed:
          return HomePage();
        case AuthState.unsigned:
          return LoginPage();
        case AuthState.loading:
          return SplashLoadingWidget();
      }
    });
  }
}
