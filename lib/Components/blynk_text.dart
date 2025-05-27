import 'package:flutter/material.dart';
import 'package:usdinfra/configs/app_text_style.dart';

class BlinkingText extends StatefulWidget {
  final String text;
  final Color color;
  final Duration duration;

  const BlinkingText({
    Key? key,
    required this.text,
    required this.color,
    this.duration = const Duration(milliseconds: 800),
  }) : super(key: key);

  @override
  _BlinkingTextState createState() => _BlinkingTextState();
}

class _BlinkingTextState extends State<BlinkingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);

    _opacityAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: Text(widget.text,
          style: AppTextStyle.Text14600.copyWith(color: Colors.green)),
    );
  }
}
