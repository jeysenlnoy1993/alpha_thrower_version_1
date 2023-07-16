import 'package:alpha_thrower_version_1/game/menu.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Flame.device.fullScreen();
    Flame.device.setLandscape();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark().copyWith(
            textTheme: const TextTheme(
              headlineLarge: TextStyle(fontFamily: 'BungeeInline'),
              bodyLarge: TextStyle(fontFamily: 'BungeeInline'),
              labelLarge: TextStyle(fontFamily: 'BungeeInline'),
            ),
            scaffoldBackgroundColor: Colors.black),
        home: const MainMenu(
          key: Key('mainmenuid'),
        ));
  }
}
