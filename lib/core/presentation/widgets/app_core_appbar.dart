import 'package:flutter/material.dart';

import '../resources/app_colors.dart';
import '../resources/app_text_styles.dart';

class AppCoreAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppCoreAppBar({
    super.key,
    required this.title,
    this.showBack = true,
    this.actions = const [],
  });
  final String title;
  final bool showBack;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ---------- APPBAR PRINCIPAL ----------
        AppBar(
          backgroundColor: AppColors.primary,
          automaticallyImplyLeading: false,
          leading: showBack
              ? IconButton(
                  icon: const Icon(Icons.chevron_left),
                  color: AppColors.primary100,
                  onPressed: () => Navigator.pop(context),
                )
              : null,
          centerTitle: true,
          title: Text(title, style: AppTextStyles.title),
          actions: actions,
        ),

        // ---------- LÍNEA DEBAJO (1 PX) ----------
        Container(
          height: 1, // 👈 super delgada
          color: AppColors.primary100,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}
