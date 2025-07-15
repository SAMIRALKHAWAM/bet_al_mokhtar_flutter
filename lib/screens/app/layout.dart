import 'package:almoktar/cubits/theme/theme_cubit.dart';
import 'package:almoktar/screens/app/CartPage.dart';
import 'package:almoktar/screens/app/FavPage.dart';
import 'package:almoktar/screens/app/FoodPage.dart';
import 'package:almoktar/screens/auth/ProfileFormPage.dart';
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
    FavoritesPage(),
    ProfileFormPage(),
  ];

  final List<IconData> _icons = [
    Icons.home,
    Icons.shopping_cart,
    Icons.favorite,
    Icons.person,
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
            height: 50, // ارتفاع أقل لتخفيف الحجم
            items: List.generate(_icons.length, (index) {
              final isSelected = index == _page;
              return AnimatedContainer(
                duration: Duration(milliseconds: 250),
                padding: EdgeInsets.all(isSelected ? 3 : 1),
                child: Icon(
                  _icons[index],
                  size: isSelected ? 24 : 20, // حجم أصغر قليلاً
                  color: isSelected
                      ? Colors.white // لون مميز للأيقونة المحددة
                      : themeData.colorScheme.onPrimary.withOpacity(0.5), // لون أخف للأيقونات غير المحددة
                  shadows: isSelected
                      ? [
                    Shadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 3,
                      offset: Offset(0, 2),
                    )
                  ]
                      : null,
                ),
              );
            }),
            animationCurve: Curves.easeInOut,
            animationDuration: Duration(milliseconds: 400),
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
                BlocProvider.of<ThemeCubit>(context).switchTheme();
              },
            ),
          ],
        ),
      ),
    );
  }
}
