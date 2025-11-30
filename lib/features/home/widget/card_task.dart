import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goncook/features/core/config/color/app_color_scheme.dart';
import 'package:goncook/features/core/config/color/app_colors.dart';
import 'package:goncook/features/home/models/task_model.dart';
import 'package:goncook/common/controller/base_controller.dart';
import 'package:goncook/common/utils/util.dart';
import 'package:goncook/common/widget/app_button_icon.dart';
import 'package:goncook/common/widget/app_modal.dart';
import 'package:goncook/common/widget/app_textfield.dart';
import 'package:goncook/common/widget/spacing/app_spacer.dart';
import 'package:goncook/common/widget/spacing/app_spacing.dart';
import 'package:goncook/common/widget/text_widget.dart';

class CardTask extends StatelessWidget {
  const CardTask({
    super.key,
    required this.itemTask,
    required this.onUpdateTask,
    required this.onDeleteTask,
  });

  final TaskModel itemTask;
  final Function(int, String, String) onUpdateTask;
  final Function(int) onDeleteTask;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          transform: const GradientRotation(0.25),
          stops: const [0.75, 0.8, 0.85],
          colors: [
            AppColorScheme.of(context).warning,
            AppColorScheme.of(context).success,
            AppColorScheme.of(context).warning,
          ],
        ),
        border: Border.all(width: 1, color: AppColorScheme.of(context).textSecondary),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: AppSpacing.sm,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: 'ID: ${itemTask.id}',
              fontWeight: FontWeight.bold,
              color: AppColors.text2,
            ),
            AppText(
              text: '${context.loc.title}: ${itemTask.title}',
              fontWeight: FontWeight.bold,
              color: AppColors.text2,
            ),
            AppText(
              text:
                  '${context.loc.status}: ${itemTask.completed! == 1 ? context.loc.completed : context.loc.pending}',
              color: AppColors.text2,
            ),
            _editTask(context),
          ],
        ),
      ),
    );
  }

  Row _editTask(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () async {
            await onPressedUpdate(context, itemTask);
          },
          icon: Icon(Icons.mode_edit_outlined, color: AppColorScheme.of(context).success),
        ),
        IconButton(
          onPressed: () async {
            final result = await onDeleteTask(itemTask.id!);
            if (!context.mounted) return;
            showCustomSnackBar(
              context: context,
              message: '${context.loc.messageDeleteNote} ${itemTask.id}',
              backgroundColor: result ? AppColors.emerald700 : AppColorScheme.of(context).error,
              foregroundColor: AppColors.white,
            );
          },
          icon: const Icon(Icons.delete_outline, size: 30, color: AppColors.red800),
        ),
      ],
    );
  }

  Future<void> onPressedUpdate(BuildContext context, TaskModel taskModel) async {
    GlobalKey<FormState> formKeyNote = GlobalKey<FormState>();
    final titleController = TextEditingController(text: taskModel.title);
    final bodyController = TextEditingController(text: taskModel.body ?? '');

    final result = await AppDialog(
      titleColor: AppColorScheme.of(context).text,
      title: context.loc.updateTask,
      body: Form(
        key: formKeyNote,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.loc.title),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ColoredBox(
                color: AppColorScheme.of(context).textSecondary,
                child: AppTextField(
                  hintText: context.loc.insertTitle,
                  textEditingController: titleController,
                  validator: (p0) => p0 == null || p0.isEmpty ? context.loc.validateEmpty : null,
                ),
              ),
            ),
            AppVerticalSpace.sl,
            Text(context.loc.body),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ColoredBox(
                color: AppColorScheme.of(context).textSecondary,
                child: AppTextField(
                  hintText: context.loc.writeNote,
                  textEditingController: bodyController,
                  validator: (p0) => p0 == null || p0.isEmpty ? context.loc.validateEmpty : null,
                ),
              ),
            ),
          ],
        ),
      ),
      buttons: [
        AppButton(
          isCancel: true,
          text: context.loc.back,
          showIcon: false,
          onPressed: () {
            context.pop(false);
          },
        ),
        AppButton(
          text: context.loc.save,
          showIcon: false,
          onPressed: () async {
            if (!formKeyNote.currentState!.validate()) return;
            onUpdateTask(taskModel.id!, titleController.text, bodyController.text);
            titleController.clear();
            bodyController.clear();
            if (!context.mounted) return;
            context.pop(true);
          },
        ),
      ],
    ).show(context);

    if (result ?? false) {
      if (!context.mounted) return;
      showCustomSnackBar(
        context: context,
        message: context.loc.messageUpdateNote,
        backgroundColor: AppColorScheme.of(context).success,
        foregroundColor: AppColors.white,
      );
    }

    titleController.dispose();
    bodyController.dispose();
  }
}
