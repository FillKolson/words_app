import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/word.dart';
import 'providers/word_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(WordAdapter());
  await Hive.openBox<Word>('words');

  final box = Hive.box<Word>('words');
  if (box.isEmpty) {
    box.add(Word(english: "Hello", ukrainian: "Привіт", nextReview: DateTime.now()));
    box.add(Word(english: "Thank you", ukrainian: "Дякую", nextReview: DateTime.now()));
    box.add(Word(english: "Love", ukrainian: "Любов", nextReview: DateTime.now()));
    box.add(Word(english: "House", ukrainian: "Дім", nextReview: DateTime.now()));
    box.add(Word(english: "Water", ukrainian: "Вода", nextReview: DateTime.now()));
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => WordProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Words App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple),
      home: const HomeScreen(),
    );
  }
}