
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:to_let_app_abandon/core/constants/app_colors.dart';
import 'package:to_let_app_abandon/domain/entities/tolet_item.dart';
import 'package:to_let_app_abandon/domain/repositories/tolet_repository.dart';
import 'package:to_let_app_abandon/core/services/storage_service.dart';
import 'package:to_let_app_abandon/widgets/favourite/controller/favourite_controller.dart';

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
    with TickerProviderStateMixin {

  late AnimationController _bounceController;
  late Animation<double> _bounceScale;


  late AnimationController _rippleController;
  late Animation<double> _rippleScale;
  late Animation<double> _rippleOpacity;


  late AnimationController _burstController;

  StreamSubscription? _sub;
  bool _wasFavorite = false;
  final List<_ParticleSpec> _particles = _generateParticles(12);

  @override
  void initState() {
    super.initState();

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 550),
      vsync: this,
    );
    _bounceScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.7)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 12,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.7, end: 1.35)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 38,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.35, end: 0.92)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.92, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 25,
      ),
    ]).animate(_bounceController);

    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _rippleScale = Tween<double>(begin: 0.3, end: 2.2).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOut),
    );
    _rippleOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.35, end: 0.15), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.15, end: 0.0), weight: 70),
    ]).animate(_rippleController);

    _burstController = AnimationController(
      duration: const Duration(milliseconds: 650),
      vsync: this,
    );

    final favController = Get.find<FavoriteController>();
    _wasFavorite = favController.isFavorite(widget.item.id);

    _sub = favController.animationEvents.listen((event) {
      if (event.itemId != widget.item.id || !mounted) return;
      _wasFavorite = event.isNowFavorite;
      _bounceController.forward(from: 0);
      _rippleController.forward(from: 0);
      if (event.isNowFavorite) {
        _burstController.forward(from: 0);
        HapticFeedback.mediumImpact();
      } else {
        HapticFeedback.selectionClick();
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    _bounceController.dispose();
    _rippleController.dispose();
    _burstController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favController = Get.find<FavoriteController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final double haloSize = widget.size.r * 2.6;

    return Obx(() {
      final isFav = favController.isFavorite(widget.item.id);

      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          await favController.toggleFavorite(widget.item);
          widget.onFavoriteChanged?.call();
        },
        child: SizedBox(
          width: haloSize,
          height: haloSize,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [

              AnimatedBuilder(
                animation: _rippleController,
                builder: (context, _) {
                  if (_rippleController.isDismissed) {
                    return const SizedBox.shrink();
                  }
                  return Opacity(
                    opacity: _rippleOpacity.value,
                    child: Transform.scale(
                      scale: _rippleScale.value,
                      child: Container(
                        width: haloSize,
                        height: haloSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (isFav ? AppColors.error : AppColors.primary),
                        ),
                      ),
                    ),
                  );
                },
              ),


              AnimatedBuilder(
                animation: _burstController,
                builder: (context, _) {
                  if (_burstController.isDismissed) {
                    return const SizedBox.shrink();
                  }
                  final t = Curves.easeOut.transform(_burstController.value);
                  final fadeT =
                      Curves.easeIn.transform(_burstController.value);
                  return Stack(
                    alignment: Alignment.center,
                    children: _particles.map((p) {
                      final dx = math.cos(p.angle) * p.distance * t;
                      final dy = math.sin(p.angle) * p.distance * t;
                      return Transform.translate(
                        offset: Offset(dx, dy),
                        child: Opacity(
                          opacity: (1 - fadeT).clamp(0.0, 1.0),
                          child: Transform.rotate(
                            angle: p.angle * t * 2,
                            child: Container(
                              width: p.size,
                              height: p.size,
                              decoration: BoxDecoration(
                                shape: p.isCircle
                                    ? BoxShape.circle
                                    : BoxShape.rectangle,
                                borderRadius:
                                    p.isCircle ? null : BorderRadius.circular(1),
                                color: p.color,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),


              AnimatedBuilder(
                animation: _bounceController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _bounceController.isAnimating
                        ? _bounceScale.value
                        : 1.0,
                    child: child,
                  );
                },
                child: Icon(
                  isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  size: widget.size.r,
                  color: isFav
                      ? AppColors.error
                      : (isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}


class _ParticleSpec {
  final double angle;
  final double distance;
  final double size;
  final Color color;
  final bool isCircle;

  _ParticleSpec({
    required this.angle,
    required this.distance,
    required this.size,
    required this.color,
    required this.isCircle,
  });
}

List<_ParticleSpec> _generateParticles(int count) {
  final rand = math.Random(7);
  final colors = [
    AppColors.error,
    AppColors.primary,
    AppColors.secondary,
    AppColors.primaryDark,
  ];

  return List.generate(count, (i) {
    final baseAngle = (i / count) * 2 * math.pi;
    final jitter = (rand.nextDouble() - 0.5) * 0.4;
    return _ParticleSpec(
      angle: baseAngle + jitter,
      distance: 20 + rand.nextDouble() * 14,
      size: 3 + rand.nextDouble() * 3,
      color: colors[i % colors.length],
      isCircle: rand.nextBool(),
    );
  });
}