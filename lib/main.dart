
import 'package:almoktar/cubits/theme/theme_cubit.dart';
import 'package:almoktar/screens/app/homepage.dart';
import 'package:almoktar/screens/auth/login.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'blocs/bloc_observer.dart';
import 'blocs/cubit_app/cubit.dart';
import 'network/dio_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeCubit = ThemeCubit();
  await themeCubit.getTheme();
  Bloc.observer=MyBlocObserver();
  DioHelper.init();


  runApp(MyApp(themeCubit));
}

class MyApp extends StatelessWidget {
  final ThemeCubit themeCubit;

  MyApp(this.themeCubit);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) =>AppCubit()),

      ],
      child: BlocProvider.value(
        value: themeCubit,
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            final themeData = themeCubit.themeData;
      
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'almoktar',
              theme: themeData,
              home: LoginPage(),
            );
          },
        ),
      ),
    );
  }
}
