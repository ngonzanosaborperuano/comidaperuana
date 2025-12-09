import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goncook/common/widget/app_scaffold/app_scaffold.dart';
import 'package:goncook/features/dashboard/view/dashboard_view.dart' show DashboardView;
import 'package:goncook/features/register/data/models/user_models.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key, required this.listTaskModel});

  factory DashboardPage.routeBuilder(_, GoRouterState state) {
    final listTaskModel = state.extra as List<UserModel>;
    return DashboardPage(key: const Key('dashboard_page'), listTaskModel: listTaskModel);
  }

  final List<UserModel> listTaskModel;

  @override
  Widget build(BuildContext context) {
    final completed = listTaskModel.where((user) => user.avatar == 'active').length;
    final percent = listTaskModel.isEmpty ? 0.0 : completed / listTaskModel.length;

    return AppScaffold(
      title: const Text('Dashboard'),
      onBackPressed: context.pop,
      body: DashboardView(percent: percent, listTaskModel: listTaskModel),
    );
  }
}
