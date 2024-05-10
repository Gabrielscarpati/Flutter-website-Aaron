import 'package:flutter/material.dart';
import 'package:flutter_website_aaron/app/components/loading_component.dart';
import 'package:flutter_website_aaron/app/pages/login_page.dart';
import 'package:flutter_website_aaron/app/shared/storage.dart';

import 'app/pages/home_page.dart';

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
      home: FutureBuilder(
        initialData: const LoadingComponent(),
        future: Storage.tokenStorage.read(key: 'userId'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const LoginPage();
          }

          return const HomePage();
        },
      ),
    );
  }
}
