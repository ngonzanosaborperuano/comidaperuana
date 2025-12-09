import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/bloc/pages_bloc.dart';
import '../../../core/extension/extension.dart';
import '../app_svg.dart';

class MenuIOS extends StatelessWidget {
  final List<Widget> pagesIOS;
  final double toolbarHeight;

  const MenuIOS({super.key, required this.pagesIOS, required this.toolbarHeight});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PagesBloc, PagesState>(
      builder: (context, state) {
        final selectedPage = state is PagesLoaded ? state.selectedPage : 0;
        return CupertinoTabScaffold(
          backgroundColor: context.color.background,
          tabBar: CupertinoTabBar(
            currentIndex: selectedPage,
            onTap: (index) => context.read<PagesBloc>().add(PageChanged(index)),
            backgroundColor: context.color.backgroundCard.withAlpha(100),
            activeColor: context.color.textSecondary2,
            inactiveColor: context.color.textSecondary,
            items: [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: context.svgIconSemantic.home(
                    color: selectedPage == 0
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
                    color: selectedPage == 1
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
                    color: selectedPage == 2
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
                    color: selectedPage == 3
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
              builder: (context) => CupertinoPageScaffold(
                backgroundColor: context.color.background,
                child: Column(
                  children: [
                    SizedBox(height: toolbarHeight),
                    Expanded(
                      child: IndexedStack(index: selectedPage, children: pagesIOS),
                    ),
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
