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
  final Function(TrackingHistory, AppLocalizations)? onUploadTap;
  final Map<String, dynamic>? localPhoto;
  
  const PlantMonitoringPeriodCard({
    required this.context, 
    required this.l10n, 
    required this.trackingHistory, 
    this.onUploadTap, 
    this.localPhoto,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dueDate = DateTime.tryParse(trackingHistory.dueDate);
    final completedDate = trackingHistory.completedDate != null ? DateTime.tryParse(trackingHistory.completedDate!) : null;
    final hasPhoto = (trackingHistory.uploadStatus == 'completed' && trackingHistory.photo != null) || 
                     (trackingHistory.uploadStatus == 'uploaded' && trackingHistory.photo != null) || 
                     localPhoto != null;
    final isCompleted = trackingHistory.uploadStatus == 'completed' || 
                       trackingHistory.uploadStatus == 'uploaded' || 
                       trackingHistory.completedDate != null;
    
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
            color: isCompleted 
              ? Colors.green.shade700 
              : AppColors.text,
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
        onTap: () {
          // If already uploaded/completed, show photo in full screen
          if (isCompleted) {
            if (trackingHistory.photo != null) {
              _showPhotoFullScreen(context, trackingHistory.photo!.photoUrl);
            } else if (localPhoto != null) {
              _showPhotoFullScreen(context, localPhoto!['imagePath'], isLocal: true);
            }
            return;
          }
          
          // Only allow upload if in upload window
          if (_canUpload(trackingHistory.uploadStatus, trackingHistory.dueDate) && onUploadTap != null) {
            onUploadTap!(trackingHistory, l10n);
          }
        },
      ),
    );
  }

  Widget _buildTrailingWidget() {
    final isCompleted = trackingHistory.uploadStatus == 'completed' || 
                       trackingHistory.uploadStatus == 'uploaded' || 
                       trackingHistory.completedDate != null;
    final hasServerPhoto = isCompleted && trackingHistory.photo != null;
    final hasLocalPhoto = localPhoto != null;
    
    // If photo exists (server or local), show photo preview with view indicator
    if (hasServerPhoto || hasLocalPhoto) {
      return Stack(
        children: [
          Container(
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
          ),
          // Show completion checkmark if uploaded
          if (isCompleted)
            Positioned(
              top: 2,
              right: 2,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 10,
                ),
              ),
            ),
        ],
      );
    }
    
    // If no photo but can upload, show upload button
    if (!isCompleted && _canUpload(trackingHistory.uploadStatus, trackingHistory.dueDate) && onUploadTap != null) {
      return ElevatedButton.icon(
        onPressed: () => onUploadTap!(trackingHistory, l10n),
        icon: Icon(Icons.upload, color: Colors.white),
        label: Text('Upload', style: TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      );
    }
    
    // For uploaded without photo, show completed status
    if (isCompleted) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 16),
            SizedBox(width: 4),
            Text(
              'पूर्ण',
              style: TextStyle(
                color: Colors.green,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }
    
    // Otherwise show nothing
    return SizedBox.shrink();
  }

  Color _getStatusColor(String status) {
    // Check for completed status first
    if (status == 'uploaded' || status == 'completed' || trackingHistory.completedDate != null) {
      return Colors.green;  // Always green for completed/uploaded
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
    // Check for completed status first
    if (status == 'uploaded' || status == 'completed' || trackingHistory.completedDate != null) {
      return Icons.check_circle;  // Always show checkmark for completed/uploaded
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
    
    // Block upload if already completed/uploaded
    if (uploadStatus == 'uploaded' || uploadStatus == 'completed') {
      print('Upload blocked - already completed/uploaded');
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

  void _showPhotoFullScreen(BuildContext context, String imagePath, {bool isLocal = false}) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
              ),
              child: ClipRRect(
                borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
                child: InteractiveViewer(
                  panEnabled: true,
                  boundaryMargin: EdgeInsets.all(100),
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: isLocal 
                    ? Image.file(
                        File(imagePath),
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error, color: Colors.white, size: 48),
                                SizedBox(height: 16),
                                Text('फोटो लोड नहीं हो सकी', style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          );
                        },
                      )
                    : Image.network(
                        imagePath,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error, color: Colors.white, size: 48),
                                SizedBox(height: 16),
                                Text('फोटो लोड नहीं हो सकी', style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          );
                        },
                      ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
