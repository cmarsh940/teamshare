import 'package:flutter/material.dart';

/// Shows a confirmation dialog.
/// Returns:
///   true  -> user confirmed
///   false -> user cancelled
///   null  -> dialog dismissed (e.g. back button)
Future<bool?> showConfirmationDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmText = 'Confirm',
  String cancelText = 'Cancel',
  bool destructive = false,
  IconData? icon,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  final confirmColor = destructive ? Colors.red : colorScheme.primary;

  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder:
        (ctx) => AlertDialog(
          title: Row(
            children: [
              if (icon != null) Icon(icon, color: confirmColor, size: 22),
              if (icon != null) const SizedBox(width: 8),
              Flexible(child: Text(title)),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(cancelText),
            ),
            const SizedBox(width: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: confirmColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(confirmText),
            ),
          ],
        ),
  );
}
