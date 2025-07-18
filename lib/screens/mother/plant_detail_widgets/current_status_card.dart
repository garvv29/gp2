import 'package:flutter/material.dart';
import '../../../utils/theme.dart';
import '../../../utils/responsive.dart';
import '../../../utils/app_localizations.dart';
import '../../../models/mother_plant_detail_response.dart';

class PlantCurrentStatusCard extends StatelessWidget {
  final BuildContext context;
  final AppLocalizations l10n;
  final PlantStats stats;
  final List<TrackingHistory> trackingHistory;
  const PlantCurrentStatusCard({required this.context, required this.l10n, required this.stats, required this.trackingHistory, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TrackingHistory? nextDue;
    String currentStatus = 'पूर्ण';
    Color statusColor = AppColors.success;
    IconData statusIcon = Icons.check_circle;
    final now = DateTime.now();
    for (var history in trackingHistory) {
      final dueDate = DateTime.tryParse(history.dueDate);
      if (history.uploadStatus == 'pending' && dueDate != null && dueDate.isAfter(now)) {
        if (nextDue == null || dueDate.isBefore(DateTime.parse(nextDue.dueDate))) {
          nextDue = history;
        }
      }
    }
    if (nextDue != null) {
      final dueDate = DateTime.parse(nextDue.dueDate);
      final daysUntilDue = dueDate.difference(now).inDays;
      if (daysUntilDue <= 0) {
        currentStatus = 'आज की तारीख';
        statusColor = AppColors.error;
        statusIcon = Icons.warning;
      } else if (daysUntilDue <= 3) {
        currentStatus = '$daysUntilDue दिन बाकी';
        statusColor = AppColors.warning;
        statusIcon = Icons.schedule;
      } else {
        currentStatus = '$daysUntilDue दिन बाकी';
        statusColor = AppColors.info;
        statusIcon = Icons.info;
      }
    }
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context)),
      child: Padding(
        padding: ResponsiveUtils.getResponsiveEdgeInsets(context, mobile: 16, tablet: 20, desktop: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: ResponsiveUtils.getResponsiveIconSize(context, mobile: 40, tablet: 48, desktop: 56),
                  height: ResponsiveUtils.getResponsiveIconSize(context, mobile: 40, tablet: 48, desktop: 56),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Icon(
                    statusIcon,
                    color: statusColor,
                    size: ResponsiveUtils.getResponsiveIconSize(context, mobile: 20, tablet: 24, desktop: 28),
                  ),
                ),
                SizedBox(width: ResponsiveUtils.getResponsiveGap(context, mobile: 12, tablet: 16, desktop: 20)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentStatus,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 16, tablet: 18, desktop: 20),
                        ),
                      ),
                      if (nextDue != null)
                        Text(
                          '${l10n.dueDate}: ${DateTime.parse(nextDue.dueDate).day}/${DateTime.parse(nextDue.dueDate).month}/${DateTime.parse(nextDue.dueDate).year}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: statusColor,
                            fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 14, tablet: 16, desktop: 18),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (nextDue != null) ...[
              SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 12, tablet: 16, desktop: 20)),
              Container(
                padding: ResponsiveUtils.getResponsiveEdgeInsets(context, mobile: 8, tablet: 12, desktop: 16),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
                  border: Border.all(color: statusColor.withOpacity(0.3)),
                ),
                child: Text(
                  'Next Upload',
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 14, tablet: 16, desktop: 18),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
