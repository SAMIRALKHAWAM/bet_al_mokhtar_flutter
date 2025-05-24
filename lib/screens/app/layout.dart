import 'package:almoktar/cubits/theme/theme_cubit.dart';
import 'package:almoktar/screens/app/CartPage.dart';
import 'package:almoktar/screens/app/FavPage.dart';
import 'package:almoktar/screens/app/FoodPage.dart';
import 'package:almoktar/screens/auth/ProfileFormPage.dart';
import 'package:almoktar/screens/auth/login.dart';
import 'package:almoktar/screens/auth/signup.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LayoutScreen extends StatefulWidget {
  @override
  _LayoutScreenState createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  int _page = 0;
  final List<Widget> _pages = [
    FoodPage(),
    CartPage(),
    // SettingsScreen(),
    FavoritesPage(),
    ProfileFormPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final themeCubit = context.read<ThemeCubit>();
        final themeData = themeCubit.themeData;

        return Scaffold(
          body: _pages[_page],
          bottomNavigationBar: CurvedNavigationBar(
            backgroundColor: themeData.scaffoldBackgroundColor,
            color: themeData.colorScheme.primary,
            buttonBackgroundColor: themeData.colorScheme.primary,
            height: 60,
            items: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.home,
                    size: 25,
                    color: themeData.colorScheme.onPrimary,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart,
                    size: 25,
                    color: themeData.colorScheme.onPrimary,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite,
                    size: 25,
                    color: themeData.colorScheme.onPrimary,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person,
                    size: 25,
                    color: themeData.colorScheme.onPrimary,
                  ),
                ],
              ),
            ],
            animationCurve: Curves.easeInOut,
            animationDuration: Duration(milliseconds: 600),
            onTap: (index) {
              setState(() {
                _page = index;
              });
            },
          ),
        );
      },
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SettingsScreen"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              "Setting",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            ListTile(
              leading: Icon(
                BlocProvider.of<ThemeCubit>(context).isDark
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),
              title: Text(
                'theme',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              onTap: () {
                // عند الضغط على Settings، تغيير الثيم
                BlocProvider.of<ThemeCubit>(context).switchTheme();
                // Navigator.pop(context); // إغلاق الـ Drawer بعد التغيير
              },
            ),
          ],
        ),
      ),
    );
  }
}
