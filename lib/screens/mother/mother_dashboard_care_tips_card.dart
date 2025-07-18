import 'package:flutter/material.dart';
import '../../utils/theme.dart';
import '../../utils/responsive.dart';
import '../../utils/app_localizations.dart';

class MotherDashboardCareTipsCard extends StatelessWidget {
  final BuildContext context;
  final AppLocalizations l10n;
  const MotherDashboardCareTipsCard({required this.context, required this.l10n, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: ResponsiveUtils.getResponsiveEdgeInsets(context),
      padding: ResponsiveUtils.getResponsiveEdgeInsets(context, mobile: 12, tablet: 16, desktop: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.accent, AppColors.accent.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
        boxShadow: AppShadows.medium,
      ),
      child: Row(
        children: [
          Container(
            width: ResponsiveUtils.getResponsiveIconSize(context, mobile: 40, tablet: 48, desktop: 56),
            height: ResponsiveUtils.getResponsiveIconSize(context, mobile: 40, tablet: 48, desktop: 56),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
            ),
            child: Icon(
              Icons.lightbulb,
              color: Colors.white,
              size: ResponsiveUtils.getResponsiveIconSize(context, mobile: 20, tablet: 24, desktop: 28),
            ),
          ),
          SizedBox(width: ResponsiveUtils.getResponsiveGap(context, mobile: 12, tablet: 16, desktop: 20)),
          Expanded(
            child: Text(
              l10n.careTip,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 14, tablet: 16, desktop: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
