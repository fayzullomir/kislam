import 'package:flutter/material.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/namaz_mock_data.dart';

/// Stylised silhouette of a worshipper in a given prayer pose. Mirrors
/// the design's PoseFigure SVG — minimal monochrome filled silhouette,
/// drawn into a 100×140 viewbox, then scaled by [size].
///
/// The whole figure uses [color] (which defaults to the active palette's
/// primary). Robe fill / skin fill are derived as opacity variants.
class PoseFigure extends StatelessWidget {
  final NamazPose pose;
  final double size;
  final Color color;

  const PoseFigure({
    super.key,
    required this.pose,
    this.size = 86,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size * 1.4),
      painter: _PoseFigurePainter(pose: pose, color: color),
    );
  }
}

class _PoseFigurePainter extends CustomPainter {
  final NamazPose pose;
  final Color color;

  _PoseFigurePainter({required this.pose, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    // Map 100x140 viewBox onto the actual canvas.
    final sx = size.width / 100;
    final sy = size.height / 140;
    canvas.scale(sx, sy);

    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final robeFill = Paint()
      ..color = color.withOpacity(0.18)
      ..style = PaintingStyle.fill;
    final skinFill = Paint()
      ..color = color.withOpacity(0.08)
      ..style = PaintingStyle.fill;
    final whiteFill = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final accentLine = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    switch (pose) {
      case NamazPose.standing:
        _robe(canvas, robeFill, stroke);
        _armsHanging(canvas, stroke);
        _feet(canvas, stroke);
        _capAndHead(canvas, cx: 50, cy: 26, whiteFill: whiteFill, accentLine: accentLine, skinFill: skinFill, stroke: stroke);
        break;
      case NamazPose.takbir:
        _robe(canvas, robeFill, stroke);
        _armsUpToEars(canvas, stroke);
        _feet(canvas, stroke);
        _capAndHead(canvas, cx: 50, cy: 26, whiteFill: whiteFill, accentLine: accentLine, skinFill: skinFill, stroke: stroke);
        break;
      case NamazPose.qiyom:
        _robe(canvas, robeFill, stroke);
        _handsFolded(canvas, robeFill, stroke);
        _feet(canvas, stroke);
        _capAndHead(canvas, cx: 50, cy: 26, whiteFill: whiteFill, accentLine: accentLine, skinFill: skinFill, stroke: stroke);
        break;
      case NamazPose.ruku:
        _ruku(canvas, robeFill, stroke, skinFill, whiteFill, accentLine);
        break;
      case NamazPose.sajda:
        _sajda(canvas, robeFill, stroke, skinFill, whiteFill, accentLine);
        break;
      case NamazPose.jalsa:
      case NamazPose.tashahhud:
        _sitting(canvas, robeFill, stroke, skinFill, whiteFill, accentLine, headCx: 50);
        break;
      case NamazPose.salom:
        _sitting(canvas, robeFill, stroke, skinFill, whiteFill, accentLine, headCx: 56);
        _salomArrow(canvas, accentLine);
        break;
    }
  }

  // ----- Reusable segments -----

  void _robe(Canvas canvas, Paint fill, Paint stroke) {
    final path = Path()
      ..moveTo(36, 38)
      ..quadraticBezierTo(36, 32, 50, 32)
      ..quadraticBezierTo(64, 32, 64, 38)
      ..lineTo(70, 120)
      ..lineTo(30, 120)
      ..close();
    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);
  }

  void _armsHanging(Canvas canvas, Paint stroke) {
    final p = Path()
      ..moveTo(38, 42)..lineTo(36, 80)
      ..moveTo(62, 42)..lineTo(64, 80);
    canvas.drawPath(p, stroke);
  }

  void _armsUpToEars(Canvas canvas, Paint stroke) {
    final p = Path()
      ..moveTo(38, 42)
      ..quadraticBezierTo(28, 40, 26, 24)
      ..lineTo(32, 22)
      ..moveTo(62, 42)
      ..quadraticBezierTo(72, 40, 74, 24)
      ..lineTo(68, 22);
    canvas.drawPath(p, stroke);
  }

  void _handsFolded(Canvas canvas, Paint fill, Paint stroke) {
    final p = Path()
      ..moveTo(38, 42)
      ..quadraticBezierTo(40, 58, 44, 64)
      ..quadraticBezierTo(50, 68, 56, 64)
      ..quadraticBezierTo(60, 58, 62, 42);
    canvas.drawPath(p, fill);
    canvas.drawPath(p, stroke);
  }

  void _feet(Canvas canvas, Paint stroke) {
    final p = Path()
      ..moveTo(38, 120)..lineTo(46, 124)
      ..moveTo(62, 120)..lineTo(54, 124);
    canvas.drawPath(p, stroke);
  }

  void _capAndHead(
    Canvas canvas, {
    required double cx,
    required double cy,
    required Paint whiteFill,
    required Paint accentLine,
    required Paint skinFill,
    required Paint stroke,
  }) {
    // Cap — small hemisphere on top of head
    final cap = Path()
      ..moveTo(cx - 9, cy - 8)
      ..quadraticBezierTo(cx, cy - 20, cx + 9, cy - 8)
      ..close();
    canvas.drawPath(cap, whiteFill);
    canvas.drawPath(cap, accentLine);
    // Head
    canvas.drawCircle(Offset(cx, cy), 9, skinFill);
    canvas.drawCircle(Offset(cx, cy), 9, stroke);
  }

  void _ruku(
    Canvas canvas,
    Paint robeFill,
    Paint stroke,
    Paint skinFill,
    Paint whiteFill,
    Paint accentLine,
  ) {
    // Legs
    final legs = Path()
      ..moveTo(36, 80)..lineTo(30, 124)
      ..moveTo(64, 80)..lineTo(70, 124);
    canvas.drawPath(legs, stroke);
    // Horizontal back / robe
    final back = Path()
      ..moveTo(28, 78)
      ..quadraticBezierTo(35, 70, 50, 70)
      ..quadraticBezierTo(65, 70, 72, 78)
      ..lineTo(70, 86)
      ..quadraticBezierTo(50, 80, 30, 86)
      ..close();
    canvas.drawPath(back, robeFill);
    canvas.drawPath(back, stroke);
    // Arms reaching down to knees
    final arms = Path()
      ..moveTo(32, 78)..lineTo(34, 100)
      ..moveTo(68, 78)..lineTo(66, 100);
    canvas.drawPath(arms, stroke);
    // Head out front
    _capAndHead(canvas, cx: 20, cy: 78, whiteFill: whiteFill, accentLine: accentLine, skinFill: skinFill, stroke: stroke);
    // Feet
    final feet = Path()
      ..moveTo(30, 124)..lineTo(38, 128)
      ..moveTo(70, 124)..lineTo(62, 128);
    canvas.drawPath(feet, stroke);
  }

  void _sajda(
    Canvas canvas,
    Paint robeFill,
    Paint stroke,
    Paint skinFill,
    Paint whiteFill,
    Paint accentLine,
  ) {
    // Legs folded
    final legs = Path()
      ..moveTo(56, 96)..lineTo(78, 124)..lineTo(60, 124)
      ..moveTo(44, 96)..lineTo(22, 124)..lineTo(40, 124);
    canvas.drawPath(legs, robeFill);
    canvas.drawPath(legs, stroke);
    // Arched back
    final back = Path()
      ..moveTo(28, 110)
      ..quadraticBezierTo(40, 80, 50, 90)
      ..quadraticBezierTo(60, 80, 72, 110)
      ..close();
    canvas.drawPath(back, robeFill);
    canvas.drawPath(back, stroke);
    // Arms to ground
    final arms = Path()
      ..moveTo(28, 108)..lineTo(18, 122)
      ..moveTo(72, 108)..lineTo(82, 122);
    canvas.drawPath(arms, stroke);
    // Head down
    _capAndHead(canvas, cx: 50, cy: 108, whiteFill: whiteFill, accentLine: accentLine, skinFill: skinFill, stroke: stroke);
  }

  void _sitting(
    Canvas canvas,
    Paint robeFill,
    Paint stroke,
    Paint skinFill,
    Paint whiteFill,
    Paint accentLine, {
    required double headCx,
  }) {
    // Folded legs underneath
    final legs = Path()
      ..moveTo(22, 124)
      ..quadraticBezierTo(30, 100, 50, 100)
      ..quadraticBezierTo(70, 100, 78, 124)
      ..close();
    canvas.drawPath(legs, robeFill);
    canvas.drawPath(legs, stroke);
    // Torso
    final torso = Path()
      ..moveTo(38, 60)
      ..quadraticBezierTo(38, 54, 50, 54)
      ..quadraticBezierTo(62, 54, 62, 60)
      ..lineTo(66, 102)
      ..lineTo(34, 102)
      ..close();
    canvas.drawPath(torso, robeFill);
    canvas.drawPath(torso, stroke);
    // Arms folded on lap
    final arms = Path()
      ..moveTo(38, 64)
      ..quadraticBezierTo(40, 84, 50, 86)
      ..quadraticBezierTo(60, 84, 62, 64);
    canvas.drawPath(arms, robeFill);
    canvas.drawPath(arms, stroke);
    // Head
    _capAndHead(canvas, cx: headCx, cy: 48, whiteFill: whiteFill, accentLine: accentLine, skinFill: skinFill, stroke: stroke);
  }

  void _salomArrow(Canvas canvas, Paint accentLine) {
    final p = Path()
      ..moveTo(72, 46)..lineTo(78, 46)
      ..moveTo(76, 43)..lineTo(79, 46)..lineTo(76, 49);
    canvas.drawPath(p, accentLine);
  }

  @override
  bool shouldRepaint(covariant _PoseFigurePainter old) =>
      old.pose != pose || old.color != color;
}
