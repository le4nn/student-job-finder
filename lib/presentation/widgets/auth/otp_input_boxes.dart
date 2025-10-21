import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radii.dart';
import '../../../core/constants/app_text_styles.dart';

class OtpInputBoxes extends StatelessWidget {
  final String otpCode;
  final int length;

  const OtpInputBoxes({
    super.key,
    required this.otpCode,
    this.length = 6,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(length, (index) {
        final hasValue = otpCode.length > index;
        
        return Container(
          width: 50.w,
          height: 50.h,
          decoration: BoxDecoration(
            border: Border.all(
              color: hasValue ? colorScheme.primary : AppColors.grey300,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(AppRadii.md),
            color: AppColors.grey50,
          ),
          child: Center(
            child: Text(
              hasValue ? otpCode[index] : '',
              style: AppTextStyles.headlineSmall.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }),
    );
  }
}
