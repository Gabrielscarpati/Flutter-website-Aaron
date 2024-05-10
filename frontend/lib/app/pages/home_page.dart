import 'package:flutter/material.dart';
import 'package:flutter_website_aaron/app/pages/login_page.dart';
import 'package:flutter_website_aaron/app/pages/tabs/florida_tile_page.dart';
import 'package:flutter_website_aaron/app/pages/tabs/member_page.dart';
import 'package:flutter_website_aaron/app/pages/tabs/transaction_history_page.dart';
import 'package:flutter_website_aaron/app/shared/app_design_system.dart';
import 'package:flutter_website_aaron/app/shared/storage.dart';
import 'package:side_navigation/side_navigation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final TextStyle optionStyle = const TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  List<Widget> views = const [
    Center(
      child: Text('Members'),
    ),
    Center(
      child: Text('Florida Tile'),
    ),
    Center(
      child: Text('Transaction History'),
    ),
  ];

  final _widgetOptions = const <Widget>[
    MemberPage(),
    FloridaTilePage(),
    TransactionHistoryPage(),
    LoginPage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SideNavigationBar(
            selectedIndex: _selectedIndex,
            items: const [
              SideNavigationBarItem(
                icon: Icons.person,
                label: 'Members',
              ),
              SideNavigationBarItem(
                  icon: Icons.account_balance, label: 'Florida Tile'),
              SideNavigationBarItem(
                  icon: Icons.history, label: 'Transaction History'),
              SideNavigationBarItem(icon: Icons.logout, label: 'Logout'),
            ],
            onTap: (index) {
              if (index == 3) {
                Storage.tokenStorage.delete(key: 'userId').then((value) => {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      )
                    });
                return;
              }
              _onItemTapped(index);
            },
            theme: SideNavigationBarTheme(
              togglerTheme: SideNavigationBarTogglerTheme.standard(),
              itemTheme: SideNavigationBarItemTheme(
                selectedItemColor: AppColors.primaryColor,
                unselectedItemColor: Colors.grey,
              ),
              dividerTheme: SideNavigationBarDividerTheme.standard(),
            ),
            toggler: SideBarToggler(
                expandIcon: Icons.keyboard_arrow_right,
                shrinkIcon: Icons.keyboard_arrow_left,
                onToggle: () {
                  debugPrint('Toggle');
                }),
          ),
          Expanded(
            child: _widgetOptions.elementAt(_selectedIndex),
          )
        ],
      ),
    );
  }
}
