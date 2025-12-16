import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:project/screens/add_screen.dart';
import 'package:project/screens/chat_screen.dart';
import 'package:project/screens/fav_screen.dart';
import 'package:project/screens/profile_screen.dart';
import 'package:project/screens/search_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PersistentTabController _controller =
  PersistentTabController(initialIndex: 1);

  List<Widget> _screens() {
    return const [
      ChatScreen(),
      SearchScreen(),
      AddScreen(),
      FavScreen(),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme ;

    return PersistentTabView(
      context,
      controller: _controller,
      screens: _screens(),
      items: [
        createBarIcon(iconPath: 'assets/icons/chat_icon.png', activeColor: cs.primary, inactiveColor: cs.tertiary.withAlpha(125)),
        createBarIcon(iconPath: 'assets/icons/search_icon.png', activeColor: cs.primary, inactiveColor: cs.tertiary.withAlpha(125)),
        createBarIcon(iconPath: 'assets/icons/add_icon.png', activeColor: cs.primary, inactiveColor: cs.tertiary.withAlpha(125)),
        createBarIcon(iconPath: 'assets/icons/fav_icon.png', activeColor: cs.primary, inactiveColor: cs.tertiary.withAlpha(125)),
        createBarIcon(iconPath: 'assets/icons/profile_icon.png', activeColor: cs.primary, inactiveColor: cs.tertiary.withAlpha(125)),
      ],
      navBarStyle: NavBarStyle.style12,
      backgroundColor: cs.onPrimary,

      // these are for helping the dots appear
      confineToSafeArea: true,
      hideNavigationBarWhenKeyboardAppears: true,
      navBarHeight: kBottomNavigationBarHeight,

      decoration: NavBarDecoration(
        border: Border(
          top: BorderSide(
            color: cs.primary.withAlpha(200),
            width: 2,
          ),
        ),
      ),

      animationSettings: const NavBarAnimationSettings(
        navBarItemAnimation: ItemAnimationSettings(
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimationSettings(
          animateTabTransition: true,
          duration: Duration(milliseconds: 200),
          screenTransitionAnimationType:
          ScreenTransitionAnimationType.slide,
        ),
      ),
    );

  }
}

PersistentBottomNavBarItem createBarIcon({required String iconPath, int size = 24,required Color activeColor, required Color inactiveColor }){
  PersistentBottomNavBarItem item = PersistentBottomNavBarItem(
      icon: ImageIcon(
        AssetImage(iconPath),
        size: 24,
      ),
      activeColorPrimary: activeColor,
      inactiveColorPrimary: inactiveColor,
      title: '' // if the text is null, the dots wont show
  );
  return item;
}
