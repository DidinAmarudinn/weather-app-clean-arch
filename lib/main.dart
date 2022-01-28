import 'package:clean_arch_with_provider/presentation/page/weather_page.dart';
import 'package:clean_arch_with_provider/presentation/provider/weather_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'injection.dart' as di;

void main() {
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WeatherProvider(
            currentWeather: di.locator(),
          ),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const WeatherPage(),
      ),
    );
  }
}
