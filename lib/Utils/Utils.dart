import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/main.dart';
import 'package:toastification/toastification.dart';
// import 'package:sp_util/sp_util.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toast_service.dart';

enum ToastType {
  /// info toast to show some information - blue color - icon: info
  info,

  /// warning toast to show some warning - yellow color - icon: warning
  warning,

  /// error toast to show some error - red color - icon: error
  success,

  /// success toast to show some success - green color - icon: success
  error,
}

class Utils {
  static final Connectivity _connectivity = Connectivity();
  static bool _isConnected = false;

  static Utils get instance => _getInstance();
  static Utils? _instance;

  static Utils _getInstance() {
    _instance ??= Utils();
    return _instance!;
  }

  static jumpPage(Widget widget, {void Function()? than}) {
    Navigator.push(Get.context!, MaterialPageRoute(builder: (context) {
      return widget;
    })).then((value) {
      if (than != null) {
        than();
      }
    });
  }

  static canPop() {
    if (Navigator.canPop(Get.context!)) {
      Navigator.pop(Get.context!);
    }
  }

  static pushReplacement(Widget widget) {
    Navigator.pushAndRemoveUntil(
      Get.context!,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 0),
        pageBuilder: (context, Animation<double> animation,
            Animation secondaryAnimation) {
          return widget;
        },
      ),
      (route) => false,
    );
  }

  /// Pass string [url] Example: "https://website.com".
  static launchURL({
    String? url,
    LaunchMode mode = LaunchMode.platformDefault,
    Function? onLaunchFail,
  }) async {
    try {
      await launchUrlString(url ?? '', mode: mode);
    } catch (e) {
      if (onLaunchFail != null) {
        onLaunchFail();
      }
      print('Could not launch $url');
    }
  }

// Method to check current connectivity status
  // static Future<bool> isOnline() async {
  //   try {
  //     final connectivityResult = await _connectivity.checkConnectivity();

  //     // Update connection status based on connectivity result
  //     _isConnected = connectivityResult == ConnectivityResult.wifi ||
  //         connectivityResult == ConnectivityResult.mobile;

  //     // Check internet connection for further validation
  //     return _isConnected && await isConnectedToInternet();
  //   } catch (e) {
  //     print('Error checking connectivity: $e');
  //     return false;
  //   }
  // }

  // Method to check actual internet connection
  static Future<bool> isConnectedToInternet(BuildContext context) async {
    try {
      final connectionChecker = InternetConnectionChecker();
      _isConnected = await connectionChecker.hasConnection;
      final subscription = connectionChecker.onStatusChange.listen(
        (InternetConnectionStatus status) {
          _isConnected = status == InternetConnectionStatus.connected;
          isOnline = _isConnected;
          showConnectionStatus(isOnline: _isConnected, context: context);
        },
      );
      isOnline = _isConnected;
      // showConnectionStatus(isOnline: _isConnected, context: context);
      // subscription.cancel(); // Ensure subscription is cancelled after use
      return _isConnected;
    } catch (e) {
      print('Error checking internet connection: $e');
      return false;
    }
  }

  static showConnectionStatus({bool? isOnline, BuildContext? context}) async {
    Utils.toastNotification(
      context: context,
      title: isOnline! ? "You are Online!" : "You are Offline!",
      type: isOnline ? ToastificationType.success : ToastificationType.warning,
      style: ToastificationStyle.flatColored,
    );
    // Utils.toastMessage('Testing toast!', ToastificationType.warning, context);
  }

  static toastMessage({String? title, ToastType? type, BuildContext? context}) {
    Color? bgColor = AppColors.primaryColor;
    if (type!.name == "success") {
      bgColor = AppColors.primaryColor.withOpacity(0.6);
    } else if (type.name == "error") {
      bgColor = AppColors.alertColor.withOpacity(0.6);
    } else if (type.name == "warning") {
      bgColor = AppColors.secondaryColor;
    } else if (type.name == "info") {
      bgColor = AppColors.darkColor;
    }

    ToastService.showToast(
      context!,
      isClosable: true,
      backgroundColor: bgColor,
      shadowColor: bgColor.withOpacity(0.4),
      length: ToastLength.medium,
      expandedHeight: 100,
      message: title ?? "This is a message toast 👋😎!",
      messageStyle: const TextStyle(color: AppColors.bgColor),
      leading: const Icon(Icons.messenger, color: AppColors.bgColor),
      slideCurve: Curves.elasticInOut,
      positionCurve: Curves.bounceOut,
      dismissDirection: DismissDirection.none,
    );
  }

  static toastNotification({
    String? title,
    ToastificationType? type,
    ToastificationStyle? style,
    BuildContext? context,
  }) {
    Color? bgColor = AppColors.primaryColor;
    if (type!.name == "success") {
      bgColor = AppColors.primaryColor;
    } else if (type.name == "error") {
      bgColor = AppColors.alertColor;
    } else if (type.name == "warning") {
      bgColor = AppColors.secondaryColor;
    }
    toastification.show(
      context: context,
      type: type ?? ToastificationType.success,
      style: style ?? ToastificationStyle.flat,
      autoCloseDuration: const Duration(seconds: 5),
      title: Text(title ?? "Online!"),
      alignment: Alignment.topCenter,
      direction: TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 300),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      // icon: const Icon(Icons.check),
      showIcon: true,
      primaryColor: bgColor,
      // backgroundColor: AppColors.primaryColor.withOpacity(0.5),
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(15),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        )
      ],
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
      // callbacks: ToastificationCallbacks(
      //   onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
      //   onCloseButtonTap: (toastItem) =>
      //       print('Toast ${toastItem.id} close button tapped'),
      //   onAutoCompleteCompleted: (toastItem) =>
      //       print('Toast ${toastItem.id} auto complete completed'),
      //   onDismissed: (toastItem) => print('Toast ${toastItem.id} dismissed'),
      // ),
    );
  }
}
