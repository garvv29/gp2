import 'package:flutter/material.dart';
import '../../../utils/theme.dart';
import '../../../utils/responsive.dart';
import '../../../utils/app_localizations.dart';
import '../../../models/mother_plant_detail_response.dart';

class PlantCareInstructions extends StatelessWidget {
  final BuildContext context;
  final AppLocalizations l10n;
  final String careInstructions;
  const PlantCareInstructions({required this.context, required this.l10n, required this.careInstructions, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context)),
      child: Padding(
        padding: ResponsiveUtils.getResponsiveEdgeInsets(context, mobile: 16, tablet: 20, desktop: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.plantCareInstructions,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 16, tablet: 18, desktop: 20),
              ),
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 12, tablet: 16, desktop: 20)),
            Text(
              careInstructions,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 14, tablet: 16, desktop: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
