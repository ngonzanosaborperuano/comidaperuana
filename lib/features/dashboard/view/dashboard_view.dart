import 'package:flutter/material.dart';
import 'package:goncook/common/config/config.dart';
import 'package:goncook/common/extension/extension.dart';
import 'package:goncook/common/models/user_model.dart';
import 'package:goncook/common/widget/widget.dart' show AppVerticalSpace;
import 'package:goncook/features/dashboard/widget/donut_chart_painter.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key, required this.percent, required this.listTaskModel});

  final double percent;
  final List<UserModel> listTaskModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppVerticalSpace.md,
        AppDonutChart(completedPercent: percent),

        AppVerticalSpace.md,
        const Divider(endIndent: 20, indent: 20),
        Expanded(
          child: ListView.builder(
            itemCount: listTaskModel.length,
            itemBuilder: (context, index) {
              final todo = listTaskModel[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: todo.avatar == 'active'
                        ? AppColors.emerald700
                        : AppColors.red700,
                    child: Icon(
                      todo.avatar == 'active' ? Icons.check : Icons.close,
                      color: AppColors.white,
                    ),
                  ),
                  title: Text('${context.loc.title}: ${todo.firstName} ${todo.lastName}'),
                  subtitle: Text('${context.loc.user} ID: ${todo.id}'),
                  trailing: Icon(
                    todo.avatar == 'active' ? Icons.done : Icons.pending,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
