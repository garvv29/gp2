import 'package:flutter/material.dart';
import '../../../utils/theme.dart';
import '../../../utils/responsive.dart';
import '../../../utils/app_localizations.dart';
import '../../../models/mother_plant_detail_response.dart';

class PlantMonitoringPeriodCard extends StatelessWidget {
  final BuildContext context;
  final AppLocalizations l10n;
  final TrackingHistory trackingHistory;
  final Function(TrackingHistory, AppLocalizations) onUploadTap;
  const PlantMonitoringPeriodCard({required this.context, required this.l10n, required this.trackingHistory, required this.onUploadTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dueDate = DateTime.tryParse(trackingHistory.dueDate);
    final completedDate = trackingHistory.completedDate != null ? DateTime.tryParse(trackingHistory.completedDate!) : null;
    return Card(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.getResponsiveGap(context, mobile: 12, tablet: 16, desktop: 20)),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context)),
      child: ListTile(
        title: Text(
          'Week ${trackingHistory.weekNumber}, Month ${trackingHistory.monthNumber}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 16, tablet: 18, desktop: 20),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (dueDate != null)
              Text(
                '${l10n.dueDate}: ${dueDate.day}/${dueDate.month}/${dueDate.year}',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 12, tablet: 14, desktop: 16),
                ),
              ),
            if (completedDate != null)
              Text(
                '${l10n.uploadDate}: ${completedDate.day}/${completedDate.month}/${completedDate.year}',
                style: TextStyle(
                  color: AppColors.success,
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 12, tablet: 14, desktop: 16),
                ),
              ),
            if (trackingHistory.remarks != null && trackingHistory.remarks!.isNotEmpty)
              Text(
                'Remarks: ${trackingHistory.remarks}',
                style: TextStyle(
                  color: AppColors.info,
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 12, tablet: 14, desktop: 16),
                ),
              ),
          ],
        ),
        leading: Container(
          width: ResponsiveUtils.getResponsiveIconSize(context, mobile: 40, tablet: 48, desktop: 56),
          height: ResponsiveUtils.getResponsiveIconSize(context, mobile: 40, tablet: 48, desktop: 56),
          decoration: BoxDecoration(
            color: _getStatusColor(trackingHistory.uploadStatus).withOpacity(0.1),
            borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
          ),
          child: Icon(
            _getStatusIcon(trackingHistory.uploadStatus),
            color: _getStatusColor(trackingHistory.uploadStatus),
            size: ResponsiveUtils.getResponsiveIconSize(context, mobile: 20, tablet: 24, desktop: 28),
          ),
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16),
            vertical: ResponsiveUtils.getResponsiveGap(context, mobile: 4, tablet: 6, desktop: 8),
          ),
          decoration: BoxDecoration(
            color: _getStatusColor(trackingHistory.uploadStatus).withOpacity(0.1),
            borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context, mobile: 6, tablet: 8, desktop: 10),
          ),
          child: Text(
            _getUploadStatusText(trackingHistory.uploadStatus, l10n),
            style: TextStyle(
              color: _getStatusColor(trackingHistory.uploadStatus),
              fontWeight: FontWeight.w500,
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 12, tablet: 14, desktop: 16),
            ),
          ),
        ),
        onTap: () => onUploadTap(trackingHistory, l10n),
      ),
    );
  }

  String _getUploadStatusText(String status, AppLocalizations l10n) {
    switch (status) {
      case 'pending': return l10n.pending;
      case 'uploaded': return l10n.uploaded;
      case 'overdue': return l10n.overdue;
      default: return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending': return AppColors.warning;
      case 'uploaded': return AppColors.success;
      case 'overdue': return AppColors.error;
      default: return AppColors.textSecondary;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending': return Icons.schedule;
      case 'uploaded': return Icons.check_circle;
      case 'overdue': return Icons.warning;
      default: return Icons.help;
    }
  }
}
