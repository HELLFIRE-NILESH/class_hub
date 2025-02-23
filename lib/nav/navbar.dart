import 'package:class_hub/pages/aiSearch/aiPage.dart';
import 'package:class_hub/pages/homePage.dart';
import 'package:class_hub/pages/samplePaper/paperPage.dart';
import 'package:class_hub/pages/userPage/userProfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';


import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../widgets/Exitdialog.dart';

class NavView extends StatefulWidget {
  const NavView({super.key});

  @override
  _NavViewState createState() => _NavViewState();
}

class _NavViewState extends State<NavView> {
  final storage = const FlutterSecureStorage();

  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop , result) async {
        if (didPop) return;

        bool shouldExit = await ExitDialog(isLogout: false).showExitDialog(context);

        if (shouldExit) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        bottomNavigationBar: SnakeNavigationBar.color(
          currentIndex: _currentIndex,
          backgroundColor: const Color(0xFF1E4D4D),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          snakeViewColor: const Color(0xFF1E4D4D),
          snakeShape: SnakeShape.indicator,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              _pageController.animateToPage(
                index,
                duration: Duration(milliseconds: 250),
                curve: Curves.easeInOut,
              );
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.home)),
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.chat_bubble)),
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.doc_richtext)),
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.person)),
          ],
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: const [
            HomePage(),
            ChatBotPage(),
            PreviousPaper(),
            UserProfile(),
          ],
        ),
      ),
    );
  }
}
