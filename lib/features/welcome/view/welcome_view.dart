import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goncook/common/constants/routes.dart';
import 'package:goncook/common/controller/base_controller.dart';
import 'package:goncook/common/l10n/app_localizations.dart' show AppLocalizations;
import 'package:goncook/common/widget/widget.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  late final PageController _pageController;
  int _currentPage = 0;

  final Set<String> _selectedDiets = {};
  final Set<String> _selectedAllergies = {};
  String _selectedExperience = '';

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool _nextPage() {
    final l10n = context.loc;
    if (_currentPage < 4) {
      if (_currentPage == 1 && _selectedDiets.isEmpty) {
        context.showErrorToast(l10n.pleaseSelectAtLeastOne, title: l10n.selectionRequired);
        return false;
      }
      if (_currentPage == 2 && _selectedAllergies.isEmpty) {
        context.showErrorToast(l10n.pleaseSelectAtLeastOne, title: l10n.selectionRequired);
        return false;
      }
      if (_currentPage == 3 && _selectedExperience.isEmpty) {
        context.showErrorToast(l10n.pleaseSelectAtLeastOne, title: l10n.selectionRequired);
        return false;
      }

      switch (_currentPage) {
        case 0:
          context.showInfoToast(l10n.setupDiet, title: l10n.step1Of3);
          break;
        case 1:
          context.showWarningToast(l10n.allergyInfo, title: l10n.allergyInfoTitle);
          break;
        case 2:
          context.showInfoToast(l10n.finalStep, title: l10n.finalStepTitle);
          break;
        case 3:
          context.showSuccessToast(l10n.setupCompleted, title: l10n.welcomeTitle);
          break;
      }

      _currentPage++;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {});
    }
    return true;
  }

  Widget _buildDietPage(AppLocalizations l10n) {
    final diets = {
      'omnivore': l10n.omnivore,
      'vegetarian': l10n.vegetarian,
      'vegan': l10n.vegan,
      'pescatarian': l10n.pescatarian,
      'glutenFree': l10n.glutenFree,
      'lactoseFree': l10n.lactoseFree,
      'keto': l10n.keto,
      'paleo': l10n.paleo,
      'none': l10n.none,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextCocinando(context: context),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.followDietQuestion,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: context.color.text),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(l10n.selectAllThatApply, style: TextStyle(fontSize: 16, color: context.color.text)),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: diets.length,
              itemBuilder: (context, index) {
                final key = diets.keys.elementAt(index);
                final value = diets[key]!;
                final isSelected = _selectedDiets.contains(key);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (key == 'none') {
                        if (isSelected) {
                          _selectedDiets.remove(key);
                        } else {
                          _selectedDiets.clear();
                          _selectedDiets.add(key);
                        }
                      } else {
                        _selectedDiets.remove('none');
                        if (isSelected) {
                          _selectedDiets.remove(key);
                        } else {
                          _selectedDiets.add(key);
                        }
                      }
                    });
                  },
                  child: SelectButton(isSelected: isSelected, value: value),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllergyPage(AppLocalizations l10n) {
    final allergies = {
      'nuts': l10n.nuts,
      'seafood': l10n.seafood,
      'eggs': l10n.eggs,
      'dairy': l10n.dairy,
      'soy': l10n.soy,
      'wheat': l10n.wheat,
      'fish': l10n.fish,
      'none': l10n.none,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextCocinando(context: context),
          AppVerticalSpace.lg,
          Text(
            l10n.haveAllergiesQuestion,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: context.color.text),
          ),
          AppVerticalSpace.md,
          Text(l10n.importantForSafety, style: TextStyle(fontSize: 16, color: context.color.text)),
          AppVerticalSpace.lg,
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: allergies.length,
              itemBuilder: (context, index) {
                final key = allergies.keys.elementAt(index);
                final value = allergies[key]!;
                final isSelected = _selectedAllergies.contains(key);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (key == 'none') {
                        if (isSelected) {
                          _selectedAllergies.remove(key);
                        } else {
                          _selectedAllergies.clear();
                          _selectedAllergies.add(key);
                        }
                      } else {
                        _selectedAllergies.remove('none');
                        if (isSelected) {
                          _selectedAllergies.remove(key);
                        } else {
                          _selectedAllergies.add(key);
                        }
                      }
                    });
                  },
                  child: SelectButton(isSelected: isSelected, value: value),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperiencePage(AppLocalizations l10n) {
    final experienceLevels = {
      'beginner': {'title': l10n.beginner, 'description': l10n.beginnerDescription},
      'intermediate': {'title': l10n.intermediate, 'description': l10n.intermediateDescription},
      'advanced': {'title': l10n.advanced, 'description': l10n.advancedDescription},
      'professionalChef': {
        'title': l10n.professionalChef,
        'description': l10n.professionalChefDescription,
      },
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextCocinando(context: context),
          AppVerticalSpace.lg,
          Text(
            l10n.experienceLevelQuestion,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: context.color.text),
          ),
          AppVerticalSpace.lg,
          Expanded(
            child: ListView.builder(
              itemCount: experienceLevels.length,
              itemBuilder: (context, index) {
                final key = experienceLevels.keys.elementAt(index);
                final level = experienceLevels[key]!;
                final isSelected = _selectedExperience == key;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedExperience = key;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: context.color.background,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? context.color.buttonPrimary : context.color.border,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? context.color.buttonPrimary
                                    : context.color.border,
                                width: 2,
                              ),
                              color: isSelected ? context.color.buttonPrimary : Colors.transparent,
                            ),
                            child: isSelected
                                ? Icon(Icons.check, size: 16, color: context.color.background)
                                : null,
                          ),
                          AppHorizontalSpace.md,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  level['title']!,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: context.color.text,
                                  ),
                                ),
                                AppVerticalSpace.xs,
                                Text(
                                  level['description']!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: context.color.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomePage(AppLocalizations l10n) {
    return Column(
      children: [
        TextCocinando(context: context),
        const Spacer(flex: 2),
        Text(
          l10n.welcomeToCocinandoIA,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: context.color.text),
          textAlign: TextAlign.center,
        ),
        AppVerticalSpace.md,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            l10n.personalizeExperience,
            style: TextStyle(fontSize: 16, color: context.color.text, height: 1.5),
            textAlign: TextAlign.center,
          ),
        ),
        AppVerticalSpace.xlg,
        Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: context.color.shadow,
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: 20,
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/img/cocinera.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: context.color.warmGradient.colors,
                    ),
                  ),
                  child: const Icon(Icons.restaurant_menu, size: 80, color: Colors.white),
                );
              },
            ),
          ),
        ),
        const Spacer(flex: 2),
      ],
    );
  }

  Widget _buildAccessPage(AppLocalizations l10n) {
    return Column(
      children: [
        TextCocinando(context: context),
        const Spacer(flex: 1),
        Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: context.color.shadow,
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: 20,
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/img/init.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: context.color.warmGradient.colors,
                    ),
                  ),
                  child: const Icon(Icons.restaurant_menu, size: 80, color: Colors.white),
                );
              },
            ),
          ),
        ),
        const Spacer(flex: 1),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            l10n.personalizedRecipes,
            style: TextStyle(
              fontSize: 16,
              color: context.color.warning,
              height: 2.5,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        AppVerticalSpace.sm,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            l10n.discoverRecipes,
            style: TextStyle(fontSize: 16, color: context.color.text, height: 1.5),
            textAlign: TextAlign.center,
          ),
        ),
        AppVerticalSpace.xlg,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: AppButton(
            text: l10n.login,
            showIcon: true,
            iconWidget: const Icon(Icons.login),
            iconAtStart: true,
            onPressed: () {
              context.go(Routes.login.description);
            },
          ),
        ),
        AppVerticalSpace.sm,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: AppButton(
            text: l10n.register,
            showIcon: true,
            iconWidget: const Icon(Icons.person_add_alt),
            iconAtStart: true,
            onPressed: () {
              context.go(Routes.register.description);
            },
            isAlternative: true,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.loc;
    final color = context.color;

    return LayoutBuilder(
      builder: (context, constraints) {
        return ColoredBox(
          color: color.background,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_currentPage < 4)
                SizedBox(
                  height: 8,
                  child: AppShimmer.progress(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: constraints.maxWidth * ((_currentPage + 1) / 4),
                      decoration: BoxDecoration(
                        gradient: color.primaryGradient,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildWelcomePage(l10n),
                    _buildDietPage(l10n),
                    _buildAllergyPage(l10n),
                    _buildExperiencePage(l10n),
                    _buildAccessPage(l10n),
                  ],
                ),
              ),
              Visibility(
                visible: _currentPage < 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: AppButton(
                    text: l10n.continueButton,
                    onPressed: _nextPage,
                    showIcon: true,
                    iconWidget: const Icon(Icons.arrow_forward),
                  ),
                ),
              ),
              AppVerticalSpace.lg,
            ],
          ),
        );
      },
    );
  }
}

class SelectButton extends StatelessWidget {
  const SelectButton({super.key, required this.isSelected, required this.value});

  final bool isSelected;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? context.color.background : context.color.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? context.color.buttonPrimary : context.color.border,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isSelected) ...[
            Icon(Icons.check_circle, color: context.color.buttonPrimary, size: 20),
            AppHorizontalSpace.sm,
          ],
          Text(value, style: TextStyle(fontSize: 16, color: context.color.text)),
        ],
      ),
    );
  }
}

class TextCocinando extends StatelessWidget {
  const TextCocinando({super.key, required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final l10n = context.loc;

    return Column(
      children: [
        AppVerticalSpace.slg,
        Text(
          l10n.cocinandoIA,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: context.color.buttonPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        AppVerticalSpace.sm,
        Text(
          l10n.culinaryAssistant,
          style: TextStyle(fontSize: 16, color: context.color.text),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
