import 'package:almoktar/cubits/Location/location_cubit.dart';
import 'package:almoktar/cubits/password_visibility/password_visibility_cubit.dart';
import 'package:almoktar/cubits/theme/theme_cubit.dart';
import 'package:almoktar/screens/app/CartPage.dart';
import 'package:almoktar/screens/app/FoodPage.dart';
import 'package:almoktar/screens/app/TableBookingPage.dart';
import 'package:almoktar/screens/app/layout.dart';
import 'package:almoktar/screens/app/scanner.dart';
import 'package:almoktar/screens/auth/CustomSplashScreen.dart';
import 'package:almoktar/screens/auth/login.dart';
import 'package:almoktar/screens/chief/chef_order.dart';
import 'package:almoktar/screens/delivery/TrackOrderPage.dart';
import 'package:almoktar/screens/delivery/delivery_order.dart';
import 'package:almoktar/screens/waiter/emp.dart';
import 'package:almoktar/screens/waiter/table.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'blocs/auth_cubit/cubit.dart';
import 'blocs/bloc_observer.dart';
import 'blocs/cubit_app/cubit.dart';
import 'network/cash_helper.dart';
import 'network/dio_helper.dart';
import 'network/end_point.dart';

/// خلفية: استقبال الإشعارات في الخلفية
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('🔕 Background Message Received: ${message.notification?.title}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final themeCubit = ThemeCubit();
  await themeCubit.getTheme();
  Widget startwidget;

  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CachHelper.init();

  if (CachHelper.getData(key: 'token') != null) {
    token = CachHelper.getData(key: 'token');
    role = CachHelper.getData(key: 'role');
    branch_id=CachHelper.getData(key: "branch_id");
    print(role);
    print(branch_id);

    role=="waiter"?
    startwidget = TablesScreen():
        role=="captain"?
        startwidget = ChefOrdersExpansionPanelPage():
        startwidget = DeliveryOrders();

  print(token);
  } else {
    startwidget = LoginPage();
  }

  print('');

  /// ✅ انشئ socket هنا
  final IO.Socket socket = IO.io(
    'http://localhost:5002', // استبدلها بعنوان السيرفر الحقيقي
    IO.OptionBuilder().setTransports(['websocket']).enableAutoConnect().build(),
  );

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translation',
      fallbackLocale: const Locale('en'),
      // child: MyApp(themeCubit,startwidget),
      child: MyApp(
        themeCubit,
        socket,
        startwidget, // مرر الـ socket للـ MyApp
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final ThemeCubit themeCubit;
  Widget startwidget;
  // MyApp(this.themeCubit,this.startwidget);
  final IO.Socket socket;
  MyApp(this.themeCubit, this.socket, this.startwidget);

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
    NotificationSettings settings =
        await _firebaseMessaging.requestPermission();

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
    RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      print(
        '🚀 App Launched from Notification: ${initialMessage.notification?.title}',
      );
    }
  }

  void _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
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
      providers: [
        BlocProvider(create: (BuildContext context) => AppCubit()),
        BlocProvider(create: (BuildContext context) => AuthCubit()),
        BlocProvider(create: (BuildContext context) => PasswordVisibilityCubit()),

        BlocProvider(
          create: (BuildContext context) => LocationCubit(widget.socket),
        ),
      ],

      child: BlocProvider.value(
        value: widget.themeCubit,
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            final themeData = widget.themeCubit.themeData;

            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'almoktar',
              theme: themeData,
              locale: context.locale,
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
              home:widget.startwidget,

              //  home: LayoutScreen(),
              // home: TrackOrderPage(),

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
