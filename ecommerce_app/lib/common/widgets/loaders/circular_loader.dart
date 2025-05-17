import 'package:flutter/material.dart';
import 'dart:math' as math;

class TCircularLoader extends StatefulWidget {
  const TCircularLoader({
    super.key,
    this.size = 40.0,
    this.primaryColor,
    this.secondaryColor,
    this.strokeWidth = 4.0,
    this.padding = const EdgeInsets.all(0),
  });

  final double size;
  final Color? primaryColor;
  final Color? secondaryColor;
  final double strokeWidth;
  final EdgeInsetsGeometry padding;

  @override
  State<TCircularLoader> createState() => _TCircularLoaderState();
}

class _TCircularLoaderState extends State<TCircularLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.primaryColor ?? Theme.of(context).primaryColor;
    final secondaryColor =
        widget.secondaryColor ?? primaryColor.withOpacity(0.3);

    return Padding(
      padding: widget.padding,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: _CircularLoaderPainter(
                animation: _controller,
                primaryColor: primaryColor,
                secondaryColor: secondaryColor,
                strokeWidth: widget.strokeWidth,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CircularLoaderPainter extends CustomPainter {
  _CircularLoaderPainter({
    required this.animation,
    required this.primaryColor,
    required this.secondaryColor,
    required this.strokeWidth,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color primaryColor;
  final Color secondaryColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = math.min(centerX, centerY) - strokeWidth / 2;

    final Paint backgroundPaint =
        Paint()
          ..color = secondaryColor
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    // Vẽ vòng tròn nền
    canvas.drawCircle(Offset(centerX, centerY), radius, backgroundPaint);

    final Paint foregroundPaint =
        Paint()
          ..color = primaryColor
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    // Tạo shader cho hiệu ứng gradient
    foregroundPaint.shader = SweepGradient(
      colors: [primaryColor.withOpacity(0), primaryColor],
      stops: const [0.0, 1.0],
      startAngle: 0,
      endAngle: math.pi * 2,
      transform: GradientRotation(animation.value * math.pi * 2),
    ).createShader(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
    );

    // Vẽ phần arc xoay
    final double sweepAngle = 0.8 * math.pi;
    final double startAngle = animation.value * math.pi * 2;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      startAngle,
      sweepAngle,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(_CircularLoaderPainter oldDelegate) {
    return oldDelegate.animation.value != animation.value ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.secondaryColor != secondaryColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
