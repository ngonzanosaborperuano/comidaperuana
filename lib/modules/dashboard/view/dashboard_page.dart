import 'package:flutter/material.dart';
import 'package:recetasperuanas/modules/dashboard/view/dashboard_view.dart';
import 'package:recetasperuanas/modules/home/models/task_model.dart';
import 'package:recetasperuanas/shared/widget/app_scaffold.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key, required this.listTaskModel});

  factory DashboardPage.routeBuilder(_, GoRouterState state) {
    final listTaskModel = state.extra as List<TaskModel>;
    return DashboardPage(
      key: const Key('dashboard_page'),
      listTaskModel: listTaskModel,
    );
  }

  final List<TaskModel> listTaskModel;

  @override
  Widget build(BuildContext context) {
    final completed = listTaskModel.where((t) => t.completed == 1).length;
    final percent =
        listTaskModel.isEmpty ? 0.0 : completed / listTaskModel.length;

    return AppScaffold(
      title: Text('Dashboard'),
      onBackPressed: context.pop,
      body: DashboardView(percent: percent, listTaskModel: listTaskModel),
    );
  }
}
