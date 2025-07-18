import 'package:flutter/material.dart';
import '../../utils/theme.dart';
import '../../utils/responsive.dart';
import '../../utils/app_localizations.dart';

class MotherDashboardWelcomeHeader extends StatelessWidget {
  final BuildContext context;
  final AppLocalizations l10n;
  final String userName;
  const MotherDashboardWelcomeHeader({required this.context, required this.l10n, required this.userName, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: ResponsiveUtils.getResponsiveEdgeInsets(context),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(ResponsiveUtils.getResponsiveBorderRadius(context).bottomLeft.x * 2),
          bottomRight: Radius.circular(ResponsiveUtils.getResponsiveBorderRadius(context).bottomRight.x * 2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: ResponsiveUtils.getResponsiveIconSize(context, mobile: 50, tablet: 60, desktop: 70),
                height: ResponsiveUtils.getResponsiveIconSize(context, mobile: 50, tablet: 60, desktop: 70),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
                ),
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: ResponsiveUtils.getResponsiveIconSize(context, mobile: 25, tablet: 30, desktop: 35),
                ),
              ),
              SizedBox(width: ResponsiveUtils.getResponsiveGap(context, mobile: 12, tablet: 16, desktop: 20)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.welcomeBack,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 14, tablet: 16, desktop: 18),
                      ),
                    ),
                    Text(
                      userName,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 18, tablet: 20, desktop: 22),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 12, tablet: 16, desktop: 20)),
          Container(
            padding: ResponsiveUtils.getResponsiveEdgeInsets(context, mobile: 12, tablet: 16, desktop: 20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.eco,
                  color: Colors.white,
                  size: ResponsiveUtils.getResponsiveIconSize(context, mobile: 20, tablet: 24, desktop: 28),
                ),
                SizedBox(width: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
                Expanded(
                  child: Text(
                    l10n.takeCareMessage,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 14, tablet: 16, desktop: 18),
                    ),
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
