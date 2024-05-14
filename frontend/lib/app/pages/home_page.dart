import 'package:flutter/material.dart';
import 'package:flutter_website_aaron/app/components/loading_component.dart';
import 'package:flutter_website_aaron/app/pages/login_page.dart';
import 'package:flutter_website_aaron/app/pages/tabs/clients_page.dart';
import 'package:flutter_website_aaron/app/pages/tabs/members_page.dart';
import 'package:flutter_website_aaron/app/pages/tabs/transaction_history_page.dart';
import 'package:flutter_website_aaron/app/shared/app_design_system.dart';
import 'package:flutter_website_aaron/app/shared/storage.dart';
import 'package:flutter_website_aaron/app/shared/user_controller.dart';
import 'package:side_navigation/side_navigation.dart';

import '../components/dialog_component.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _userController = UserController.instance;
  bool _isLoading = true;

  int _selectedIndex = 0;
  final TextStyle optionStyle = const TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  final _views = <SideNavigationBarItem>[];
  final _defaultViews = [
    const SideNavigationBarItem(
        icon: Icons.history, label: 'Transaction History'),
    const SideNavigationBarItem(icon: Icons.logout, label: 'Logout'),
  ];

  final _widgetOptions = [];
  final _defaultWidgetOptions = const <Widget>[
    ClientsPage(),
    TransactionHistoryPage(),
  ];

  _initRequests() async {
    final currentUser = await _userController.getCurrentUser();
    final currentSeller = await _userController.getCurrentSellerName();

    setState(() {
      if (currentUser.sellerId == 0) {
        _views.add(
          const SideNavigationBarItem(
            icon: Icons.person,
            label: 'Members',
          ),
        );
        _widgetOptions.add(
          const MembersPage(),
        );
      }

      _views.add(
        SideNavigationBarItem(
          icon: Icons.account_balance,
          label: currentSeller,
        ),
      );
      _views.addAll(_defaultViews);
      _widgetOptions.addAll(_defaultWidgetOptions);
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _initRequests();
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
      body: _isLoading
          ? const LoadingComponent()
          : Row(
              children: [
                SideNavigationBar(
                  selectedIndex: _selectedIndex,
                  items: _views,
                  onTap: (index) {
                    if ((_views.length < 4 && index == 2) || index == 3) {
                      _showLogoutDialog();
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

  _showLogoutDialog() {
    // set up the AlertDialog
    final dialog = DialogComponent(
      title: 'Logout',
      content: 'Are you sure you want to exit the app?',
      onConfirm: () {
        StorageRepositor.remove(key: 'userId').then((value) {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        });
      },
      buttonConfirmText: 'Exit',
      isExitButton: true,
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (_) {
        return dialog;
      },
    );
  }
}
