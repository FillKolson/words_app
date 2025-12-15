// lib/screens/lesson_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/word_provider.dart';
import '../models/task_type.dart';
import '../models/word.dart'; // <-- ВАЖНО: добавь правильный импорт модели Word

class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen>
    with TickerProviderStateMixin {
  TaskType _currentTaskType = TaskType.flipCard;
  bool _isFront = true;
  String _userInput = '';
  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    _chooseNewTask();
  }

  void _chooseNewTask() {
    setState(() {
      _currentTaskType = Provider.of<WordProvider>(
        context,
        listen: false,
      ).getRandomTaskType();
      _isFront = true;
      _userInput = '';
      _selectedOption = null;
    });
  }

  void _submitAnswer(bool isCorrect, int rating) {
    final provider = Provider.of<WordProvider>(context, listen: false);
    provider.rateCurrent(rating);
    if (provider.currentWord == null) {
      return; // все слова на сегодня изучены
    }
    _chooseNewTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Урок'), centerTitle: true),
      body: Consumer<WordProvider>(
        builder: (context, provider, _) {
          final word = provider.currentWord;
          if (word == null) {
            return const Center(
              child: Text(
                'Ура! На сьогодні все 🎉',
                style: TextStyle(fontSize: 28),
              ),
            );
          }

          // Случайное направление перевода
          final bool foreignToNative = provider
              .getRandomBool(); // используем публичный метод

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  '${provider.todayWords.indexOf(word) + 1} / ${provider.todayWords.length}',
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 30),

                // === ЗАДАНИЯ ===
                if (_currentTaskType == TaskType.flipCard) ...[
                  GestureDetector(
                    onTap: () => setState(() => _isFront = !_isFront),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 600),
                      transitionBuilder: (child, animation) {
                        // Простая Y-вращение анимация
                        final rotate = Tween(
                          begin: 0.0,
                          end: 1.0,
                        ).animate(animation);
                        return AnimatedBuilder(
                          animation: rotate,
                          builder: (_, child) {
                            final isFront = rotate.value <= 0.5;
                            final angle =
                                rotate.value * 3.14159; // π радиан = 180°
                            return Transform(
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..rotateY(angle),
                              alignment: Alignment.center,
                              child: isFront
                                  ? child!
                                  : Transform(
                                      transform: Matrix4.rotationY(3.14159),
                                      alignment: Alignment.center,
                                      child: child,
                                    ),
                            );
                          },
                          child: _isFront
                              ? _card(
                                  foreignToNative
                                      ? word.english
                                      : word.ukrainian,
                                  Colors.deepPurple[100]!,
                                )
                              : _card(
                                  foreignToNative
                                      ? word.ukrainian
                                      : word.english,
                                  Colors.green[100]!,
                                ),
                        );
                      },
                      child: _isFront
                          ? _card(
                              foreignToNative ? word.english : word.ukrainian,
                              Colors.deepPurple[100]!,
                              key: const ValueKey('front'),
                            )
                          : _card(
                              foreignToNative ? word.ukrainian : word.english,
                              Colors.green[100]!,
                              key: const ValueKey('back'),
                            ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  _ratingButtons(
                    () => _submitAnswer(true, 4),
                  ), // упрощённо, можно расширить
                ],

                if (_currentTaskType == TaskType.multipleChoice) ...[
                  Text(
                    'Оберіть правильний переклад:',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    foreignToNative ? word.english : word.ukrainian,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  RadioGroup<String?>(
                    groupValue: _selectedOption,
                    onChanged: (String? val) =>
                        setState(() => _selectedOption = val),
                    child: Column(
                      children: provider
                          .generateOptions(word, foreignToNative)
                          .map(
                            (option) => ListTile(
                              title: Text(
                                option,
                                style: const TextStyle(fontSize: 24),
                              ),
                              leading: Radio<String?>(
                                value: option,
                                // groupValue и onChanged НЕ передаём здесь — они управляются RadioGroup выше
                                toggleable:
                                    true, // позволяет снять выбор, если нужно
                              ),
                              onTap: () {
                                // Делаем выбор по тапу на весь тайл (как в старом RadioListTile)
                                setState(() {
                                  if (_selectedOption == option) {
                                    _selectedOption =
                                        null; // опционально: снять выбор при повторном тапе
                                  } else {
                                    _selectedOption = option;
                                  }
                                });
                              },
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _selectedOption == null
                        ? null
                        : () {
                            final correct = foreignToNative
                                ? word.ukrainian
                                : word.english;
                            final isCorrect = _selectedOption == correct;
                            _submitAnswer(
                              isCorrect,
                              provider.ratingFromCorrectness(isCorrect),
                            );
                          },
                    child: const Text(
                      'Перевірити',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],

                if (_currentTaskType == TaskType.typing) ...[
                  Text(
                    'Напишіть переклад:',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    foreignToNative ? word.english : word.ukrainian,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    autofocus: true,
                    textCapitalization: TextCapitalization.sentences,
                    style: const TextStyle(fontSize: 28),
                    onChanged: (val) => _userInput = val.trim(),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Ваш переклад...',
                    ),
                    onSubmitted: (_) =>
                        _checkTypingAnswer(word, foreignToNative, provider),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () =>
                        _checkTypingAnswer(word, foreignToNative, provider),
                    child: const Text(
                      'Перевірити',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],

                const Spacer(),
                LinearProgressIndicator(value: provider.progress / 100),
                Text('${provider.progress.toStringAsFixed(1)}% вивчено'),
              ],
            ),
          );
        },
      ),
    );
  }

  void _checkTypingAnswer(
    Word word,
    bool foreignToNative,
    WordProvider provider,
  ) {
    final correct = (foreignToNative ? word.ukrainian : word.english)
        .toLowerCase();
    final user = _userInput.toLowerCase();
    final isCorrect = user == correct;
    _submitAnswer(isCorrect, isCorrect ? 5 : 1);
  }

  Widget _card(String text, Color color, {Key? key}) {
    return Card(
      key: key,
      color: color,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        height: 200,
        width: double.infinity,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _ratingButtons(VoidCallback onEasy) {
    // Пример простых кнопок оценки (можно расширить до 1–5)
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(onPressed: onEasy, child: const Text('Легко')),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () => _submitAnswer(false, 1),
          child: const Text('Важко'),
        ),
      ],
    );
  }
}
