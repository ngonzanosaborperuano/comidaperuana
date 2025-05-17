import 'package:flutter/material.dart';
import 'package:recetasperuanas/core/config/color/app_color_scheme.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';

class DividerWidget extends StatelessWidget {
  const DividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: AppColorScheme.of(context).secondary,
            height: 1,
            thickness: 1,
          ),
        ),
        Text(' ${context.loc.or} '),
        Expanded(
          child: Divider(
            color: AppColorScheme.of(context).secondary,
            height: 1,
            thickness: 1,
          ),
        ),
      ],
    );
  }
}
