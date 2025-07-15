import 'package:almoktar/cubits/theme/theme_cubit.dart';
import 'package:almoktar/screens/app/CartPage.dart';
import 'package:almoktar/screens/app/FoodPage.dart';
import 'package:almoktar/screens/app/layout.dart';
import 'package:almoktar/screens/chief/chef_order.dart';
import 'package:almoktar/screens/waiter/table.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'blocs/bloc_observer.dart';
import 'blocs/cubit_app/cubit.dart';
import 'network/dio_helper.dart';

/// خلفية: استقبال الإشعارات في الخلفية
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('🔕 Background Message Received: ${message.notification?.title}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final themeCubit = ThemeCubit();
  await themeCubit.getTheme();

  Bloc.observer = MyBlocObserver();
  DioHelper.init();

  runApp(MyApp(themeCubit));
}

class MyApp extends StatefulWidget {
  final ThemeCubit themeCubit;

  MyApp(this.themeCubit);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeLocalNotifications();
    _setupFCM();
  }

  void _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _setupFCM() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ Notification permission granted');
    } else {
      print('⚠️ Notification permission declined');
    }

    String? token = await _firebaseMessaging.getToken();
    print('📱 FCM Token: $token');

    // Foreground إشعار أثناء التشغيل
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📩 Foreground Message: ${message.notification?.title}');
      _showLocalNotification(message);
    });

    // فتح الإشعار من الخلفية
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('📲 Notification Clicked: ${message.notification?.title}');
    });

    // فتح التطبيق من إشعار بارد
    RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      print('🚀 App Launched from Notification: ${initialMessage.notification?.title}');
    }
  }

  void _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Channel',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? 'بدون عنوان',
      message.notification?.body ?? 'بدون محتوى',
      platformDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (BuildContext context) => AppCubit())],
      child: BlocProvider.value(
        value: widget.themeCubit,
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            final themeData = widget.themeCubit.themeData;

            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'almoktar',
              theme: themeData,
              home: LayoutScreen(),
              // home: ProfileFormPage(),
              // home: TableBookingPage(),
              // home: OrderTrackingPage(),
              // home: OrderHistoryPage(),
            );
          },
        ),
      ),
    );
  }
}
