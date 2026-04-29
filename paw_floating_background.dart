import 'dart:math';
import 'package:flutter/material.dart';

class PawFloatingBackground extends StatefulWidget {
  final Widget child;

  const PawFloatingBackground({super.key, required this.child});

  @override
  State<PawFloatingBackground> createState() => _PawFloatingBackgroundState();
}

class _PawFloatingBackgroundState extends State<PawFloatingBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 25))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Stack(
          children: [
            // Soft pastel background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFE3D3), Color(0xFFFFF1E8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            // Floating paws
            ...List.generate(10, (index) {
              final random = Random(index);
              final dx = random.nextDouble();
              final size = random.nextDouble() * 30 + 30;

              return Positioned(
                left: MediaQuery.of(context).size.width * dx,
                top: MediaQuery.of(context).size.height *
                    ((index / 10 + _controller.value) % 1),
                child: Transform.rotate(
                  angle: random.nextDouble(),
                  child: Opacity(
                    opacity: 0.15,
                    child: Icon(
                      Icons.pets,
                      size: size,
                      color: Colors.brown,
                    ),
                  ),
                ),
              );
            }),

            widget.child,
          ],
        );
      },
    );
  }
}