// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/word_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isFront = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Вивчення слів'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Consumer<WordProvider>(
        builder: (context, provider, _) {
          final word = provider.currentWord;

          if (word == null) {
            return const Center(
              child: Text(
                'Ура! На сьогодні все повторено 🎉',
                style: TextStyle(fontSize: 28),
                textAlign: TextAlign.center,
              ),
            );
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${provider.todayWords.indexOf(word) + 1} з ${provider.todayWords.length}',
                    style: const TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  const SizedBox(height: 40),

                  GestureDetector(
                    onTap: () => setState(() => _isFront = !_isFront),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 600),
                      transitionBuilder: (child, animation) => RotationYTransition(
                        turns: animation,
                        child: child,
                      ),
                      child: _isFront
                          ? _card(word.english, Colors.deepPurple[100]!)
                          : _card(word.ukrainian, Colors.green[100]!, key: const ValueKey('back')),
                    ),
                  ),

                  const SizedBox(height: 60),
                  const Text('Як добре пам’ятаєш?', style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [1, 2, 3, 4, 5].map((r) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: r <= 2 ? Colors.red : Colors.green,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(24),
                        ),
                        onPressed: () {
                          provider.rateCurrent(r);
                          setState(() => _isFront = true);
                        },
                        child: Text('$r', style: const TextStyle(fontSize: 26, color: Colors.white)),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 40),
                  LinearProgressIndicator(value: provider.progress / 100),
                  const SizedBox(height: 8),
                  Text('${provider.progress.toStringAsFixed(1)}% слів вивчено'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _card(String text, Color color, {Key? key}) {
    return Container(
      key: key,
      width: 340,
      height: 240,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(blurRadius: 12, color: Colors.black26)],
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// Остаточний helper для 3D-перевороту (без deprecated і без дзеркала)
class RotationYTransition extends AnimatedWidget {
  const RotationYTransition({
    Key? key,
    required Animation<double> turns,
    required this.child,
  }) : super(key: key, listenable: turns);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;
    final double turnsValue = animation.value;
    final bool isBackSide = turnsValue > 0.5;

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001) // перспектива
        ..rotateY(turnsValue * 3.14159)
        ..scaleByDouble(isBackSide ? -1.0 : 1.0, 1.0, 1.0, 1.0),
        child: child,
    );
  }
}
