import 'package:flutter/material.dart';

class TranslateOnHover extends StatefulWidget {
  const TranslateOnHover({super.key, required this.child});

  final Widget child;

  @override
  State<TranslateOnHover> createState() => _TranslateOnHoverState();
}

class _TranslateOnHoverState extends State<TranslateOnHover> {
  final nonHoverTransform = Matrix4.identity();
  final hoverTransform = Matrix4.identity()..translate(0, -10, 0);

  bool _hovering = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => _mouseEnter(true),
      onExit: (event) => _mouseEnter(false),
      child: AnimatedContainer(
          duration: const Duration(microseconds: 200),
          transform: _hovering ? hoverTransform : nonHoverTransform,
          child: widget.child),
    );
  }

  void _mouseEnter(bool hovering) {
    setState(() {
      _hovering = hovering;
    });
  }
}
