import 'package:flutter/material.dart';
import '../../utils/theme.dart';
import '../../utils/responsive.dart';
import '../../utils/app_localizations.dart';

class MotherDashboardLoadingState extends StatelessWidget {
  final BuildContext context;
  final AppLocalizations l10n;
  const MotherDashboardLoadingState({required this.context, required this.l10n, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.primary,
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 12, tablet: 16, desktop: 20)),
          Text(
            l10n.loadingPlants,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 14, tablet: 16, desktop: 18),
            ),
          ),
        ],
      ),
    );
  }
}
