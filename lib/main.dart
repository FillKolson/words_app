import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/word.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(WordAdapter());
  await Hive.openBox<Word>('words');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WordProvider(),
      child: MaterialApp(
        title: 'Words App',
        theme: ThemeData.light().copyWith(
          primarySwatch: Colors.blue,
        ),
        darkTheme: ThemeData.dark().copyWith(
          primarySwatch: Colors.blue,
        ),
        themeMode: ThemeMode.system,
        home: HomeScreen(),
      ),
    );
  }
}