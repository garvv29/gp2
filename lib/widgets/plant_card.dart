import 'package:flutter/material.dart';
import '../models/plant.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';
import '../utils/app_localizations.dart';
import '../utils/responsive.dart';

class PlantCard extends StatelessWidget {
  final Plant plant;
  final VoidCallback onTap;

  const PlantCard({Key? key, required this.plant, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final plantEmoji = AppConstants.plantEmojis[plant.plantNumber - 1];
    final hasRecentUpload = plant.lastUploadDate != null;

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.surface, AppColors.surfaceVariant],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
        boxShadow: AppShadows.medium,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
          child: Container(
            padding: ResponsiveUtils.getResponsiveEdgeInsets(context, mobile: 12, tablet: 16, desktop: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Plant emoji with background
                Container(
                  width: ResponsiveUtils.getResponsiveIconSize(context, mobile: 70, tablet: 80, desktop: 90),
                  height: ResponsiveUtils.getResponsiveIconSize(context, mobile: 70, tablet: 80, desktop: 90),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
                  ),
                  child: Center(
                    child: Text(
                      plantEmoji,
                      style: TextStyle(
                        fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 35, tablet: 40, desktop: 45),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
                
                // Plant title
                Text(
                  '${l10n.plant} ${plant.plantNumber}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.text,
                    fontWeight: FontWeight.w600,
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 14, tablet: 16, desktop: 18),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 4, tablet: 8, desktop: 12)),
                
                // Status indicator
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16),
                    vertical: ResponsiveUtils.getResponsiveGap(context, mobile: 4, tablet: 8, desktop: 12),
                  ),
                  decoration: BoxDecoration(
                    color: hasRecentUpload 
                        ? AppColors.success.withOpacity(0.1)
                        : AppColors.warning.withOpacity(0.1),
                    borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context, mobile: 6, tablet: 8, desktop: 10),
                    border: Border.all(
                      color: hasRecentUpload 
                          ? AppColors.success.withOpacity(0.3)
                          : AppColors.warning.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        hasRecentUpload ? Icons.check_circle : Icons.schedule,
                        size: ResponsiveUtils.getResponsiveIconSize(context, mobile: 14, tablet: 16, desktop: 18),
                        color: hasRecentUpload ? AppColors.success : AppColors.warning,
                      ),
                      SizedBox(width: ResponsiveUtils.getResponsiveGap(context, mobile: 2, tablet: 4, desktop: 6)),
                      Text(
                        hasRecentUpload
                            ? l10n.updated
                            : l10n.pending,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: hasRecentUpload ? AppColors.success : AppColors.warning,
                          fontWeight: FontWeight.w500,
                          fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 12, tablet: 14, desktop: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 4, tablet: 8, desktop: 12)),
                
                // Last upload info
                Text(
                  hasRecentUpload
                      ? '${l10n.lastUpload}: ${_formatDate(plant.lastUploadDate!)}'
                      : l10n.noUploadsYet,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 12, tablet: 14, desktop: 16),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date).inDays;

      if (difference == 0) return 'Today';
      if (difference == 1) return 'Yesterday';
      if (difference < 7) return '$difference days ago';
      if (difference < 30) return '${(difference / 7).floor()} weeks ago';
      return '${(difference / 30).floor()} months ago';
    } catch (e) {
      return dateString;
    }
  }
}
