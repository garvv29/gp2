import 'package:flutter/material.dart';
import '../../../utils/theme.dart';
import '../../../utils/responsive.dart';
import '../../../utils/app_localizations.dart';
import '../../../models/mother_plant_detail_response.dart';

class PlantOverallProgress extends StatelessWidget {
  final BuildContext context;
  final AppLocalizations l10n;
  final PlantStats stats;
  final List<TrackingHistory> trackingHistory;
  const PlantOverallProgress({required this.context, required this.l10n, required this.stats, required this.trackingHistory, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use stats data directly instead of calculating from trackingHistory
    int completedUploads = stats.completed;
    int pendingUploads = stats.pending;
    int overdueUploads = stats.overdue;
    int totalUploads = stats.totalSchedules;
    final progress = totalUploads > 0 ? completedUploads / totalUploads : 0.0;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context)),
      child: Padding(
        padding: ResponsiveUtils.getResponsiveEdgeInsets(context, mobile: 16, tablet: 20, desktop: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Overall Progress',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 16, tablet: 18, desktop: 20),
                  ),
                ),
                Text(
                  '${(progress * 100).round()}%',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 16, tablet: 18, desktop: 20),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 10,
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 12, tablet: 16, desktop: 20)),
            Row(
              children: [
                Expanded(
                  child: _buildProgressStat(l10n.completed, completedUploads.toString(), AppColors.success, Icons.check_circle),
                ),
                SizedBox(width: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
                Expanded(
                  child: _buildProgressStat(l10n.pending, pendingUploads.toString(), AppColors.warning, Icons.schedule),
                ),
                SizedBox(width: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
                Expanded(
                  child: _buildProgressStat(l10n.overdue, overdueUploads.toString(), AppColors.error, Icons.warning),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressStat(String label, String value, Color color, IconData icon) {
    return Container(
      padding: ResponsiveUtils.getResponsiveEdgeInsets(context, mobile: 8, tablet: 12, desktop: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: ResponsiveUtils.getResponsiveIconSize(context, mobile: 20, tablet: 24, desktop: 28),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 4, tablet: 6, desktop: 8)),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 16, tablet: 18, desktop: 20),
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 12, tablet: 14, desktop: 16),
            ),
          ),
        ],
      ),
    );
  }
}
