// widgets/animated_favorite_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:to_let_app_abandon/core/constants/app_colors.dart';
import 'package:to_let_app_abandon/domain/entities/tolet_item.dart';
import 'package:to_let_app_abandon/widgets/favourite/button/animated_favourite_button.dart';

class AnimatedFavoriteButton extends StatefulWidget {
  final ToLetItem item;
  final double size;
  final VoidCallback? onFavoriteChanged;

  const AnimatedFavoriteButton({
    super.key,
    required this.item,
    this.size = 28,
    this.onFavoriteChanged,
  });

  @override
  State<AnimatedFavoriteButton> createState() => _AnimatedFavoriteButtonState();
}

class _AnimatedFavoriteButtonState extends State<AnimatedFavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.5), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.5, end: 0.8), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.8, end: 1.2), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 20),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _rotationAnimation = Tween<double>(begin: 0, end: 0.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavoriteController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final isFav = controller.isFavorite(widget.item.id);
      final isAnimating = controller.isAnimating.value &&
          controller.animatingId.value == widget.item.id;

      // Trigger animation when favorite state changes
      if (isAnimating && !_controller.isAnimating) {
        _controller.forward(from: 0);
      }

      return GestureDetector(
        onTap: () async {
          await controller.toggleFavorite(widget.item);
          widget.onFavoriteChanged?.call();
        },
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.rotate(
                angle: _rotationAnimation.value * (isFav ? 1 : -1),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background pulse
                    if (isAnimating)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        width: widget.size.r * 2.5,
                        height: widget.size.r * 2.5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (isFav ? AppColors.error : AppColors.primary)
                              .withOpacity(0.1),
                        ),
                      ),
                    
                    // Heart Icon
                    Icon(
                      isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      size: widget.size.r,
                      color: isFav
                          ? AppColors.error
                          : (isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight),
                    ),
                    
                    // Sparkle particles
                    if (isAnimating && isFav)
                      ...List.generate(8, (index) {
                        final angle = (index / 8) * 2 * 3.14159;
                        final distance = (widget.size.r * 0.5) +
                            (widget.size.r * 0.3 * _scaleAnimation.value);
                        return Positioned(
                          left: widget.size.r / 2 + distance * 0.7 * (1 + _scaleAnimation.value * 0.2),
                          top: widget.size.r / 2 + distance * 0.7 * (1 + _scaleAnimation.value * 0.2),
                          child: Opacity(
                            opacity: 1 - _scaleAnimation.value,
                            child: Container(
                              width: 4.r,
                              height: 4.r,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.error.withOpacity(0.6),
                              ),
                            ),
                          ),
                        );
                      }),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}