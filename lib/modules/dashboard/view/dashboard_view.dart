import 'package:flutter/material.dart';
import 'package:recetasperuanas/core/config/config.dart';
import 'package:recetasperuanas/modules/dashboard/widget/donutChartPainter.dart';
import 'package:recetasperuanas/modules/home/models/task_model.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({
    super.key,
    required this.percent,
    required this.listTaskModel,
  });

  final double percent;
  final List<TaskModel> listTaskModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        AppDonutChart(completedPercent: percent),

        const SizedBox(height: 16),
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
                    backgroundColor:
                        todo.completed == 1
                            ? AppColors.success
                            : AppColors.error,
                    child: Icon(
                      todo.completed == 1 ? Icons.check : Icons.close,
                      color: AppColors.white,
                    ),
                  ),
                  title: Text('${context.loc.title}: ${todo.title}'),
                  subtitle: Text('${context.loc.user} ID: ${todo.userId}'),
                  trailing: Icon(
                    todo.completed == 1 ? Icons.done : Icons.pending,
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
