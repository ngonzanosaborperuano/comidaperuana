import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recetasperuanas/core/constants/routes.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/widget/app_button_icon.dart';
import 'package:recetasperuanas/shared/widget/spacing/spacing.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingScreen();

    // Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 20),
    //   child: Center(
    //     child: SingleChildScrollView(
    //       child: Column(
    //         children: [
    //           OnboardingScreen(),
    //           Hero(
    //             tag: 'logo',
    //             child: ClipOval(
    //               child: Image.asset('assets/img/logoOutName.png', width: 200, height: 200),
    //             ),
    //           ),
    //           AppVerticalSpace.md,
    //           AppText(
    //             text: context.loc.welcome,
    //             fontSize: AppSpacing.xmd,
    //             fontWeight: FontWeight.bold,
    //           ),
    //           AppText(
    //             text: context.loc.descriptionWelcome,
    //             fontSize: AppSpacing.md,
    //             fontWeight: FontWeight.w400,
    //           ),
    //           Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               AppVerticalSpace.xslg,
    //               AppButton(
    //                 text: context.loc.getStarted,
    //                 onPressed: () {
    //                   context.go(Routes.login.description);
    //                 },
    //                 showIcon: false,
    //               ),
    //             ],
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  List<Map<String, String>> onboardingData = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    onboardingData = [
      {
        "image": "assets/img/imagen_1.png",
        "title": context.loc.onboardingTitle1,
        "subtitle": context.loc.onboardingSubtitle1,
      },
      {
        "image": "assets/img/imagen_2.png",
        "title": context.loc.onboardingTitle2,
        "subtitle": context.loc.onboardingSubtitle2,
      },
      {
        "image": "assets/img/imagen_3.png",
        "title": context.loc.onboardingTitle3,
        "subtitle": context.loc.onboardingSubtitle3,
      },
      {
        "image": "assets/img/imagen_4.png",
        "title": context.loc.onboardingTitle4,
        "subtitle": context.loc.onboardingSubtitle4,
      },
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.8,
            child: PageView.builder(
              controller: _controller,
              itemCount: onboardingData.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AppVerticalSpace.xslg,
                    Image.asset(
                      onboardingData[index]['image']!,
                      fit: BoxFit.contain,
                      width: 300,
                      height: 300,
                    ),
                    AppVerticalSpace.xmd,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          Text(
                            onboardingData[index]['title']!,
                            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            onboardingData[index]['subtitle']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    if (onboardingData.length - 1 == index) ...[
                      AppVerticalSpace.xlg,
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: AppButton(
                          text: context.loc.getStarted,
                          onPressed: () {
                            context.go(Routes.login.description);
                          },
                          showIcon: false,
                        ),
                      ),
                    ],
                    Spacer(),
                  ],
                );
              },
            ),
          ),
          SizedBox(
            height: size.height * 0.1,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  onboardingData.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: _currentPage == index ? 14 : 8,
                    height: _currentPage == index ? 14 : 8,
                    decoration: BoxDecoration(
                      color:
                          _currentPage == index
                              ? context.color.secondary
                              : context.color.textPrimary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
