import 'package:almoktar/components/colors.dart';
import 'package:almoktar/cubits/theme/theme_cubit.dart';
import 'package:almoktar/screens/app/CartPage.dart';
import 'package:almoktar/screens/app/FavPage.dart';
import 'package:almoktar/screens/app/FoodPage.dart';
import 'package:almoktar/screens/auth/ProfileFormPage.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Setting.dart';

// class LayoutScreen extends StatefulWidget {
//   @override
//   _LayoutScreenState createState() => _LayoutScreenState();
// }
//
// class _LayoutScreenState extends State<LayoutScreen> {
//   int _page = 0;
//
//   final List<Widget> _pages = [
//     FoodPage(),
//     CartPage(),
//     FavoritesPage(),
//     SettingsPage(),
//   ];
//
//   final List<IconData> _icons = [
//     Icons.home,
//     Icons.shopping_cart,
//     Icons.favorite,
//     Icons.person,
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ThemeCubit, ThemeState>(
//       builder: (context, state) {
//         final themeCubit = context.read<ThemeCubit>();
//         final themeData = themeCubit.themeData;
//
//         return Scaffold(
//           body: _pages[_page],
//           bottomNavigationBar: CurvedNavigationBar(
//             backgroundColor: themeData.scaffoldBackgroundColor,
//             color: themeData.colorScheme.primary,
//             buttonBackgroundColor: themeData.colorScheme.primary,
//             height: 50, // ارتفاع أقل لتخفيف الحجم
//             items: List.generate(_icons.length, (index) {
//               final isSelected = index == _page;
//               return AnimatedContainer(
//                 duration: Duration(milliseconds: 250),
//                 padding: EdgeInsets.all(isSelected ? 3 : 1),
//                 child: Icon(
//                   _icons[index],
//                   size: isSelected ? 24 : 20, // حجم أصغر قليلاً
//                   color: isSelected
//                       ? Colors.white // لون مميز للأيقونة المحددة
//                       : themeData.colorScheme.onPrimary.withOpacity(0.5), // لون أخف للأيقونات غير المحددة
//                   shadows: isSelected
//                       ? [
//                     Shadow(
//                       color: Colors.black.withOpacity(0.2),
//                       blurRadius: 3,
//                       offset: Offset(0, 2),
//                     )
//                   ]
//                       : null,
//                 ),
//               );
//             }),
//             animationCurve: Curves.easeInOut,
//             animationDuration: Duration(milliseconds: 400),
//             onTap: (index) {
//               setState(() {
//                 _page = index;
//               });
//             },
//           ),
//         );
//       },
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:almoktar/cubits/theme/theme_cubit.dart';

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
    SettingsPage(),
  ];

  final List<IconData> _icons = [
    Icons.home,
    Icons.shopping_cart,
    Icons.favorite,
    Icons.person,
  ];

  final List<String> _labels = [
    'home',
    'cart',
    'fav',
    'setting',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final themeCubit = context.read<ThemeCubit>();
        final themeData = themeCubit.themeData;

        return Scaffold(
          body: _pages[_page],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _page,
            onTap: (index) {
              setState(() {
                _page = index;
              });
            },
            backgroundColor: Colors.white,
            selectedItemColor:ColorApp.color1,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            items: List.generate(_icons.length, (index) {
              return BottomNavigationBarItem(
                icon: Icon(_icons[index]),
                label: _labels[index],
              );
            }),
          ),
        );
      },
    );
  }
}
