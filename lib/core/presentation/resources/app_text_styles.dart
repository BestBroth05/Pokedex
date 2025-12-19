import 'package:flutter/material.dart';

import 'app_colors.dart';

mixin AppTextStyles {
  static const TextStyle title = TextStyle(
    fontSize: 32,
    color: AppColors.primary50,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle subTitle = TextStyle(
    fontSize: 24,
    color: AppColors.primary50,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.primary50,
  );
}
