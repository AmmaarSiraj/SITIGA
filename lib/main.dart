import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Untuk mengunci orientasi
import 'package:provider/provider.dart';
import 'components/splash_screen.dart';
import 'providers/data_provider.dart'; // Provider utama

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Mengunci orientasi ke portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataProvider()),
        // Tambahkan provider lain di sini kalau ada
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
