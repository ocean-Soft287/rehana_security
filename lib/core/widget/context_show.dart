import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rehana_security/core/color/colors.dart';
import 'package:rehana_security/core/router/app_router.dart';




extension ContextExtensions on BuildContext {
  double get screenHeight => MediaQuery.of(this).size.height;

  double get screenWidth => MediaQuery.of(this).size.width;

  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => Theme.of(this).textTheme;

  bool get isKeyboardVisible => MediaQuery.of(this).viewInsets.bottom != 0;

  double get keyboardHeight => MediaQuery.of(this).viewInsets.bottom;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  Orientation get orientation => MediaQuery.of(this).orientation;
  bool get isArabic => Localizations.localeOf(this).languageCode == 'ar';

  TextDirection get textDirection =>
      isArabic ? TextDirection.rtl : TextDirection.ltr;
  TextDirection get oppositeTextDirection  =>
      !isArabic ? TextDirection.rtl : TextDirection.ltr;

  FocusScopeNode get foucsScopeNode => FocusScope.of(this);


  void showErrorMessage(String message) {
    ScaffoldMessenger.of(this).clearSnackBars();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        showCloseIcon: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                message,
                style: Theme.of(this).textTheme.displaySmall!.copyWith(color: Colors.red,fontSize: 15.sp),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.error,
              color: Colors.red,
            ),
          ],
        ),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        margin: const EdgeInsets.only(bottom: 25, right: 20, left: 20),
      ),
    );
  }

  void showSuccessMessage(
      String message, {
        Color color = Colors.green,
        IconData icon = Icons.check_circle,
      }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
          showCloseIcon: false,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  message,
                  style:
                  Theme.of(this).textTheme.titleLarge!.copyWith(color: color,fontSize: 15.sp),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 10),
              Icon(icon, color: color),
            ],
          ),
          backgroundColor: Colors.white,
          behavior: SnackBarBehavior.floating,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          margin: const EdgeInsets.only(bottom: 25, right: 20, left: 20),
        ),
      );
    });
  }

  void showSuccessDialog(String text) {
    showDialog(
      context: this,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        content: Text(
          text,
          style: Theme.of(this).textTheme.titleLarge!.copyWith(color: Colors.green),
          textAlign: TextAlign.center,
        ),
        contentPadding: const EdgeInsets.all(20).copyWith(bottom: 40),
      ),
    );
  }
  void showTopSnackBar({
    required Widget child,
    required Color backgroundColor,
    IconData icon = Icons.error,
    Duration duration = const Duration(seconds: 2),
  }) {
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: 16,
        right: 16,
        top: MediaQuery.of(context).padding.top + 10,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: child),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(this).insert(overlayEntry);

    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }
  Future<void> showLoadingDialog({
    String? message,
    bool canPop = false,
    bool barrierDismissible = false,
  })async {
    showDialog(
      context: this,
      useRootNavigator: true,
      barrierDismissible: barrierDismissible,
      builder: (_) => PopScope(
        canPop: canPop,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator.adaptive(),
              const SizedBox(height: 10,),
              Text(
                message ?? "تحميل البيانات",
                style: theme.textTheme.titleLarge!,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          contentPadding: const EdgeInsets.all(20).copyWith(bottom: 40),
        ),
      ),
    );
  }
  Future<void> showRatingDialogue({
    required Function(int rating, String comment) onConfirm,
  }) async {
    int rating = 0;
    final TextEditingController commentController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: this,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "إضافة تقييم",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(dialogContext).pop(),
              )
            ],
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ⭐ Rating widget
                  StatefulBuilder(
                    builder: (context, setState) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return IconButton(
                            icon: Icon(
                              index < rating ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                              size: 36,
                            ),
                            onPressed: () {
                              setState(() {
                                rating = index + 1;
                              });
                            },
                          );
                        }),
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  // 📝 Comment field
                  TextFormField(
                    controller: commentController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "اكتب تعليقك هنا...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "برجاء كتابة تعليق";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(

              child: const Text("إلغاء",style: TextStyle(color: Colors.red),),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: AppColors.bIcon,
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  fixedSize: Size(screenWidth * 0.3,screenHeight * 0.05),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  )
              ),
              onPressed: () {
                if (formKey.currentState!.validate() && rating > 0) {
                  onConfirm(rating, commentController.text.trim());
                  Navigator.of(dialogContext).pop();
                } else if (rating == 0) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text("من فضلك اختر عدد النجوم")),
                  );
                }
              },
              child:  Text("إرسال",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15.sp),),
            ),

          ],
        );
      },
    );
  }
}

Future<bool> showConfirmDialogGlobal({
  String title = "تأكيد",
  String message = "هل أنت متأكد؟",
  String confirmText = "تأكيد",
  String cancelText = "إلغاء",
}) async {
  final ctx = AppRouter.router.configuration.navigatorKey.currentContext;
  if (ctx == null) return false;
  final result = await showGeneralDialog<bool>(
    context: ctx,
    barrierDismissible: false,
    barrierLabel: 'Confirm',
    barrierColor: Colors.black54,
    useRootNavigator: true,
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (dialogContext, _, __) {
      return const SizedBox.shrink();
    },
    transitionBuilder: (dialogContext, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic, reverseCurve: Curves.easeInCubic);
      final fade = Tween<double>(begin: 0, end: 1).animate(curved);
      final scale = Tween<double>(begin: 0.95, end: 1).animate(curved);
      final offset = Tween<Offset>(begin: const Offset(0, 0.02), end: Offset.zero).animate(curved);

      return FadeTransition(
        opacity: fade,
        child: SlideTransition(
          position: offset,
          child: ScaleTransition(
            scale: scale,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                title: Text(title),
                content: Text(
                  message,
                  textAlign: TextAlign.center,
                ),
                actionsAlignment: MainAxisAlignment.spaceBetween,
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(false),
                    child: Text(cancelText, style: TextStyle(color: Colors.red,fontSize: 15.sp)),
                  ),
                  FilledButton(
                    style: FilledButton.styleFrom( backgroundColor: AppColors.bIcon,),
                    onPressed: () => Navigator.of(dialogContext).pop(true),
                    child: Text(confirmText,style: TextStyle(fontSize: 15.sp),),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
  return result ?? false;
}