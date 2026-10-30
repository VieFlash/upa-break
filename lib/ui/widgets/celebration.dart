import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Pháo giấy + sao lấp lánh bung từ phía trên rồi rơi xuống (một lần, ~2.8 giây) khi đạt mục tiêu ngày.
/// Vẽ bằng CustomPainter, màu theo bảng màu mascot; tắt khi máy bật "giảm chuyển động".
class Celebration extends StatefulWidget {
  const Celebration({super.key, this.pieces = 70, this.seed = 7});

  final int pieces;
  final int seed;

  @override
  State<Celebration> createState() => _CelebrationState();
}

class _CelebrationState extends State<Celebration> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 2800))..forward();
  late final List<_Piece> _pieces = _Piece.burst(widget.pieces, math.Random(widget.seed));

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) return const SizedBox.shrink();
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) => CustomPaint(painter: _ConfettiPainter(_pieces, _c.value), size: Size.infinite),
      ),
    );
  }
}

enum _Shape { strip, dot, star }

class _Piece {
  _Piece(this.shape, this.color, this.x0, this.y0, this.vx, this.vy, this.spin, this.size, this.delay);

  final _Shape shape;
  final Color color;
  final double x0, y0, vx, vy, spin, size, delay; // toạ độ theo tỉ lệ khung (0..1), vận tốc /giây

  // hồng mang, vàng sao, xanh dây thẻ, cam mũi tên, xanh lá, xanh bong bóng đậm
  static const _colors = [
    Color(0xFFFF5F8A), Color(0xFFFFD23F), Color(0xFF4F86FF), Color(0xFFFF7A45), Color(0xFF7FCF8A), Color(0xFF8FD3FF),
  ];

  static List<_Piece> burst(int n, math.Random r) => [
        for (var i = 0; i < n; i++)
          _Piece(
            i % 7 == 0 ? _Shape.star : (i % 3 == 0 ? _Shape.dot : _Shape.strip),
            _colors[i % _colors.length],
            .5 + (r.nextDouble() - .5) * .5, // bung từ khoảng giữa phía trên
            .05 + r.nextDouble() * .08,
            (r.nextDouble() - .5) * .9,
            -(.25 + r.nextDouble() * .45), // bắn lên trước rồi rơi xuống
            (r.nextDouble() - .5) * 12,
            6 + r.nextDouble() * 6,
            r.nextDouble() * .15,
          ),
      ];
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.pieces, this.t);

  final List<_Piece> pieces;
  final double t; // 0..1 trên 2.8 giây
  static const _duration = 2.8, _gravity = 1.1;
  static const _line = Color(0xFF5A2233);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in pieces) {
      final s = (t * _duration - p.delay).clamp(0.0, _duration);
      if (s <= 0) continue;
      final x = (p.x0 + p.vx * s + math.sin(s * 3 + p.spin) * .015) * size.width;
      final y = (p.y0 + p.vy * s + .5 * _gravity * s * s) * size.height;
      final fade = t < .75 ? 1.0 : (1 - t) / .25;
      final paint = Paint()..color = p.color.withValues(alpha: fade.clamp(0.0, 1.0));
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(p.spin * s);
      switch (p.shape) {
        case _Shape.strip:
          // dải giấy lật: co giãn chiều rộng theo thời gian để trông như đang xoay trong không khí
          final w = p.size * (.4 + .6 * math.cos(s * 9 + p.spin).abs());
          canvas.drawRRect(
              RRect.fromRectAndRadius(Rect.fromCenter(center: Offset.zero, width: w, height: p.size * 1.8),
                  const Radius.circular(2)),
              paint);
        case _Shape.dot:
          canvas.drawCircle(Offset.zero, p.size * .45, paint);
        case _Shape.star:
          // sao 4 cánh có viền như sao của mascot
          final r = p.size * 1.1;
          final path = Path()
            ..moveTo(0, -r)
            ..quadraticBezierTo(r * .2, -r * .2, r, 0)
            ..quadraticBezierTo(r * .2, r * .2, 0, r)
            ..quadraticBezierTo(-r * .2, r * .2, -r, 0)
            ..quadraticBezierTo(-r * .2, -r * .2, 0, -r)
            ..close();
          canvas.drawPath(path, paint);
          canvas.drawPath(
              path,
              Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 1.6
                ..strokeJoin = StrokeJoin.round
                ..color = _line.withValues(alpha: fade.clamp(0.0, 1.0)));
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.t != t;
}
