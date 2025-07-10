import 'package:flutter/material.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/widget/app_scaffold/app_scaffold.dart';

class PageHomeAndroid extends StatelessWidget {
  const PageHomeAndroid({super.key, required this.widget});
  final AppScaffold widget;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.onBackPressed != null || widget.title != null)
          SizedBox(
            height: widget.toolbarHeight,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 5),
              child: Row(
                children: [
                  if (widget.onBackPressed != null)
                    IconButton(
                      onPressed: widget.onBackPressed,
                      icon: Icon(Icons.arrow_back, color: context.color.buttonPrimary),
                    ),
                  if (widget.title != null) Expanded(child: widget.title ?? const SizedBox()),
                ],
              ),
            ),
          ),
        Expanded(child: SizedBox(child: widget.body)),
      ],
    );
  }
}
