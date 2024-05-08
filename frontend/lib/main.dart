import 'package:flutter/material.dart';
import 'package:flutter_website_aaron/app/pages/login.dart';

void main() {
  runApp(const EDIDashApp());
}

class EDIDashApp extends StatelessWidget {
  const EDIDashApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EDI Dash',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage()
    );
  }
}