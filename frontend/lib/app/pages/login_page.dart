import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter_website_aaron/app/pages/home_page.dart';
import 'package:flutter_website_aaron/app/pages/pages_controllers/login_page_controller.dart';
import 'package:flutter_website_aaron/app/shared/app_design_system.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _controller = LoginPageController.instance;

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      // logo: const FlutterLogo(size: 100),
      title: AppNames.appName,
      navigateBackAfterRecovery: true,
      termsOfService: [
        TermOfService(
            id: 'general-term', mandatory: true, text: 'Terms of Service')
      ],
      scrollable: true,
      userValidator: (value) {
        if(value!.isEmpty) {
          return 'Please enter your e-email';
        }
        if(!value.contains('@') || !value.endsWith('.com')) {
          return 'Please enter a valid e-mail';
        }
        return null;
      },
      passwordValidator: (value) {
        if(value!.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
      onLogin: (loginData) async {
        _controller.emailController.text = loginData.name;
        _controller.passwordController.text = loginData.password;
        return await _controller.authenticate();
      },
      onSubmitAnimationCompleted: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      },
      onRecoverPassword: (String string) {
        return null;
      },
      headerWidget: const IntroWidget(),
      theme: LoginTheme(
        primaryColor: AppColors.primaryColor,
        accentColor: AppColors.whiteColor,
        errorColor: AppColors.errorColor,
        titleStyle: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 50,
        ),
        buttonStyle: const TextStyle(
            fontWeight: FontWeight.w800, color: AppColors.whiteColor),
        buttonTheme: const LoginButtonTheme(
          splashColor: AppColors.primaryColor,
          backgroundColor: AppColors.primaryColor,
          elevation: 5,
          highlightElevation: 5,
        ),
      ),
    );
  }
}

class IntroWidget extends StatelessWidget {
  const IntroWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: <Widget>[
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.only(right: 8.0, left: 8.0),
              child: Text('Authenticate'),
            ),
            Expanded(child: Divider()),
          ],
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
