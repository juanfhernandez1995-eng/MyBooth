import 'package:flutter/material.dart';

import '../branding/mybooth_brand.dart';

class BrandMark extends StatelessWidget {
  final double size;

  const BrandMark({
    super.key,
    this.size = 72,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      MyBoothBrand.markAsset,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
