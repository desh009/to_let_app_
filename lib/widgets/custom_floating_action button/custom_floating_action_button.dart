// widgets/shutter_fab/shutter_fab.dart
import 'dart:async';
import 'package:flutter/material.dart';

/// A floating action button docked to a screen edge like a shutter/tab.
/// - Collapsed: mostly hidden behind the edge, only a small "point" peeks out.
/// - Tap the point: it slides + pops fully out into view.
/// - Tap again (while out): fires [onPressed], then tucks back in with animation.
/// - Long-press (while out): fires [onLongPress] — reserved for voice/AI feature.
/// - Drag: moves freely up/down and even across the screen while dragging,
///   but on release it always snaps back to hug the LEFT or RIGHT edge.
///
/// Usage: place as the LAST child inside a full-screen `Stack`
/// (e.g. your Scaffold's body, or globally via GetMaterialApp's builder).
class ShutterFab extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final VoidCallback? onLongPress; // ★ পরে ভয়েস/AI ফিচারের জন্য reserved
  final Color backgroundColor;
  final Color iconColor;
  final double buttonWidth;
  final double buttonHeight;
  final double borderRadius;
  final bool startOnRight;
  final double initialTopFraction;

  const ShutterFab({
    super.key,
    required this.icon,
    required this.onPressed,
    this.onLongPress,
    this.backgroundColor = const Color(0xFFBF5338),
    this.iconColor = Colors.white,
    this.buttonWidth = 65,
    this.buttonHeight = 64,
    this.borderRadius = 16,
    this.startOnRight = true,
    this.initialTopFraction = 0.55,
  });

  @override
  State<ShutterFab> createState() => _ShutterFabState();
}

class _ShutterFabState extends State<ShutterFab> {
  static const double _peekVisible = 20;
  static const double _dragTapThreshold = 6; // px — এর কম নড়াচড়া = tap/hold
  static const Duration _longPressDuration = Duration(milliseconds: 450);

  bool _isRight = true;
  bool _isExpanded = false;
  bool _initialized = false;

  double _top = 0;
  double? _dragLeft;
  Offset? _pointerDownPosition;
  double _dragDistance = 0;

  Timer? _longPressTimer;
  bool _longPressFired = false;

  @override
  void initState() {
    super.initState();
    _isRight = widget.startOnRight;
  }

  @override
  void dispose() {
    _longPressTimer?.cancel();
    super.dispose();
  }

  void _initPositionIfNeeded(Size screenSize) {
    if (_initialized) return;
    _initialized = true;
    _top = screenSize.height * widget.initialTopFraction;
  }

  double _restingLeft(Size screenSize) {
    final width = widget.buttonWidth;
    if (_isRight) {
      return _isExpanded
          ? screenSize.width - width
          : screenSize.width - _peekVisible;
    } else {
      return _isExpanded ? 0 : -(width - _peekVisible);
    }
  }

  void _handleTap() {
    if (_isExpanded) {
      widget.onPressed();
      setState(() => _isExpanded = false);
    } else {
      setState(() => _isExpanded = true);
    }
  }

  void _handleLongPress() {
    if (!_isExpanded) return; 
    widget.onLongPress?.call(); 
  }

  void _onPointerDown(PointerDownEvent event, Size screenSize) {
    _dragDistance = 0;
    _dragLeft = _restingLeft(screenSize);
    _pointerDownPosition = event.position;
    _longPressFired = false;

    _longPressTimer = Timer(_longPressDuration, () {
      if (_dragDistance < _dragTapThreshold) {
        _longPressFired = true;
        _handleLongPress();
      }
    });
  }

  void _onPointerMove(PointerMoveEvent event, Size screenSize) {
    _dragDistance += event.delta.distance;

    if (_dragDistance >= _dragTapThreshold) {
      _longPressTimer?.cancel();
    }

    setState(() {
      _top = (_top + event.delta.dy).clamp(
        0.0,
        screenSize.height - widget.buttonHeight - 24,
      );
      _dragLeft = ((_dragLeft ?? 0) + event.delta.dx).clamp(
        -(widget.buttonWidth * 0.6),
        screenSize.width - widget.buttonWidth * 0.4,
      );
    });
  }

  void _onPointerUp(PointerUpEvent event, Size screenSize) {
    _longPressTimer?.cancel();

    if (_longPressFired) {
      setState(() => _dragLeft = null);
      return;
    }

    final wasTap = _dragDistance < _dragTapThreshold;
    if (wasTap) {
      _dragLeft = null;
      _handleTap();
      return;
    }

    final currentCenterX = (_dragLeft ?? 0) + widget.buttonWidth / 2;
    final snapToRight = currentCenterX > screenSize.width / 2;

    setState(() {
      _isRight = snapToRight;
      _dragLeft = null;
    });
  }

  void _onPointerCancel(PointerCancelEvent event) {
    _longPressTimer?.cancel();
    setState(() => _dragLeft = null);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    _initPositionIfNeeded(screenSize);

    final bool isDragging = _dragLeft != null;
    final double left = isDragging ? _dragLeft! : _restingLeft(screenSize);

    final radius = Radius.circular(widget.borderRadius);
    final cardRadius = _isRight
        ? BorderRadius.only(topLeft: radius, bottomLeft: radius)
        : BorderRadius.only(topRight: radius, bottomRight: radius);

    final buttonWidget = Listener(
      onPointerDown: (e) => _onPointerDown(e, screenSize),
      onPointerMove: (e) => _onPointerMove(e, screenSize),
      onPointerUp: (e) => _onPointerUp(e, screenSize),
      onPointerCancel: _onPointerCancel,
      child: Material(
        color: Colors.transparent,
        child: AnimatedScale(
          scale: _isExpanded ? 1.0 : 0.94,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          child: Container(
            width: widget.buttonWidth,
            height: widget.buttonHeight,
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: cardRadius,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.28),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Icon(widget.icon, color: widget.iconColor, size: 24),
          ),
        ),
      ),
    );

    if (isDragging) {
      return Positioned(top: _top, left: left, child: buttonWidget);
    }

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      top: _top,
      left: left,
      child: buttonWidget,
    );
  }
}