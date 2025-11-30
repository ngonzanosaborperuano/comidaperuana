import 'package:flutter/cupertino.dart';
import 'package:goncook/common/controller/base_controller.dart';
import 'package:goncook/common/widget/app_scaffold/app_scaffold.dart';

class PageHomeIOS extends StatelessWidget {
  const PageHomeIOS({super.key, required this.widget});

  final AppScaffold widget;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.onBackPressed != null)
                CupertinoButton(
                  color: context.color.buttonPrimary,
                  onPressed: widget.onBackPressed,
                  padding: EdgeInsets.zero,
                  child: Icon(CupertinoIcons.back, size: 30, color: context.color.buttonPrimary),
                )
              else
                const SizedBox.shrink(),
              const SizedBox(width: 5),
              Expanded(child: Center(child: widget.title)),
              const SizedBox(width: 5),
            ],
          ),
        ),
        SliverFillRemaining(child: widget.body),
      ],
    );
  }
}
