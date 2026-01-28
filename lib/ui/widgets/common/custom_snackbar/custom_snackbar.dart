import 'package:mm_inventory_web/ui/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

enum SnackbarVariant { success, error, info, warning }

void setupSnackbarUi() {
  final snackbarService = StackedLocator.instance<SnackbarService>();

  snackbarService.registerCustomSnackbarConfig(
    variant: SnackbarVariant.success,
    config: SnackbarConfig(
      snackPosition: SnackPosition.TOP,
      backgroundColor: kcPrimaryColor,
      textColor: Colors.white,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
      messageTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
      borderRadius: 8,
      dismissDirection: DismissDirection.up,
      margin: const EdgeInsets.all(16),
      animationDuration: const Duration(milliseconds: 300),
    ),
  );

  snackbarService.registerCustomSnackbarConfig(
    variant: SnackbarVariant.error,
    config: SnackbarConfig(
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
      messageTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
      borderRadius: 8,
      dismissDirection: DismissDirection.up,
      margin: const EdgeInsets.all(16),
      animationDuration: const Duration(milliseconds: 300),
    ),
  );

  snackbarService.registerCustomSnackbarConfig(
    variant: SnackbarVariant.info,
    config: SnackbarConfig(
      snackPosition: SnackPosition.TOP,
      backgroundColor: kcMediumGrey,
      textColor: Colors.white,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
      messageTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
      borderRadius: 8,
      dismissDirection: DismissDirection.up,
      margin: const EdgeInsets.all(16),
      animationDuration: const Duration(milliseconds: 300),
    ),
  );

  snackbarService.registerCustomSnackbarConfig(
    variant: SnackbarVariant.warning,
    config: SnackbarConfig(
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.orange,
      textColor: Colors.white,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
      messageTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
      borderRadius: 8,
      dismissDirection: DismissDirection.up,
      margin: const EdgeInsets.all(16),
      animationDuration: const Duration(milliseconds: 300),
    ),
  );
}

void showSuccessSnackbar(String message, {String? title}) {
  StackedLocator.instance<SnackbarService>().showCustomSnackBar(
    variant: SnackbarVariant.success,
    title: title ?? 'Success',
    message: message,
    duration: const Duration(seconds: 3),
  );
}

void showErrorSnackbar(String error, {String? title}) {
  StackedLocator.instance<SnackbarService>().showCustomSnackBar(
    variant: SnackbarVariant.error,
    title: title ?? 'Oops, something went wrong!',
    message: error.toString(),
    duration: const Duration(seconds: 4),
  );
}

void showInfoSnackbar(String message) {
  StackedLocator.instance<SnackbarService>().showCustomSnackBar(
    variant: SnackbarVariant.info,
    title: 'Info',
    message: message,
    duration: const Duration(seconds: 3),
  );
}

void showWarningSnackbar(String message) {
  StackedLocator.instance<SnackbarService>().showCustomSnackBar(
    variant: SnackbarVariant.warning,
    title: 'Warning',
    message: message,
    duration: const Duration(seconds: 3),
  );
}
