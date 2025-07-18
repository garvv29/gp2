import 'package:flutter/material.dart';
import '../../../utils/theme.dart';
import '../../../utils/responsive.dart';
import '../../../utils/app_localizations.dart';
import '../../../models/mother_plant_detail_response.dart';

class PlantHeader extends StatelessWidget {
  final BuildContext context;
  final AppLocalizations l10n;
  final Plant plant;
  final Assignment assignment;
  final Child child;
  const PlantHeader({required this.context, required this.l10n, required this.plant, required this.assignment, required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveUtils.getResponsiveEdgeInsets(context, mobile: 16, tablet: 20, desktop: 24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
      ),
      child: Row(
        children: [
          Container(
            width: ResponsiveUtils.getResponsiveIconSize(context, mobile: 60, tablet: 70, desktop: 80),
            height: ResponsiveUtils.getResponsiveIconSize(context, mobile: 60, tablet: 70, desktop: 80),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
            ),
            child: Icon(
              Icons.eco,
              color: Colors.white,
              size: ResponsiveUtils.getResponsiveIconSize(context, mobile: 30, tablet: 35, desktop: 40),
            ),
          ),
          SizedBox(width: ResponsiveUtils.getResponsiveGap(context, mobile: 16, tablet: 20, desktop: 24)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plant.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 18, tablet: 20, desktop: 22),
                  ),
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 4, tablet: 6, desktop: 8)),
                Text(
                  'Plant ID: ' + assignment.id.toString(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 14, tablet: 16, desktop: 18),
                  ),
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 4, tablet: 6, desktop: 8)),
                Text(
                  'Child: ' + child.childName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 14, tablet: 16, desktop: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
