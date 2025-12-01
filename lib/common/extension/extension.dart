import 'package:flutter/widgets.dart';
import 'package:goncook/common/config/color/app_color_scheme.dart';
import 'package:goncook/common/l10n/app_localizations.dart';
import 'package:goncook/common/widget/app_image.dart' show ImageIconSemantic;
import 'package:goncook/services/image_service.dart';

extension ExtensionColor on BuildContext {
  AppColorScheme get color => AppColorScheme.of(this);
}

extension ExtensionLanguage on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this)!;
}

extension ExtensionImage on BuildContext {
  ImageService get imageService => ImageService();
}

extension ExtensionImageSemantic on BuildContext {
  ImageIconSemantic get image => ImageIconSemantic(this);
}
