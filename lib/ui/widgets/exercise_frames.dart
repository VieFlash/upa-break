import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../models/exercise.dart';

/// Hình minh họa bài tập: các khung luân phiên mỗi [interval], chuyển mờ nhẹ giữa các khung.
class ExerciseFrames extends StatefulWidget {
  const ExerciseFrames({super.key, required this.exercise, this.size = 200, this.interval = const Duration(milliseconds: 1200)});

  final Exercise exercise;
  final double size;
  final Duration interval;

  @override
  State<ExerciseFrames> createState() => _ExerciseFramesState();
}

class _ExerciseFramesState extends State<ExerciseFrames> {
  Timer? _timer;
  int _i = 0;

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void didUpdateWidget(covariant ExerciseFrames old) {
    super.didUpdateWidget(old);
    if (old.exercise.id != widget.exercise.id) {
      _i = 0;
      _start();
    }
  }

  void _start() {
    _timer?.cancel();
    if (widget.exercise.frameAssets.length < 2) return;
    _timer = Timer.periodic(widget.interval, (_) {
      if (mounted) setState(() => _i = (_i + 1) % widget.exercise.frameAssets.length);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asset = widget.exercise.frameAssets[_i];
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        child: SvgPicture.asset(asset, key: ValueKey(asset), width: widget.size, height: widget.size),
      ),
    );
  }
}
