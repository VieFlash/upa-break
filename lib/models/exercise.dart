import 'settings.dart';

class Exercise {
  final String id;
  final String name;
  final BodyArea area;
  final int seconds;
  final List<String> steps;

  const Exercise({
    required this.id,
    required this.name,
    required this.area,
    required this.seconds,
    required this.steps,
  });
}
