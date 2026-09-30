import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const DiceApp());
}

class DiceApp extends StatelessWidget {
  const DiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DicePage(),
    );
  }
}

class DicePage extends StatefulWidget {
  const DicePage({super.key});

  @override
  State<DicePage> createState() => _DicePageState();
}

class _DicePageState extends State<DicePage> with SingleTickerProviderStateMixin {
  int leftDiceNumber = 1;
  int rightDiceNumber = 2;
  int rollCount = 0;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _rollDice() {
    _animController.forward(from: 0.0);
    setState(() {
      leftDiceNumber = Random().nextInt(6) + 1;
      rightDiceNumber = Random().nextInt(6) + 1;
      rollCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final total = leftDiceNumber + rightDiceNumber;

    return Scaffold(
      backgroundColor: const Color(0xFFD32F2F),
      appBar: AppBar(
        title: const Text(
          'Dicee',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFB71C1C),
        centerTitle: true,
        elevation: 3,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Tổng điểm: $total',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Lần lắc: #$rollCount',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _rollDice,
                        child: AnimatedBuilder(
                          animation: _animController,
                          builder: (context, child) {
                            final angle = _animController.value * pi * 2;
                            return Transform.rotate(
                              angle: angle,
                              child: DiceFaceWidget(number: leftDiceNumber),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: GestureDetector(
                        onTap: _rollDice,
                        child: AnimatedBuilder(
                          animation: _animController,
                          builder: (context, child) {
                            final angle = -_animController.value * pi * 2;
                            return Transform.rotate(
                              angle: angle,
                              child: DiceFaceWidget(number: rightDiceNumber),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                ElevatedButton.icon(
                  onPressed: _rollDice,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFB71C1C),
                    elevation: 6,
                    padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  icon: const Icon(Icons.casino, size: 28),
                  label: const Text(
                    'LẮC XÚC XẮC',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Chạm vào xúc xắc hoặc nút để lắc',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DiceFaceWidget extends StatelessWidget {
  final int number;
  const DiceFaceWidget({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: CustomPaint(
          painter: _DicePainter(number),
        ),
      ),
    );
  }
}

class _DicePainter extends CustomPainter {
  final int number;
  _DicePainter(this.number);

  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = const Color(0xFFD32F2F)
      ..style = PaintingStyle.fill;

    final dotRadius = size.width * 0.11;
    final left = size.width * 0.22;
    final center = size.width * 0.5;
    final right = size.width * 0.78;

    final top = size.height * 0.22;
    final mid = size.height * 0.5;
    final bottom = size.height * 0.78;

    void drawDot(double x, double y) {
      canvas.drawCircle(Offset(x, y), dotRadius, dotPaint);
    }

    switch (number) {
      case 1:
        drawDot(center, mid);
        break;
      case 2:
        drawDot(left, top);
        drawDot(right, bottom);
        break;
      case 3:
        drawDot(left, top);
        drawDot(center, mid);
        drawDot(right, bottom);
        break;
      case 4:
        drawDot(left, top);
        drawDot(right, top);
        drawDot(left, bottom);
        drawDot(right, bottom);
        break;
      case 5:
        drawDot(left, top);
        drawDot(right, top);
        drawDot(center, mid);
        drawDot(left, bottom);
        drawDot(right, bottom);
        break;
      case 6:
        drawDot(left, top);
        drawDot(right, top);
        drawDot(left, mid);
        drawDot(right, mid);
        drawDot(left, bottom);
        drawDot(right, bottom);
        break;
      default:
        drawDot(center, mid);
    }
  }

  @override
  bool shouldRepaint(covariant _DicePainter oldDelegate) => oldDelegate.number != number;
}
