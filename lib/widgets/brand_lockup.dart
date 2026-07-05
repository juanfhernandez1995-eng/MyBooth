import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../branding/mybooth_brand.dart';

class BrandLockup extends StatelessWidget {
  final double logoWidth;
  final bool showTagline;
  final CrossAxisAlignment crossAxisAlignment;

  const BrandLockup({
    super.key,
    double? markSize,
    double? logoWidth,
    this.showTagline = true,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  }) : logoWidth = logoWidth ?? markSize ?? 360;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final effectiveLogoWidth = math.min(logoWidth, screenWidth * 0.82);

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          MyBoothBrand.logoOnLightAsset,
          width: effectiveLogoWidth,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
        if (showTagline) ...[
          const SizedBox(height: 10),
          Text(
            MyBoothBrand.tagline,
            textAlign: TextAlign.center,
            style: textTheme.titleMedium?.copyWith(
              color: const Color(0xFF4B5563),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}
