// import 'package:almoktar/screens/auth/login.dart';
// import 'package:almoktar/screens/auth/signup.dart';
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:flutter/material.dart';

// class MainScreen extends StatefulWidget {
//   @override
//   _MainScreenState createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   int _page = 0;
//   final List<Widget> _pages = [
//     LoginPage(),
//     SignUpPage(),
//     SettingsScreen(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_page],
//       bottomNavigationBar: CurvedNavigationBar(
//         backgroundColor: Colors.white,
//         color: Color(0xFF8E2DE2),
//         buttonBackgroundColor: Color(0xFFFFA500),
//         height: 75,
//         items: <Widget>[
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.home, size: 30, color: Colors.white),
//               if (_page == 0)
//                 Text(
//                   "home",
//                   style: TextStyle(color: Colors.white, fontSize: 12),
//                 ),
//             ],
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.folder, size: 30, color: Colors.white),
//               if (_page == 1)
//                 Text(
//                   "folder",
//                   style: TextStyle(color: Colors.white, fontSize: 12),
//                 ),
//             ],
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.cloud, size: 30, color: Colors.white),
//               if (_page == 2)
//                 Text(
//                   "cloud",
//                   style: TextStyle(color: Colors.white, fontSize: 12),
//                 ),
//             ],
//           ),
//         ],
//         animationCurve: Curves.easeInOut,
//         animationDuration: Duration(milliseconds: 600),
//         onTap: (index) {
//           setState(() {
//             _page = index;
//           });
//         },
//       ),
//     );
//   }
// }

// class SettingsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("SettingsScreen")),
//       body: Center(child: Text(" Setting")),
//     );
//   }
// }
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
import 'package:almoktar/cubits/theme/theme_cubit.dart';
import 'package:almoktar/screens/app/FoodPage.dart';
import 'package:almoktar/screens/auth/login.dart';
import 'package:almoktar/screens/auth/signup.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _page = 0;
  final List<Widget> _pages = [
    FoodPage(),
    SignUpPage(),
    SettingsScreen(),
    LoginPage(),
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
            height: 75,
            items: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.home,
                    size: 30,
                    color: themeData.colorScheme.onPrimary,
                  ),
                  // if (_page == 0)
                  //   Text(
                  //     "home",
                  //     style: TextStyle(
                  //       color: themeData.colorScheme.onPrimary,
                  //       fontSize: 12,
                  //     ),
                  //   ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart,
                    size: 30,
                    color: themeData.colorScheme.onPrimary,
                  ),
                  // if (_page == 1)
                  //   Text(
                  //     "shoping",
                  //     style: TextStyle(
                  //       color: themeData.colorScheme.onPrimary,
                  //       fontSize: 12,
                  //     ),
                  //   ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite,
                    size: 30,
                    color: themeData.colorScheme.onPrimary,
                  ),
                  // if (_page == 2)
                  //   Text(
                  //     "favorite",
                  //     style: TextStyle(
                  //       color: themeData.colorScheme.onPrimary,
                  //       fontSize: 12,
                  //     ),
                  //   ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person,
                    size: 30,
                    color: themeData.colorScheme.onPrimary,
                  ),
                  // if (_page == 2)
                  // Text(
                  //   "person",
                  //   style: TextStyle(
                  //     color: themeData.colorScheme.onPrimary,
                  //     fontSize: 12,
                  //   ),
                  // ),
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
        child: Text(
          "Setting",
          style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
        ),
      ),
    );
  }
}
//////////////////////////////////////////////////////////////////////////

// import 'package:almoktar/cubits/theme/theme_cubit.dart';
// import 'package:almoktar/screens/auth/login.dart';
// import 'package:almoktar/screens/auth/signup.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';

// class MainScreen extends StatefulWidget {
//   @override
//   _MainScreenState createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   int _page = 0;
//   final List<Widget> _pages = [LoginPage(), SignUpPage(), SettingsScreen()];

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ThemeCubit, ThemeState>(
//       builder: (context, state) {
//         final theme = Theme.of(context);
//         final primaryColor = theme.colorScheme.primary;
//         final secondaryColor = theme.colorScheme.secondary;
//         final onPrimary = theme.colorScheme.onPrimary;

//         return Scaffold(
//           body: _pages[_page],
//           bottomNavigationBar: CurvedNavigationBar(
//             backgroundColor: theme.scaffoldBackgroundColor,
//             color: primaryColor,
//             buttonBackgroundColor: secondaryColor,
//             height: 75,
//             items: <Widget>[
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.home, size: 30, color: onPrimary),
//                   if (_page == 0)
//                     Text(
//                       "home",
//                       style: TextStyle(color: onPrimary, fontSize: 12),
//                     ),
//                 ],
//               ),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.folder, size: 30, color: onPrimary),
//                   if (_page == 1)
//                     Text(
//                       "folder",
//                       style: TextStyle(color: onPrimary, fontSize: 12),
//                     ),
//                 ],
//               ),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.cloud, size: 30, color: onPrimary),
//                   if (_page == 2)
//                     Text(
//                       "cloud",
//                       style: TextStyle(color: onPrimary, fontSize: 12),
//                     ),
//                 ],
//               ),
//             ],
//             animationCurve: Curves.easeInOut,
//             animationDuration: Duration(milliseconds: 600),
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

// class SettingsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("SettingsScreen")),
//       body: Center(child: Text("Setting")),
//     );
//   }
// }
