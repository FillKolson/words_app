import 'package:flutter_test/flutter_test.dart';
import 'package:words_app/utils/validators.dart';

void main() {
  group('Password Validation', () {
    test('should reject empty password', () {
      expect(validatePassword(''), isNotEmpty);
    });

    test('should reject password shorter than 6 characters', () {
      expect(validatePassword('Abc1'), isNotEmpty);
    });

    test('should reject password without uppercase letter', () {
      expect(validatePassword('abc1234'), isNotEmpty);
    });

    test('should reject password without digit', () {
      expect(validatePassword('Abcdef'), isNotEmpty);
    });

    test('should accept valid password', () {
      expect(validatePassword('ValidPass1'), isEmpty);
    });

    test('should accept password with exactly 6 characters if valid', () {
      expect(validatePassword('Pass1A'), isEmpty);
    });
  });

  group('Email Validation', () {
    test('should accept valid email', () {
      expect(isValidEmail('user@example.com'), true);
    });

    test('should accept email with numbers', () {
      expect(isValidEmail('user123@test.com'), true);
    });

    test('should reject email without @', () {
      expect(isValidEmail('userexample.com'), false);
    });

    test('should reject email without domain', () {
      expect(isValidEmail('user@'), false);
    });

    test('should reject empty string', () {
      expect(isValidEmail(''), false);
    });

    test('should reject email with spaces', () {
      expect(isValidEmail('user @example.com'), false);
    });
  });

  group('Word Validation', () {
    test('should accept valid English word', () {
      expect(isValidWord('hello'), true);
    });

    test('should accept multi-word phrase', () {
      expect(isValidWord('Hello World'), true);
    });

    test('should reject empty word', () {
      expect(isValidWord(''), false);
    });

    test('should reject word with numbers', () {
      expect(isValidWord('hello123'), false);
    });

    test('should reject word with special characters', () {
      expect(isValidWord('hello!'), false);
    });

    test('should reject very long word (>100 chars)', () {
      expect(isValidWord('a' * 101), false);
    });

    test('should accept word exactly 100 characters', () {
      expect(isValidWord('a' * 100), true);
    });
  });

  group('Difficulty Validation', () {
    test('should accept difficulty 1', () {
      expect(isValidDifficulty(1), true);
    });

    test('should accept difficulty 5', () {
      expect(isValidDifficulty(5), true);
    });

    test('should accept all difficulties 1-5', () {
      for (int i = 1; i <= 5; i++) {
        expect(isValidDifficulty(i), true);
      }
    });

    test('should reject difficulty 0', () {
      expect(isValidDifficulty(0), false);
    });

    test('should reject difficulty 6', () {
      expect(isValidDifficulty(6), false);
    });

    test('should reject negative difficulty', () {
      expect(isValidDifficulty(-1), false);
    });
  });
}
