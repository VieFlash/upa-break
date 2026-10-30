import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'mascot_rig.g.dart';

/// Upa chuyển động: mỗi trạng thái tách thành nhiều lớp SVG (sinh từ tool/gen_mascot.py, khung 256x256)
/// và mỗi lớp có transform/opacity theo thời gian.
///
/// - fresh:   thở, đầu lắc lư nhẹ, chớp mắt, bong bóng nổi lên.
/// - slouch:  thở dài nặng nề, đầu gục dần, giọt mồ hôi chảy xuống.
/// - sleepy:  thở, gật gù, bong bóng mũi phồng/xẹp, chữ z bay lên.
/// - stretch: nhún nhảy, tay chữ V lắc lắc, bảng HAPPY đung đưa, sao lấp lánh.
/// - proud:   gật đầu tự hào + nhún, sao lấp lánh.
/// - bell:    (onboarding xin quyền) lắc chuông leng keng từng đợt, vạch "ding" chớp theo, chớp mắt.
class UpaRig extends StatefulWidget {
  const UpaRig({super.key, required this.state, this.size = 220});

  /// Tên trạng thái trong [rigSpecs]: fresh | slouch | sleepy | stretch | proud.
  final String state;
  final double size;

  @override
  State<UpaRig> createState() => _UpaRigState();
}

class _UpaRigState extends State<UpaRig> with SingleTickerProviderStateMixin {
  static const _dir = 'assets/mascot/rig';
  static const _deg = math.pi / 180;

  final _time = ValueNotifier<double>(0);
  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    // tạo + start ngay (không để late lazy: nếu chỉ dispose() chạm tới thì ticker không bao giờ chạy)
    _ticker = createTicker((e) => _time.value = e.inMicroseconds / 1e6)..start();
  }
  late Map<String, Widget> _pictures = _load();

  RigSpec get _spec => rigSpecs[widget.state]!;

  Map<String, Widget> _load() => {
        for (final l in _spec.layers)
          l: SvgPicture.asset('$_dir/${widget.state}_$l.svg', width: widget.size, height: widget.size),
        if (widget.state == 'sleepy') 'z': SvgPicture.asset('$_dir/z.svg'),
      };

  @override
  void didUpdateWidget(covariant UpaRig old) {
    super.didUpdateWidget(old);
    if (old.state != widget.state || old.size != widget.size) _pictures = _load();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _time.dispose();
    super.dispose();
  }

  // ---------- helpers (toạ độ trong khung 256) ----------

  /// 0 → 1 → 0, mỗi chiều [half] giây, có ease in-out (nhịp thở).
  static double _wave(double t, double half) {
    final v = (t / half) % 2;
    return Curves.easeInOut.transform(v < 1 ? v : 2 - v);
  }

  static double _sin(double t, double period, [double phase = 0]) => math.sin(2 * math.pi * t / period + phase);

  /// Fade vào trong [inEnd] đầu chu kỳ, fade ra từ [outStart] (phase 0..1).
  static double _fade(double p, {double inEnd = .15, double outStart = .75}) =>
      (p < inEnd ? p / inEnd : (p > outStart ? (1 - p) / (1 - outStart) : 1.0)).clamp(0.0, 1.0);

  Matrix4 _about(Offset pivot, {double angle = 0, double sx = 1, double sy = 1, Offset shift = Offset.zero}) {
    final k = widget.size / 256;
    final p = pivot * k;
    return Matrix4.identity()
      ..translateByDouble(p.dx + shift.dx * k, p.dy + shift.dy * k, 0, 1)
      ..rotateZ(angle)
      ..scaleByDouble(sx, sy, 1, 1)
      ..translateByDouble(-p.dx, -p.dy, 0, 1);
  }

  // ---------- chuyển động theo trạng thái ----------

  /// Transform + opacity của từng lớp tại thời điểm [t] (giây).
  ({Matrix4 m, double opacity}) _pose(String layer, double t) {
    final s = _spec;
    final id = Matrix4.identity();
    final ground = const Offset(128, 248);
    switch (widget.state) {
      case 'fresh':
        final b = _wave(t, 2.2);
        // đầu chỉ hạ xuống khi thở ra (không nhô lên: đỉnh nón đã sát mép trên)
        final head = _about(s.neck, angle: 1.5 * _deg * _sin(t, 4.4), shift: Offset(0, 2 * (1 - b)));
        return switch (layer) {
          'body' => (m: _about(ground, sx: 1 + .01 * b, sy: 1 + .02 * b), opacity: 1),
          'head' => (m: head, opacity: 1),
          'eyes' => (m: head * _about(s.eyes, sy: _blink(t)), opacity: 1),
          _ => _fx(layer, t, id),
        };
      case 'slouch':
        final b = _wave(t, 3.0);
        // gục thêm sang trái; dịch phải bù để mang trái không lố mép
        final head = _about(s.neck, angle: -2 * _deg * b, shift: Offset(3 * b, 2.5 * b));
        return switch (layer) {
          'body' => (m: _about(ground, sx: 1 + .015 * b, sy: 1 - .02 * b), opacity: 1),
          'head' => (m: head, opacity: 1),
          _ => _fx(layer, t, id),
        };
      case 'sleepy':
        final b = _wave(t, 3.2); // 0 = thở ra, 1 = hít vào
        final head = _about(s.neck, angle: (1.5 - 3.5 * b) * _deg, shift: Offset(0, -4 * b));
        return switch (layer) {
          'body' => (m: _about(ground, sx: 1 + .012 * b, sy: 1 + .03 * b), opacity: 1),
          'head' => (m: head, opacity: 1),
          // bong bóng mũi: phồng to khi thở ra, xẹp khi hít vào
          'bubble' => (m: head * _about(s.nose, sx: 1.15 - .8 * b, sy: 1.15 - .8 * b), opacity: 1),
          _ => (m: id, opacity: 1),
        };
      case 'stretch':
        final beat = .5 + .5 * _sin(t, 1.6); // nhún nhảy
        final head = _about(s.neck, angle: 2.5 * _deg * _sin(t, 1.6, math.pi / 2), shift: Offset(0, -2 * beat));
        return switch (layer) {
          'body' => (m: _about(ground, sx: 1 + .01 * beat, sy: 1 + .02 * beat), opacity: 1),
          'head' => (m: head, opacity: 1),
          // tay chữ V lắc lắc nhanh, bảng đung đưa về phía nón (không văng ra mép phải)
          'vhand' => (m: _about(s.leftShoulder, angle: 8 * _deg * _sin(t, .8)), opacity: 1),
          'sign' => (m: _about(s.rightShoulder, angle: -3.5 * _deg * (.5 + .5 * _sin(t, 1.6, math.pi))), opacity: 1),
          _ => _fx(layer, t, id),
        };
      case 'bell':
        final b = _wave(t, 2.2);
        final head = _about(s.neck, angle: 2 * _deg * _sin(t, 2.4), shift: Offset(0, 2 * (1 - b)));
        return switch (layer) {
          'body' => (m: _about(ground, sx: 1 + .01 * b, sy: 1 + .02 * b), opacity: 1),
          'head' => (m: head, opacity: 1),
          'eyes' => (m: head * _about(s.eyes, sy: _blink(t)), opacity: 1),
          'bell' => (m: _about(s.leftShoulder, angle: 9 * _deg * _ring(t) * _sin(t, .3)), opacity: 1),
          _ => _fx(layer, t, id),
        };
      case 'proud':
        final nod = math.pow(math.sin(math.pi * t / 1.2), 2).toDouble(); // gật đầu "hehe"
        final head = _about(s.neck, angle: 2 * _deg * _sin(t, 2.4), shift: Offset(0, 3 * nod));
        return switch (layer) {
          'body' => (m: _about(ground, sx: 1 + .015 * nod, sy: 1 - .025 * nod), opacity: 1),
          'head' => (m: head, opacity: 1),
          _ => _fx(layer, t, id),
        };
    }
    return (m: id, opacity: 1);
  }

  /// Lịch chớp mắt ngẫu nhiên: cách nhau 2.5-6 giây, khoảng 1/4 số lần chớp đôi. Sinh sẵn một chu kỳ dài
  /// (seed cố định, lặp lại sau ~4 phút) để mỗi khung hình chỉ cần tra, không tạo số ngẫu nhiên.
  static final List<(double, bool)> _blinkPlan = () {
    final r = math.Random(20261030);
    var at = 1.5;
    return [
      for (var i = 0; i < 60; i++)
        (at += 2.5 + r.nextDouble() * 3.5, r.nextDouble() < .25),
    ];
  }();
  static final double _blinkCycle = _blinkPlan.last.$1 + 3;

  /// Độ mở mắt (1 = mở, ~0.1 = nhắm) tại thời điểm [t].
  static double _blink(double t) {
    final p = t % _blinkCycle;
    double one(double start) {
      final q = (p - start) / .16;
      return (q >= 0 && q <= 1) ? 1 - .9 * math.sin(q * math.pi) : 1;
    }

    var open = 1.0;
    for (final (start, twice) in _blinkPlan) {
      if (start > p) break;
      if (p - start > .6) continue;
      open = math.min(open, math.min(one(start), twice ? one(start + .25) : 1));
    }
    return open;
  }

  /// Độ mạnh của đợt lắc chuông: lắc 1.2 giây rồi nghỉ 1.2 giây (0 = đứng yên).
  static double _ring(double t) {
    final q = (t % 2.4) / 1.2;
    return q < 1 ? math.sin(math.pi * q) : 0;
  }

  /// Hiệu ứng: bong bóng nổi lên, sao lấp lánh, mồ hôi chảy xuống, vạch "ding" của chuông.
  ({Matrix4 m, double opacity}) _fx(String layer, double t, Matrix4 id) {
    if (layer == 'shadow' || !layer.startsWith('fx')) return (m: id, opacity: 1);
    final i = int.parse(layer.substring(2));
    final fx = _spec.fx[i];
    switch (fx.kind) {
      case 'bub':
        final p = (t / 3.0 + i * .45) % 1;
        return (
          m: _about(fx.at, sx: .7 + .3 * p, sy: .7 + .3 * p, shift: Offset(2.5 * math.sin(p * 2 * math.pi), 8 - 16 * p)),
          opacity: _fade(p),
        );
      case 'star':
        final tw = .5 + .5 * _sin(t, 1.3, i * 2.1);
        return (m: _about(fx.at, angle: 20 * _deg * (tw - .5), sx: .55 + .45 * tw, sy: .55 + .45 * tw), opacity: .55 + .45 * tw);
      case 'ding':
        final r = _ring(t);
        final pulse = .5 + .5 * _sin(t, .3, i * math.pi).abs();
        return (m: _about(fx.at, sx: .7 + .3 * r, sy: .7 + .3 * r), opacity: (r * pulse).clamp(0.0, 1.0));
      case 'sweat':
        final p = (t / 2.4) % 1;
        return (m: _about(fx.at, sx: 1 - .1 * p, sy: 1 + .15 * p, shift: Offset(0, 12 * p * p)), opacity: _fade(p, inEnd: .1, outStart: .65));
    }
    return (m: id, opacity: 1);
  }

  Widget _z(double phase) {
    final k = widget.size / 256;
    final t = Curves.easeOut.transform(phase);
    final pos = Offset.lerp(zStart, zEnd, t)! + Offset(math.sin(phase * math.pi * 2) * 4, 0);
    final box = (zSize + zPad * 2) * k;
    return Positioned(
      left: (pos.dx - zPad) * k,
      top: (pos.dy - zPad) * k,
      width: box,
      height: box,
      child: Opacity(
        opacity: _fade(phase, inEnd: .2, outStart: .7),
        child: Transform.rotate(
          angle: (-12 + 18 * phase) * _deg,
          child: Transform.scale(scale: .45 + .65 * t, child: _pictures['z']),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
      return SvgPicture.asset('assets/mascot/mascot_${widget.state}.svg', width: widget.size, height: widget.size);
    }
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: ValueListenableBuilder<double>(
        valueListenable: _time,
        builder: (context, t, _) => Stack(
          clipBehavior: Clip.none,
          children: [
            for (final l in _spec.layers)
              if (_pose(l, t) case (:final m, :final opacity))
                Opacity(opacity: opacity, child: Transform(transform: m, child: _pictures[l])),
            if (widget.state == 'sleepy')
              for (var i = 0; i < 3; i++) _z((t / 4.2 + i / 3) % 1),
          ],
        ),
      ),
    );
  }
}
