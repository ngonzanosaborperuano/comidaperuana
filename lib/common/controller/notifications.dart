part of 'base_controller.dart';

sealed class _NotificationEvent {
  const _NotificationEvent();

  Future<void> show(BuildContext context);
}

final class SuccessNotificationEvent extends _NotificationEvent {
  const SuccessNotificationEvent(this.message, {this.textButton = 'Guardar'});

  final String message;
  final String textButton;

  @override
  Future<void> show(BuildContext context) => ModalView(
    titleHeader: message,
    showCancelButton: false,
    saveText: textButton,
    onSaved: context.pop,
  ).show(context);
}

final class _ErrorNotificationEvent extends _NotificationEvent {
  const _ErrorNotificationEvent(this.message);

  final String message;

  @override
  Future<void> show(BuildContext context) =>
      AppModalAlert(text: message).show(context);
}

mixin _NotificationsNotifier on ChangeNotifier {
  Stream<_NotificationEvent> get _notificationStream =>
      _notificationController.stream;

  final _notificationController =
      StreamController<_NotificationEvent>.broadcast();

  void showError(String message) {
    _notificationController.add(_ErrorNotificationEvent(message));
  }

  void showSuccess(String message) {
    _notificationController.add(SuccessNotificationEvent(message));
  }

  Future<void> _show(BuildContext context, _NotificationEvent event) async =>
      event.show(context);

  void onNotification(BuildContext context) {
    _notificationStream.listen((event) {
      if (!context.mounted) return;
      _show(context, event);
    });
  }
}
