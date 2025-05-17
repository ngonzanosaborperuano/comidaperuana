import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final session = await warmupCustomTabs(
    options: const CustomTabsSessionOptions(prefersDefaultBrowser: true),
  );
  debugPrint('Warm up session: $session');
  runApp(MyApp(session));
}

class MyApp extends StatefulWidget {
  final CustomTabsSession customTabsSession;

  const MyApp(this.customTabsSession, {super.key});

  @override
  State createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SafariViewPrewarmingSession? _prewarmingSession;

  @override
  void initState() {
    super.initState();

    // After warming up, the session might not be established immediately, so we wait for a short period.
    final customTabsSession = widget.customTabsSession;
    Future.delayed(const Duration(seconds: 1), () async {
      _prewarmingSession = await mayLaunchUrl(
        Uri.parse('https://flutter.dev'),
        customTabsSession: customTabsSession,
      );
      debugPrint('Prewarming connection: $_prewarmingSession');
    });
  }

  @override
  void dispose() {
    final session = _prewarmingSession;
    if (session != null) {
      Future(() async {
        await invalidateSession(session);
      });
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Custom Tabs Example',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: Builder(
        builder:
            (context) => Scaffold(
              appBar: AppBar(title: const Text('Flutter Custom Tabs Example')),
              body: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[
                  FilledButton(
                    onPressed: () => _launchDeepLinkUrl(context),
                    child: const Text('Deep link to platform maps'),
                  ),
                  FilledButton(
                    onPressed: () => _launchUrlInSheetView(context),
                    child: const Text('Show flutter.dev in sheet view'),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}

Future<void> _launchDeepLinkUrl(BuildContext context) async {
  final theme = Theme.of(context);
  final uri =
      'https://www.mercadopago.com.pe/checkout/v1/redirect?pref_id=1258945087-62e4d743-4b17-44f9-93b2-1bd397a2a818';
  try {
    await launchUrl(
      Uri.parse(uri),
      prefersDeepLink: true,
      customTabsOptions: CustomTabsOptions(
        colorSchemes: CustomTabsColorSchemes.defaults(
          toolbarColor: theme.colorScheme.surface,
        ),
        urlBarHidingEnabled: true,
        showTitle: false,
        closeButton: CustomTabsCloseButton(
          icon: CustomTabsCloseButtonIcons.back,
        ),
        shareState: CustomTabsShareState.browserDefault,
      ),
      safariVCOptions: SafariViewControllerOptions(
        preferredBarTintColor: theme.colorScheme.surface,
        preferredControlTintColor: theme.colorScheme.onSurface,
        barCollapsingEnabled: true,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
      ),
    );
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future<void> _launchUrlInSheetView(BuildContext context) async {
  final theme = Theme.of(context);
  final mediaQuery = MediaQuery.of(context);
  try {
    await launchUrl(
      Uri.parse(
        'https://www.mercadopago.com.pe/checkout/v1/redirect?pref_id=1258945087-62e4d743-4b17-44f9-93b2-1bd397a2a818',
      ),
      customTabsOptions: CustomTabsOptions.partial(
        configuration: PartialCustomTabsConfiguration.adaptiveSheet(
          initialHeight: mediaQuery.size.height * 0.8,
          initialWidth: mediaQuery.size.width * 0.4,
          activitySideSheetMaximizationEnabled: true,
          activitySideSheetDecorationType:
              CustomTabsActivitySideSheetDecorationType.divider,
          activitySideSheetRoundedCornersPosition:
              CustomTabsActivitySideSheetRoundedCornersPosition.top,
          cornerRadius: 12,
        ),
        colorSchemes: CustomTabsColorSchemes.defaults(
          colorScheme: theme.brightness.toColorScheme(),
          toolbarColor: theme.colorScheme.primary,
        ),
        showTitle: true,
      ),
      safariVCOptions: SafariViewControllerOptions.pageSheet(
        configuration: const SheetPresentationControllerConfiguration(
          detents: {
            SheetPresentationControllerDetent.large,
            SheetPresentationControllerDetent.medium,
          },
          prefersScrollingExpandsWhenScrolledToEdge: true,
          prefersGrabberVisible: true,
          prefersEdgeAttachedInCompactHeight: true,
          preferredCornerRadius: 16.0,
        ),
        preferredBarTintColor: theme.colorScheme.primary,
        preferredControlTintColor: theme.colorScheme.onPrimary,
        entersReaderIfAvailable: true,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
      ),
    );
  } catch (e) {
    debugPrint(e.toString());
  }
}
