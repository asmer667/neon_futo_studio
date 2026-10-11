import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class ShapeRenderer {
  /// يرسم شكلاً محدداً ويحوله إلى PNG bytes
  static Future<Uint8List> renderShape({
    required String shape,
    required Color fillColor,
    required Color borderColor,
    required double borderWidth,
    int size = 256,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()..color = fillColor;
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final center = Offset(size / 2, size / 2);
    final radius = size / 2 - borderWidth;

    switch (shape) {
      case 'heart':
        _drawHeart(canvas, center, radius, paint, borderPaint);
        break;
      case 'star':
        _drawStar(canvas, center, radius, 5, paint, borderPaint);
        break;
      case 'hexagon':
        _drawPolygon(canvas, center, radius, 6, paint, borderPaint);
        break;
      case 'diamond':
        _drawPolygon(canvas, center, radius, 4, paint, borderPaint);
        break;
      case 'circle':
        canvas.drawCircle(center, radius, paint);
        canvas.drawCircle(center, radius, borderPaint);
        break;
      case 'triangle':
        _drawPolygon(canvas, center, radius, 3, paint, borderPaint);
        break;
      case 'snowflake':
        _drawSnowflake(canvas, center, radius, paint, borderPaint);
        break;
      default:
        // مربع بحواف دائرية
        final rect = Rect.fromCenter(center: center, width: size * 0.8, height: size * 0.8);
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(20)),
          paint,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(20)),
          borderPaint,
        );
    }

    final picture = recorder.endRecording();
    final image = await picture.toImage(size, size);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  static void _drawHeart(Canvas canvas, Offset center, double radius, Paint fill, Paint border) {
    final path = Path();
    final w = radius * 2;
    final h = radius * 2;
    path.moveTo(center.dx, center.dy + h * 0.35);
    path.cubicTo(
      center.dx - w * 0.5, center.dy - h * 0.1,
      center.dx - w * 0.2, center.dy - h * 0.5,
      center.dx, center.dy - h * 0.15,
    );
    path.cubicTo(
      center.dx + w * 0.2, center.dy - h * 0.5,
      center.dx + w * 0.5, center.dy - h * 0.1,
      center.dx, center.dy + h * 0.35,
    );
    path.close();
    canvas.drawPath(path, fill);
    canvas.drawPath(path, border);
  }

  static void _drawStar(Canvas canvas, Offset center, double radius, int points, Paint fill, Paint border) {
    final path = Path();
    final innerRadius = radius * 0.4;
    final angle = (2 * 3.141592653589793) / points;
    for (int i = 0; i < points * 2; i++) {
      final r = i.isEven ? radius : innerRadius;
      final a = angle * i - 3.141592653589793 / 2;
      final x = center.dx + r * _cos(a);
      final y = center.dy + r * _sin(a);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, fill);
    canvas.drawPath(path, border);
  }

  static void _drawPolygon(Canvas canvas, Offset center, double radius, int sides, Paint fill, Paint border) {
    final path = Path();
    final angle = (2 * 3.141592653589793) / sides;
    for (int i = 0; i < sides; i++) {
      final a = angle * i - 3.141592653589793 / 2;
      final x = center.dx + radius * _cos(a);
      final y = center.dy + radius * _sin(a);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, fill);
    canvas.drawPath(path, border);
  }

  static void _drawSnowflake(Canvas canvas, Offset center, double radius, Paint fill, Paint border) {
    for (int i = 0; i < 6; i++) {
      final angle = (3.141592653589793 / 3) * i;
      final x = center.dx + radius * _cos(angle);
      final y = center.dy + radius * _sin(angle);
      canvas.drawLine(center, Offset(x, y), border);
    }
  }

  static double _cos(double angle) => _taylorCos(angle);
  static double _sin(double angle) => _taylorSin(angle);

  static double _taylorCos(double x) {
    x = x % (2 * 3.141592653589793);
    double result = 1;
    double term = 1;
    for (int i = 1; i < 10; i++) {
      term *= -x * x / ((2 * i - 1) * (2 * i));
      result += term;
    }
    return result;
  }

  static double _taylorSin(double x) {
    x = x % (2 * 3.141592653589793);
    double result = x;
    double term = x;
    for (int i = 1; i < 10; i++) {
      term *= -x * x / ((2 * i) * (2 * i + 1));
      result += term;
    }
    return result;
  }
}
