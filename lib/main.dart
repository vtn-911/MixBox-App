import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mixboxapp/providers/user_provider.dart';
import 'package:mixboxapp/screens/signin_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  runApp(
    ChangeNotifierProvider(create: (_) => UserProvider(), child: const MyApp()),
  );
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
      home: const SigninScreen(),
    );
  }
}
