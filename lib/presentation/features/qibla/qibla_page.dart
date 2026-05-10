import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_design_tokens.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/noor_tokens.dart';
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
      backgroundColor: context.noor.neutral,
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
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: context.noor.ink,
                  size: 26,
                ),
              ),
              const SizedBox(height: 16),
              Text(Strings.qiblaEyebrow, style: context.noor.tEyebrow),
              const SizedBox(height: 6),
              Text(Strings.qiblaTitle, style: context.noor.tDisplay),
              Expanded(child: _Body(state: state, page: this)),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Body — switches between the live compass and a status placeholder
// (loading / permission / no-sensor) based on [QiblaState.status].
// ---------------------------------------------------------------------------

class _Body extends StatelessWidget {
  final QiblaState state;
  final QiblaPage page;

  const _Body({required this.state, required this.page});

  @override
  Widget build(BuildContext context) {
    switch (state.status) {
      case QiblaStatus.initial:
      case QiblaStatus.loading:
        return _StatusView(
          icon: Icons.location_searching_rounded,
          message: Strings.qiblaLocating,
          showProgress: true,
        );
      case QiblaStatus.permissionDenied:
        return _StatusView(
          icon: Icons.location_off_rounded,
          message: Strings.qiblaPermissionDenied,
          actionLabel: Strings.qiblaRetry,
          onAction: () => page.cubit(context).retry(),
        );
      case QiblaStatus.permissionPermanentlyDenied:
        return _StatusView(
          icon: Icons.location_off_rounded,
          message: Strings.qiblaPermissionDenied,
          actionLabel: Strings.qiblaEnableLocation,
          onAction: () => page.cubit(context).openAppSettings(),
        );
      case QiblaStatus.serviceDisabled:
        return _StatusView(
          icon: Icons.gps_off_rounded,
          message: Strings.qiblaServiceDisabled,
          actionLabel: Strings.qiblaEnableLocation,
          onAction: () => page.cubit(context).openLocationSettings(),
        );
      case QiblaStatus.noCompass:
        return _StatusView(
          icon: Icons.explore_off_rounded,
          message: Strings.qiblaNoCompass,
        );
      case QiblaStatus.ready:
        return _CompassView(state: state);
    }
  }
}

class _CompassView extends StatefulWidget {
  final QiblaState state;
  const _CompassView({required this.state});

  @override
  State<_CompassView> createState() => _CompassViewState();
}

class _CompassViewState extends State<_CompassView> {
  /// Minimum heading change between rotation "ticks" (degrees).
  static const double _rotationTickStep = 15.0;

  /// Last heading at which a tick haptic fired — anchor for the next tick.
  double? _lastTickHeading;

  /// Was the dial inside the alignment zone on the previous frame?
  /// We only want one heavy haptic on the false → true transition,
  /// not a continuous buzz while the user holds the phone steady.
  bool _wasFacing = false;

  @override
  void didUpdateWidget(covariant _CompassView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _maybeFireHaptics(oldWidget.state, widget.state);
  }

  void _maybeFireHaptics(QiblaState prev, QiblaState curr) {
    // Lock-on signal: fire once when entering the "facing Mecca" zone.
    if (curr.isFacingMecca && !_wasFacing) {
      HapticFeedback.heavyImpact();
      // Re-anchor the tick heading so we don't immediately fire again
      // from accumulated rotation while approaching alignment.
      _lastTickHeading = curr.deviceHeading;
    }
    _wasFacing = curr.isFacingMecca;

    // Rotation ticks: subtle compass-like clicks while turning.
    // Skipped while inside the alignment zone — the lock-on haptic above
    // is the dominant signal there.
    if (curr.isFacingMecca) return;

    final last = _lastTickHeading;
    if (last == null) {
      _lastTickHeading = curr.deviceHeading;
      return;
    }

    final raw = (curr.deviceHeading - last).abs();
    // Shortest angular distance, accounting for the 0/360 seam.
    final delta = math.min(raw, 360 - raw);
    if (delta >= _rotationTickStep) {
      HapticFeedback.selectionClick();
      _lastTickHeading = curr.deviceHeading;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    return Column(
      children: [
        Expanded(
          child: Center(
            child: _Compass(
              deviceHeading: state.deviceHeading,
              qiblaBearing: state.qiblaBearing,
            ),
          ),
        ),
        Center(
          child: Text(
            '${state.degreesFromQiblaRounded}°',
            style: TextStyle(
              fontFamily: IslamicDesignTokens.fontDisplay,
              fontSize: 38,
              fontWeight: FontWeight.w600,
              color: context.noor.primary,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Center(
          child: Text(
            state.isFacingMecca ? Strings.qiblaFacing : Strings.qiblaTurn,
            style: context.noor.tBodySm,
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
    );
  }
}

class _StatusView extends StatelessWidget {
  final IconData icon;
  final String message;
  final bool showProgress;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _StatusView({
    required this.icon,
    required this.message,
    this.showProgress = false,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: context.noor.inkSoft),
            const SizedBox(height: 16),
            if (showProgress) ...[
              SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: context.noor.primary,
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.noor.tBodySm,
            ),
            if (actionLabel != null) ...[
              const SizedBox(height: 20),
              TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(
                  foregroundColor: context.noor.primary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(IslamicDesignTokens.radiusPill),
                    side: BorderSide(color: context.noor.primary, width: 1.4),
                  ),
                ),
                child: Text(
                  actionLabel!,
                  style: context.noor.tLabel.copyWith(
                    color: context.noor.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Compass — outer ring with tick marks, N/E/S/W labels rotating with the
// device heading (so N always points to true north), a fixed forward-facing
// indicator at the top, and a Kaaba marker pinned to the absolute Qibla
// bearing on the dial. User aligns the phone with the Kaaba marker to face
// Mecca.
// ---------------------------------------------------------------------------

class _Compass extends StatelessWidget {
  final double deviceHeading;
  final double qiblaBearing;

  const _Compass({
    required this.deviceHeading,
    required this.qiblaBearing,
  });

  @override
  Widget build(BuildContext context) {
    // Rotate the dial counter to the device heading so N stays at true north.
    final dialRotation = -deviceHeading * math.pi / 180.0;

    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Rotating dial — ring + ticks + cardinal labels + Kaaba marker.
          Transform.rotate(
            angle: dialRotation,
            child: SizedBox(
              width: 280,
              height: 280,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size.square(280),
                    painter: _CompassDialPainter(
                      ring: context.noor.line,
                      ticks: context.noor.lineStrong,
                      cardinal: context.noor.inkMuted,
                      cardinalActive: context.noor.primary,
                    ),
                  ),
                  // Kaaba marker sits on the ring at the absolute qibla
                  // bearing (measured clockwise from N). Rotates together
                  // with the dial.
                  Transform.rotate(
                    angle: qiblaBearing * math.pi / 180.0,
                    child: const Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: _KaabaMarker(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Fixed forward-facing needle — points where the phone is aimed.
          CustomPaint(
            size: const Size.square(280),
            painter: _NeedlePainter(color: context.noor.primary),
          ),
          // Center anchor disc.
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: context.noor.ink,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompassDialPainter extends CustomPainter {
  final Color ring;
  final Color ticks;
  final Color cardinal;
  final Color cardinalActive;

  _CompassDialPainter({
    required this.ring,
    required this.ticks,
    required this.cardinal,
    required this.cardinalActive,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerR = size.width / 2 - 2;
    final innerR = outerR - 22;

    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = ring;

    canvas.drawCircle(center, outerR, ringPaint);
    canvas.drawCircle(center, innerR, ringPaint);

    // Tick marks every 6° around the outer ring; longer ones every 30°.
    final tickPaint = Paint()
      ..color = ticks
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
      color: cardinal,
    );
    labels.forEach((deg, label) {
      final rad = (deg - 90) * math.pi / 180;
      final pos = Offset(
        center.dx + (innerR - 18) * math.cos(rad),
        center.dy + (innerR - 18) * math.sin(rad),
      );
      // North uses primary green for emphasis.
      final style = deg == 0
          ? textStyle.copyWith(color: cardinalActive)
          : textStyle;
      final tp = TextPainter(
        text: TextSpan(text: label, style: style),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, pos - Offset(tp.width / 2, tp.height / 2));
    });
  }

  @override
  bool shouldRepaint(covariant _CompassDialPainter oldDelegate) =>
      oldDelegate.ring != ring ||
      oldDelegate.ticks != ticks ||
      oldDelegate.cardinal != cardinal ||
      oldDelegate.cardinalActive != cardinalActive;
}

class _NeedlePainter extends CustomPainter {
  final Color color;

  _NeedlePainter({required this.color});

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
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _NeedlePainter oldDelegate) =>
      oldDelegate.color != color;
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
        color: context.noor.secondaryWash,
        shape: BoxShape.circle,
        border: Border.all(
          color: context.noor.secondary,
          width: 2,
        ),
      ),
      child: Container(
        width: 12,
        height: 12,
        color: context.noor.ink,
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
        color: context.noor.neutralSage,
        borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (city.isNotEmpty) ...[
            Text(
              city,
              style: context.noor.tBodySm.copyWith(
                color: context.noor.ink,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 16),
          ],
          Text(
            _formatKm(kmToMecca),
            style: context.noor.tBodySm.copyWith(
              color: context.noor.ink,
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
