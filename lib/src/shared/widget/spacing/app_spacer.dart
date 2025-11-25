import 'package:flutter/widgets.dart';
import 'package:goncook/src/shared/widget/spacing/app_spacing.dart';

class AppVerticalSpace {
  const AppVerticalSpace._();

  /// xxs = 2
  static Widget xxs = const SizedBox(height: AppSpacing.xxs);

  /// xs = 4
  static Widget xs = const SizedBox(height: AppSpacing.xs);

  /// sm = 8
  static Widget sm = const SizedBox(height: AppSpacing.sm);

  /// sl = 12
  static Widget sl = const SizedBox(height: AppSpacing.sl);

  /// md = 16
  static Widget md = const SizedBox(height: AppSpacing.md);

  /// xmd = 20
  static Widget xmd = const SizedBox(height: AppSpacing.xmd);

  /// xxmd = 24
  static Widget xxmd = const SizedBox(height: AppSpacing.xxmd);

  /// lg = 32
  static Widget lg = const SizedBox(height: AppSpacing.lg);

  /// xl = 40
  static Widget xlg = const SizedBox(height: AppSpacing.xlg);

  /// xxl = 48
  static Widget xxl = const SizedBox(height: AppSpacing.xxlg);

  /// slg = 64
  static Widget slg = const SizedBox(height: AppSpacing.slg);

  /// xslg = 80
  static Widget xslg = const SizedBox(height: AppSpacing.xslg);
}

/// class MepHorizontalSpace
class AppHorizontalSpace {
  AppHorizontalSpace._();

  /// xxs = 2
  static Widget xxs = const SizedBox(width: AppSpacing.xxs);

  /// xs = 4
  static Widget xs = const SizedBox(width: AppSpacing.xs);

  /// sm = 8
  static Widget sm = const SizedBox(width: AppSpacing.sm);

  /// sl = 12
  static Widget sl = const SizedBox(width: AppSpacing.sl);

  /// md = 16
  static Widget md = const SizedBox(width: AppSpacing.md);

  /// xmd = 20
  static Widget xmd = const SizedBox(width: AppSpacing.xmd);

  /// xxmd = 24
  static Widget xxmd = const SizedBox(width: AppSpacing.xxmd);

  /// lg = 32
  static Widget lg = const SizedBox(width: AppSpacing.lg);

  /// xl = 40
  static Widget xlg = const SizedBox(width: AppSpacing.xlg);

  /// xxl = 48
  static Widget xxl = const SizedBox(width: AppSpacing.xxlg);

  /// slg = 64
  static Widget slg = const SizedBox(width: AppSpacing.slg);

  /// xslg = 80
  static Widget xslg = const SizedBox(width: AppSpacing.xslg);
}

class AppBox {
  AppBox._();

  ///zero = 0
  static Widget empty = const SizedBox.shrink();
}
