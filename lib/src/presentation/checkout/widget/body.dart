import 'package:flutter/material.dart';
import 'package:recetasperuanas/src/presentation/checkout/view/page_success_view.dart'
    show PageSuccess;
import 'package:recetasperuanas/src/presentation/core/config/config.dart';
import 'package:recetasperuanas/src/shared/widget/widget.dart';

class Body extends StatelessWidget {
  const Body({
    super.key,
    required Animation<double> fadeAnimation,
    required Animation<double> scaleAnimation,
    required Animation<Offset> slideAnimation,
    required this.widget,
  }) : _fadeAnimation = fadeAnimation,
       _scaleAnimation = scaleAnimation,
       _slideAnimation = slideAnimation;

  final Animation<double> _fadeAnimation;
  final Animation<double> _scaleAnimation;
  final Animation<Offset> _slideAnimation;
  final PageSuccess widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: kToolbarHeight * 2),
          FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white.withValues(alpha: 0.3), width: 2),
                ),
                child: const Icon(Icons.check_circle_outline, size: 70, color: AppColors.white),
              ),
            ),
          ),
          AppVerticalSpace.xlg,
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          AppVerticalSpace.xxmd,
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 18,
                  color: AppColors.white,
                  height: 1.6,
                  fontWeight: FontWeight.w400,
                ),
                child: widget.content,
              ),
            ),
          ),
          const Spacer(),
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.text.withValues(alpha: 0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: widget.onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.payuDarkGray,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  child: Text(
                    widget.confirmLabel,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
          AppVerticalSpace.xlg,
        ],
      ),
    );
  }
}
