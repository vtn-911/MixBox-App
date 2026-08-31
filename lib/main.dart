import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mixboxapp/screens/signup_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Ép Status Bar thành trong suốt và hiện icon màu tối
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      // Trong suốt hoàn toàn
      statusBarIconBrightness: Brightness.dark,
      // Icon (pin, wifi) màu đen cho Android
      statusBarBrightness: Brightness.light, // Icon màu đen cho iOS
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(backgroundColor: Color(0xffF8F9FA)),
        scaffoldBackgroundColor: Color(0xffF8F9FA),
        textTheme: const TextTheme().apply(bodyColor: Colors.black),
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SignupScreen(),
    );
  }
}
