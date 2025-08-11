import 'package:flutter/material.dart';
import 'dart:io';
import '../../../utils/theme.dart';
import '../../../utils/responsive.dart';
import '../../../utils/app_localizations.dart';
import '../../../models/mother_plant_detail_response.dart';

class PlantMonitoringPeriodCard extends StatelessWidget {
  final BuildContext context;
  final AppLocalizations l10n;
  final TrackingHistory trackingHistory;
  final Function(TrackingHistory, AppLocalizations) onUploadTap;
  final Map<String, dynamic>? localPhoto;
  
  const PlantMonitoringPeriodCard({
    required this.context, 
    required this.l10n, 
    required this.trackingHistory, 
    required this.onUploadTap, 
    this.localPhoto,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dueDate = DateTime.tryParse(trackingHistory.dueDate);
    final completedDate = trackingHistory.completedDate != null ? DateTime.tryParse(trackingHistory.completedDate!) : null;
    final hasPhoto = (trackingHistory.uploadStatus == 'uploaded' && trackingHistory.photo != null) || localPhoto != null;
    
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
            size: ResponsiveUtils.getResponsiveIconSize(context, mobile: 24, tablet: 28, desktop: 32),
          ),
        ),
        trailing: _buildTrailingWidget(),
        onTap: (trackingHistory.uploadStatus == 'uploaded' || trackingHistory.completedDate != null) ? null :
          _canUpload(trackingHistory.uploadStatus, trackingHistory.dueDate)
            ? () => onUploadTap(trackingHistory, l10n)
            : null,
      ),
    );
  }

  Widget _buildTrailingWidget() {
    final hasServerPhoto = trackingHistory.uploadStatus == 'uploaded' && trackingHistory.photo != null;
    final hasLocalPhoto = localPhoto != null;
    
    // If photo exists (server or local), show photo preview
    if (hasServerPhoto || hasLocalPhoto) {
      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: hasServerPhoto ? 
            Image.network(
              trackingHistory.photo!.photoUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.border,
                  child: Icon(Icons.broken_image, color: AppColors.textSecondary, size: 20),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: AppColors.border,
                  child: Center(
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                );
              },
            ) : 
            Image.file(
              File(localPhoto!['imagePath']),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.border,
                  child: Icon(Icons.broken_image, color: AppColors.textSecondary, size: 20),
                );
              },
            ),
        ),
      );
    }
    
    // If no photo but can upload, show upload button
    if ((trackingHistory.uploadStatus != 'uploaded' && trackingHistory.completedDate == null) &&
        _canUpload(trackingHistory.uploadStatus, trackingHistory.dueDate)) {
      return ElevatedButton.icon(
        onPressed: () => onUploadTap(trackingHistory, l10n),
        icon: Icon(Icons.upload, color: Colors.white),
        label: Text('Upload', style: TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      );
    }
    
    // Otherwise show nothing
    return SizedBox.shrink();
  }

  Color _getStatusColor(String status) {
    if (status == 'uploaded' || trackingHistory.completedDate != null) {
      return Colors.green;  // Always green for uploaded
    }

    // For pending and overdue, check the date
    final dueDate = DateTime.tryParse(trackingHistory.dueDate);
    if (dueDate == null) return AppColors.textSecondary;
    
    final now = DateTime.now();
    final weekBefore = dueDate.subtract(const Duration(days: 7));
    
    if (now.isBefore(dueDate)) {
      if (now.isAfter(weekBefore)) {
        return Colors.orange; // Time to upload (within the week window)
      } else {
        return Colors.grey; // Future week
      }
    } else {
      return Colors.red; // Past due date
    }
  }

  IconData _getStatusIcon(String status) {
    if (status == 'uploaded' || trackingHistory.completedDate != null) {
      return Icons.check_circle;  // Always show checkmark for uploaded
    }

    // For pending and overdue, check the date
    final dueDate = DateTime.tryParse(trackingHistory.dueDate);
    if (dueDate == null) return Icons.help;
    
    final now = DateTime.now();
    final weekBefore = dueDate.subtract(const Duration(days: 7));
    
    if (now.isBefore(dueDate)) {
      if (now.isAfter(weekBefore)) {
        return Icons.schedule; // Time to upload (within the week window)
      } else {
        return Icons.schedule; // Future week
      }
    } else {
      return Icons.warning; // Past due date
    }
  }

  // Add this method to check if upload is allowed
  bool _canUpload(String uploadStatus, String dueDateStr) {
    print('Checking upload status: $uploadStatus, Due date: $dueDateStr');
    
    if (uploadStatus == 'uploaded') {
      print('Upload blocked - already uploaded');
      return false;
    }
    
    final dueDate = DateTime.tryParse(dueDateStr);
    if (dueDate == null) {
      print('Upload blocked - invalid date');
      return false;
    }

    final now = DateTime.now();
    final weekBefore = dueDate.subtract(const Duration(days: 6));
    final dayAfter = dueDate.add(const Duration(days: 1));
    
    final bool isInUploadWindow = now.isAfter(weekBefore) && now.isBefore(dayAfter);
    print('''
Upload window details:
- Current time: ${now.toLocal()}
- Upload window starts: ${weekBefore.toLocal()}
- Due date: ${dueDate.toLocal()}
- Upload window ends: ${dayAfter.toLocal()}
- Days until due: ${dueDate.difference(now).inDays}
- Is in upload window: $isInUploadWindow
''');
    
    return isInUploadWindow;
  }
}
