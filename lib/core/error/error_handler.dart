class NotificationError implements Exception {
  final String message;

  NotificationError(this.message);

  @override
  String toString() => "NotificationError: $message";
}
