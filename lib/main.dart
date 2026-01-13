import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/auth_screen.dart';
import 'providers/word_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  // Register adapters here if you have custom Hive models
  // await Hive.openBox('words_box'); // open your boxes here
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => WordProvider())],
      child: MaterialApp(
        title: 'LinguaFlash',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.deepPurple,
        ),
        home: const AuthScreen(),
        routes: {'/auth': (_) => const AuthScreen()},
      ),
    );
  }
}
