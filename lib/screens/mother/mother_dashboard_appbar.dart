import 'package:flutter/material.dart';
import '../../utils/theme.dart';
import '../../utils/responsive.dart';
import '../../utils/app_localizations.dart';
import '../../services/api_service.dart';
import '../../models/mother_photos_response.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class MotherDashboardAppBar extends StatefulWidget implements PreferredSizeWidget {
  final BuildContext context;
  final AppLocalizations l10n;
  final VoidCallback onRefresh;
  final VoidCallback onLogout;

  const MotherDashboardAppBar({
    required this.context,
    required this.l10n,
    required this.onRefresh,
    required this.onLogout,
    Key? key,
  }) : super(key: key);

  @override
  State<MotherDashboardAppBar> createState() => _MotherDashboardAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _MotherDashboardAppBarState extends State<MotherDashboardAppBar> {
  bool isDownloading = false;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        widget.l10n.myPlants,
        style: TextStyle(
          fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 18, tablet: 20, desktop: 22),
        ),
      ),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      actions: [
        // Download button
        Container(
          margin: EdgeInsets.only(right: ResponsiveUtils.getResponsiveGap(context, mobile: 4, tablet: 6, desktop: 8)),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
          ),
          child: IconButton(
            icon: isDownloading 
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Icon(
                  Icons.download,
                  size: ResponsiveUtils.getResponsiveIconSize(context, mobile: 20, tablet: 24, desktop: 28),
                ),
            onPressed: isDownloading ? null : _showDownloadOptions,
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: ResponsiveUtils.getResponsiveGap(context, mobile: 4, tablet: 6, desktop: 8)),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
          ),
          child: IconButton(
            icon: Icon(
              Icons.refresh,
              size: ResponsiveUtils.getResponsiveIconSize(context, mobile: 20, tablet: 24, desktop: 28),
            ),
            onPressed: widget.onRefresh,
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
          ),
          child: IconButton(
            icon: Icon(
              Icons.logout,
              size: ResponsiveUtils.getResponsiveIconSize(context, mobile: 20, tablet: 24, desktop: 28),
            ),
            onPressed: widget.onLogout,
          ),
        ),
      ],
    );
  }

  void _showDownloadOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.download, color: AppColors.primary),
            SizedBox(width: 8),
            Text('डाउनलोड विकल्प'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo, color: Colors.blue),
              title: Text('अपनी फोटो'),
              subtitle: Text('माँ और बच्चे की फोटो'),
              onTap: () {
                Navigator.pop(context);
                _downloadMotherPhotos();
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.description, color: Colors.green),
              title: Text('प्रमाण पत्र'),
              subtitle: Text('जन्म प्रमाण पत्र'),
              onTap: () {
                Navigator.pop(context);
                _downloadCertificate();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('बंद करें'),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadMotherPhotos() async {
    setState(() {
      isDownloading = true;
    });
    
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('फोटो की जानकारी प्राप्त हो रही है...'),
          backgroundColor: AppColors.primary,
        ),
      );
      
      // Get mother photos directly (no need for childId as backend uses logged-in user)
      final photos = await ApiService.getMotherPhotos(0); // childId not used in new endpoint
      
      if (photos != null && photos.photos.isNotEmpty) {
        _showPhotosDialog(photos);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('कोई फोटो उपलब्ध नहीं है'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('फोटो डाउनलोड में त्रुटि: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() {
        isDownloading = false;
      });
    }
  }

  Future<void> _downloadCertificate() async {
    setState(() {
      isDownloading = true;
    });
    
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('प्रमाण पत्र डाउनलोड हो रहा है...'),
          backgroundColor: AppColors.primary,
        ),
      );
      
      // TODO: API call to get certificate
      // For now, show message
      await Future.delayed(Duration(seconds: 2));
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('अभी प्रमाण पत्र उपलब्ध नहीं है'),
          backgroundColor: Colors.orange,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('प्रमाण पत्र डाउनलोड में त्रुटि: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() {
        isDownloading = false;
      });
    }
  }

  void _showPhotosDialog(MotherPhotosData photos) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.photo_library, color: AppColors.primary),
            SizedBox(width: 8),
            Text('आपकी फोटो (${photos.totalPhotos})'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: photos.photos.map((photo) => 
              _buildPhotoItem(photo)
            ).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('बंद करें'),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoItem(MotherPhotoItem photo) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            photo.photoType == 'certificate' ? Icons.description : Icons.eco,
            color: photo.photoType == 'certificate' ? Colors.blue : Colors.green,
            size: 20,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  photo.displayName,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
                Text(
                  '${photo.formattedFileSize} • ${_formatDate(photo.uploadDate)}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => _downloadPhoto(photo),
            icon: Icon(Icons.download, size: 16),
            label: Text('डाउनलोड', style: TextStyle(fontSize: 12)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              minimumSize: Size(80, 32),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  Future<void> _downloadPhoto(MotherPhotoItem photo) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${photo.displayName} डाउनलोड हो रही है...'),
          backgroundColor: AppColors.primary,
        ),
      );
      
      // Check storage permission
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
        if (!status.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Storage permission की जरूरत है'),
              backgroundColor: AppColors.error,
            ),
          );
          return;
        }
      }
      
      final response = await http.get(Uri.parse(photo.photoUrl));
      
      if (response.statusCode == 200) {
        Directory? downloadsDirectory;
        
        if (Platform.isAndroid) {
          try {
            downloadsDirectory = Directory('/storage/emulated/0/Download');
            if (!await downloadsDirectory.exists()) {
              downloadsDirectory = await getExternalStorageDirectory();
            }
          } catch (e) {
            downloadsDirectory = await getExternalStorageDirectory();
          }
        } else {
          downloadsDirectory = await getApplicationDocumentsDirectory();
        }
        
        if (downloadsDirectory != null) {
          final fileName = 'mother_${photo.photoType}_${photo.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
          final file = File('${downloadsDirectory.path}/$fileName');
          await file.writeAsBytes(response.bodyBytes);
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${photo.displayName} सफलतापूर्वक save हो गई!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
        } else {
          throw Exception('Storage directory not accessible');
        }
      } else {
        throw Exception('Download failed with status: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('डाउनलोड में त्रुटि: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
