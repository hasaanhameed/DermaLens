import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../theme/app_colors.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Container(
      color: isLight ? AppColors.sand : AppColors.elevated,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'DermaLens',
            style: TextStyle(
              fontFamily: 'Raleway',
              fontSize: 22,
              fontWeight: FontWeight.w400,
              color: isLight ? AppColors.deepVoid : AppColors.sand,
            ),
          ),
          Lottie.asset(
            'lib/assets/animations/liquid_circle.json',
            width: 40,
            height: 40,
          ),
        ],
      ),
    );
  }
}
