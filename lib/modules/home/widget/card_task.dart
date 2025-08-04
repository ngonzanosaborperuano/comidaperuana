import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recetasperuanas/core/config/color/app_color_scheme.dart';
import 'package:recetasperuanas/core/config/color/app_colors.dart';
import 'package:recetasperuanas/modules/home/controller/home_controller.dart';
import 'package:recetasperuanas/modules/home/models/task_model.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/utils/util.dart';
import 'package:recetasperuanas/shared/widget/app_button_icon.dart';
import 'package:recetasperuanas/shared/widget/app_modal.dart';
import 'package:recetasperuanas/shared/widget/app_textfield.dart';
import 'package:recetasperuanas/shared/widget/spacing/app_spacer.dart';
import 'package:recetasperuanas/shared/widget/spacing/app_spacing.dart';
import 'package:recetasperuanas/shared/widget/text_widget.dart';

class CardTask extends StatelessWidget {
  const CardTask({super.key, required this.itemTask, required this.con});

  final TaskModel itemTask;
  final HomeController con;

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
        border: Border.all(
          width: 1,
          color: AppColorScheme.of(context).textSecondary,
        ),
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
            await onPressedUpdate(context, con, itemTask);
          },
          icon: Icon(
            Icons.mode_edit_outlined,
            color: AppColorScheme.of(context).success,
          ),
        ),
        IconButton(
          onPressed: () async {
            final result = await con.deleteTask(itemTask.id!);
            if (!context.mounted) return;
            showCustomSnackBar(
              context: context,
              message: '${context.loc.messageDeleteNote} ${itemTask.id}',
              backgroundColor:
                  result
                      ? AppColors.emerald700
                      : AppColorScheme.of(context).error,
              foregroundColor: AppColors.white,
            );
          },
          icon: const Icon(
            Icons.delete_outline,
            size: 30,
            color: AppColors.red800,
          ),
        ),
      ],
    );
  }

  Future<void> onPressedUpdate(
    BuildContext context,
    HomeController con,
    TaskModel taskModel,
  ) async {
    GlobalKey<FormState> formKeyNote = GlobalKey<FormState>();
    con.titleController.text = taskModel.title;
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
                  textEditingController: con.titleController,
                  validator: (p0) => con.validateEmpty(p0, context),
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
                  textEditingController: con.bodyController,
                  validator: (p0) => con.validateEmpty(p0, context),
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
            final result = await con.updateTask(taskModel.id!);
            con.titleController.clear();
            con.bodyController.clear();
            if (!context.mounted) return;
            context.pop(result);
          },
        ),
      ],
    ).show(context);

    if (result!) {
      if (!context.mounted) return;
      showCustomSnackBar(
        context: context,
        message: '${context.loc.messageUpdateNote} ${taskModel.id}',
        backgroundColor: AppColorScheme.of(context).success,
        foregroundColor: AppColors.white,
      );
    }
  }
}
