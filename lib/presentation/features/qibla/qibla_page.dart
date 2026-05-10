import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_design_tokens.dart';
import 'package:koreaislam/presentation/support/cubit/base_page.dart';

import 'qibla_cubit.dart';

@RoutePage()
class QiblaPage extends BasePage<QiblaCubit, QiblaState, QiblaEvent> {
  const QiblaPage({super.key});

  @override
  void onWidgetCreated(BuildContext context) {}

  @override
  Widget onWidgetBuild(BuildContext context, QiblaState state) {
    return Scaffold(
      backgroundColor: IslamicDesignTokens.neutral,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: IslamicDesignTokens.ink,
                  size: 26,
                ),
              ),
              const SizedBox(height: 16),
              Text(Strings.qiblaEyebrow, style: IslamicDesignTokens.tEyebrow),
              const SizedBox(height: 6),
              Text(Strings.qiblaTitle, style: IslamicDesignTokens.tDisplay),
              Expanded(
                child: Center(
                  child: _Compass(
                    degreesFromQibla: state.degreesFromQibla,
                  ),
                ),
              ),
              Center(
                child: Text(
                  '${state.degreesFromQibla}°',
                  style: const TextStyle(
                    fontFamily: IslamicDesignTokens.fontDisplay,
                    fontSize: 38,
                    fontWeight: FontWeight.w600,
                    color: IslamicDesignTokens.primary,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  state.isFacingMecca
                      ? Strings.qiblaFacing
                      : Strings.qiblaTurn,
                  style: IslamicDesignTokens.tBodySm,
                ),
              ),
              const SizedBox(height: 18),
              Center(
                child: _DistancePill(
                  city: state.city,
                  kmToMecca: state.kmToMecca,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Compass — outer ring with tick marks, N/E/S/W labels, green needle, and
// a gold-ringed Kaaba marker that floats at the Qibla bearing.
// ---------------------------------------------------------------------------

class _Compass extends StatelessWidget {
  final int degreesFromQibla;

  const _Compass({required this.degreesFromQibla});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background painter — ring + ticks + cardinal labels.
          CustomPaint(
            size: const Size.square(280),
            painter: _CompassDialPainter(),
          ),
          // Needle rotates around the center; positive value turns clockwise.
          Transform.rotate(
            angle: degreesFromQibla * math.pi / 180,
            child: CustomPaint(
              size: const Size.square(280),
              painter: _NeedlePainter(),
            ),
          ),
          // Center anchor disc.
          Container(
            width: 14,
            height: 14,
            decoration: const BoxDecoration(
              color: IslamicDesignTokens.ink,
              shape: BoxShape.circle,
            ),
          ),
          // Kaaba marker pinned to the top of the dial (= Qibla direction
          // when offset is zero). Real implementation would rotate this
          // by the device heading so it always points at Mecca.
          const Positioned(
            top: 4,
            child: _KaabaMarker(),
          ),
        ],
      ),
    );
  }
}

class _CompassDialPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerR = size.width / 2 - 2;
    final innerR = outerR - 22;

    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = IslamicDesignTokens.line;

    canvas.drawCircle(center, outerR, ringPaint);
    canvas.drawCircle(center, innerR, ringPaint);

    // Tick marks every 6° around the outer ring; longer ones every 30°.
    final tickPaint = Paint()
      ..color = IslamicDesignTokens.lineStrong
      ..strokeWidth = 1;

    for (var deg = 0; deg < 360; deg += 6) {
      final isMajor = deg % 30 == 0;
      final tickLen = isMajor ? 10.0 : 5.0;
      final rad = (deg - 90) * math.pi / 180;
      final p1 = Offset(
        center.dx + (outerR - 1) * math.cos(rad),
        center.dy + (outerR - 1) * math.sin(rad),
      );
      final p2 = Offset(
        center.dx + (outerR - tickLen) * math.cos(rad),
        center.dy + (outerR - tickLen) * math.sin(rad),
      );
      canvas.drawLine(p1, p2, tickPaint);
    }

    // Cardinal labels — N, E, S, W.
    const labels = {
      0: 'N',
      90: 'E',
      180: 'S',
      270: 'W',
    };
    final textStyle = TextStyle(
      fontFamily: IslamicDesignTokens.fontBody,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: IslamicDesignTokens.inkMuted,
    );
    labels.forEach((deg, label) {
      final rad = (deg - 90) * math.pi / 180;
      final pos = Offset(
        center.dx + (innerR - 18) * math.cos(rad),
        center.dy + (innerR - 18) * math.sin(rad),
      );
      // North uses primary green for emphasis.
      final style = deg == 0
          ? textStyle.copyWith(color: IslamicDesignTokens.primary)
          : textStyle;
      final tp = TextPainter(
        text: TextSpan(text: label, style: style),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, pos - Offset(tp.width / 2, tp.height / 2));
    });
  }

  @override
  bool shouldRepaint(covariant _CompassDialPainter oldDelegate) => false;
}

class _NeedlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final length = size.width / 2 - 32;

    final path = Path()
      ..moveTo(center.dx, center.dy - length)
      ..lineTo(center.dx + 14, center.dy)
      ..lineTo(center.dx, center.dy + 8)
      ..lineTo(center.dx - 14, center.dy)
      ..close();

    final paint = Paint()
      ..color = IslamicDesignTokens.primary
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _NeedlePainter oldDelegate) => false;
}

class _KaabaMarker extends StatelessWidget {
  const _KaabaMarker();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: IslamicDesignTokens.secondaryWash,
        shape: BoxShape.circle,
        border: Border.all(
          color: IslamicDesignTokens.secondary,
          width: 2,
        ),
      ),
      child: Container(
        width: 12,
        height: 12,
        color: IslamicDesignTokens.ink,
      ),
    );
  }
}

class _DistancePill extends StatelessWidget {
  final String city;
  final int kmToMecca;

  const _DistancePill({required this.city, required this.kmToMecca});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: IslamicDesignTokens.neutralSage,
        borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            city,
            style: IslamicDesignTokens.tBodySm.copyWith(
              color: IslamicDesignTokens.ink,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            _formatKm(kmToMecca),
            style: IslamicDesignTokens.tBodySm.copyWith(
              color: IslamicDesignTokens.ink,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatKm(int km) {
    final s = km.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return Strings.qiblaDistanceFormat(buf.toString());
  }
}
