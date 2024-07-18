import 'dart:math';

String generateRoomId() {
  const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const digits = '0123456789';
  final random = Random();

  String generateSegment(String characters, int length) {
    return String.fromCharCodes(
      Iterable.generate(length, (_) => characters.codeUnitAt(random.nextInt(characters.length)))
    );
  }

  String lettersPart = generateSegment(letters, 3);
  String digitsPart = generateSegment(digits, 3);

  return '$lettersPart$digitsPart';
}
