class AppSize {
  AppSize._(this.size);

  factory AppSize.zero() => AppSize._(0);

  factory AppSize.minimum() => AppSize._(1);

  factory AppSize.extraExtraSmall() => AppSize._(2);

  factory AppSize.extraSmall() => AppSize._(4);

  factory AppSize.small() => AppSize._(8);

  factory AppSize.halfMedium() => AppSize._(12);

  factory AppSize.medium() => AppSize._(16);

  factory AppSize.halfLarge() => AppSize._(24);

  factory AppSize.large() => AppSize._(32);

  factory AppSize.extraLarge() => AppSize._(40);

  final double size;
}
