import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_sizes.dart';

class AppLogo extends StatelessWidget {
  final double? size;
  
  const AppLogo({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    final logoSize = size ?? AppSizes.logoMedium;
    
    return Container(
      width: logoSize,
      height: logoSize * AppSizes.logoHeightRatio,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        color: AppColors.blue50,
      ),
      child: Icon(
        Icons.work_outline,
        size: logoSize * AppSizes.iconSizeRatio,
        color: AppColors.blue,
      ),
    );
  }
}
