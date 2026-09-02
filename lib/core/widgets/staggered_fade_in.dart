import 'package:flutter/material.dart';

/// Embolcalla un element d'una llista/graella perquè aparegui amb un
/// fade + petit desplaçament cap amunt, retardat segons el seu [index],
/// en lloc d'aparèixer tot de cop.
class StaggeredFadeIn extends StatefulWidget {
  final int index;
  final Widget child;

  const StaggeredFadeIn({super.key, required this.index, required this.child});

  @override
  State<StaggeredFadeIn> createState() => _StaggeredFadeInState();
}

class _StaggeredFadeInState extends State<StaggeredFadeIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _offset;

  // Per no allargar massa la càrrega quan hi ha molts elements, l'esglaó
  // es limita als primers ~16 (a partir d'aquí entren tots alhora, sense
  // retard addicional).
  static const _stepMs = 35;
  static const _maxStaggeredIndex = 16;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );

    final curved = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _fade = curved;
    _offset = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(curved);

    final delay = _stepMs * widget.index.clamp(0, _maxStaggeredIndex);

    Future.delayed(Duration(milliseconds: delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _offset, child: widget.child),
    );
  }
}
