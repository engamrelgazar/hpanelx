import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

void main() async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);

  final bgPaint = Paint()..color = const Color(0xFF6C63FF);
  canvas.drawRect(const Rect.fromLTWH(0, 0, 390, 844), bgPaint);

  drawMockAppUI(canvas);

  final picture = recorder.endRecording();
  final img = await picture.toImage(390, 844);
  final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);

  if (pngBytes != null) {
    final file = File('screenshots/app_screenshot.png');
    await file.writeAsBytes(Uint8List.view(pngBytes.buffer));
    debugPrint('Screenshot saved to ${file.path}');
  }
}

void drawMockAppUI(Canvas canvas) {
  final appBarPaint = Paint()..color = const Color(0xFF6C63FF);
  canvas.drawRect(const Rect.fromLTWH(0, 0, 390, 80), appBarPaint);

  const titleStyle = TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  const titleSpan = TextSpan(
    text: 'HPanelX',
    style: titleStyle,
  );
  final titlePainter = TextPainter(
    text: titleSpan,
    textDirection: TextDirection.ltr,
  );
  titlePainter.layout();
  titlePainter.paint(canvas, const Offset(20, 40));

  final contentPaint = Paint()..color = Colors.white;
  canvas.drawRect(const Rect.fromLTWH(0, 80, 390, 764), contentPaint);

  drawCard(canvas, 20, 100, 350, 120, 'Virtual Machines', '5 active VMs');
  drawCard(canvas, 20, 240, 350, 120, 'Domains', '12 registered domains');
  drawCard(canvas, 20, 380, 350, 120, 'Billing', '2 active subscriptions');

  final navBarPaint = Paint()..color = const Color(0xFFF5F5F5);
  canvas.drawRect(const Rect.fromLTWH(0, 784, 390, 60), navBarPaint);

  final iconPaint = Paint()..color = const Color(0xFF6C63FF);
  canvas.drawCircle(const Offset(65, 814), 5, iconPaint);
  canvas.drawCircle(const Offset(195, 814), 5, iconPaint);
  canvas.drawCircle(const Offset(325, 814), 5, iconPaint);
}

void drawCard(Canvas canvas, double x, double y, double width, double height,
    String title, String description) {
  final cardPaint = Paint()..color = Colors.white;
  final shadowPaint = Paint()
    ..color = Colors.black.withAlpha(26)
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

  canvas.drawRRect(
    RRect.fromRectAndRadius(
      Rect.fromLTWH(x, y, width, height),
      const Radius.circular(12),
    ),
    shadowPaint,
  );

  canvas.drawRRect(
    RRect.fromRectAndRadius(
      Rect.fromLTWH(x, y, width, height),
      const Radius.circular(12),
    ),
    cardPaint,
  );

  const titleStyle = TextStyle(
    color: Colors.black87,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  final titleSpan = TextSpan(
    text: title,
    style: titleStyle,
  );
  final titlePainter = TextPainter(
    text: titleSpan,
    textDirection: TextDirection.ltr,
  );
  titlePainter.layout();
  titlePainter.paint(canvas, Offset(x + 20, y + 20));

  const descStyle = TextStyle(
    color: Colors.black54,
    fontSize: 14,
  );
  final descSpan = TextSpan(
    text: description,
    style: descStyle,
  );
  final descPainter = TextPainter(
    text: descSpan,
    textDirection: TextDirection.ltr,
  );
  descPainter.layout();
  descPainter.paint(canvas, Offset(x + 20, y + 50));
}
