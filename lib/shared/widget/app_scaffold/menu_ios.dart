import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../core/provider/pages_provider.dart';
import '../../controller/base_controller.dart';
import '../../widget/app_svg.dart';

class MenuIOS extends StatelessWidget {
  final List<Widget> pagesIOS;
  final double toolbarHeight;

  const MenuIOS({super.key, required this.pagesIOS, required this.toolbarHeight});

  @override
  Widget build(BuildContext context) {
    return Consumer<PagesProvider>(
      builder: (context, value, child) {
        return CupertinoTabScaffold(
          backgroundColor: context.color.background,
          tabBar: CupertinoTabBar(
            currentIndex: value.selectPage,
            onTap: (index) => context.read<PagesProvider>().togglePage(index),
            backgroundColor: context.color.backgroundCard.withAlpha(100),
            activeColor: context.color.textSecondary2,
            inactiveColor: context.color.textSecondary,
            items: [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: context.svgIconSemantic.home(
                    color:
                        value.selectPage == 0
                            ? context.color.textSecondary2
                            : context.color.textSecondary,
                  ),
                ),
                label: context.loc.home,
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: context.svgIconSemantic.analysis(
                    color:
                        value.selectPage == 1
                            ? context.color.textSecondary2
                            : context.color.textSecondary,
                  ),
                ),
                label: context.loc.analysis,
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: context.svgIconSemantic.plan(
                    color:
                        value.selectPage == 2
                            ? context.color.textSecondary2
                            : context.color.textSecondary,
                  ),
                ),
                label: context.loc.plan,
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: context.svgIconSemantic.profile(
                    color:
                        value.selectPage == 3
                            ? context.color.textSecondary2
                            : context.color.textSecondary,
                  ),
                ),
                label: context.loc.profile,
              ),
            ],
          ),
          tabBuilder: (context, index) {
            return CupertinoTabView(
              builder:
                  (context) => CupertinoPageScaffold(
                    backgroundColor: context.color.background,
                    child: Column(
                      children: [
                        SizedBox(height: toolbarHeight),
                        Expanded(child: IndexedStack(index: value.selectPage, children: pagesIOS)),
                      ],
                    ),
                  ),
            );
          },
        );
      },
    );
  }
}
