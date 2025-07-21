import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../models/mother_plant_detail_response.dart';
import '../../utils/theme.dart';
import '../../utils/app_localizations.dart';
import '../../utils/responsive.dart';
import 'plant_detail_widgets/plant_header.dart';
import 'plant_detail_widgets/overall_progress.dart';
import 'plant_detail_widgets/current_status_card.dart';
import 'plant_detail_widgets/care_instructions.dart';
import '../../services/api_service.dart';

class PlantDetailScreen extends StatefulWidget {
  final MotherPlantDetailData? plantDetailData;
  final int? assignmentId;
  final String? plantStatus; // NEW: plant status from plant_quantity

  const PlantDetailScreen({Key? key, this.plantDetailData, this.assignmentId, this.plantStatus}) : super(key: key);

  @override
  _PlantDetailScreenState createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<PlantDetailScreen> {
  MotherPlantDetailData? _plantDetailData;
  bool _isLoading = false;
  String? _errorMessage;
  
  @override
  void initState() {
    super.initState();
    _plantDetailData = widget.plantDetailData;
    
    // If no plant detail data provided but assignment ID is available, fetch from API
    if (_plantDetailData == null && widget.assignmentId != null) {
      _fetchPlantDetails();
    }
  }

  Future<void> _fetchPlantDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      print('=== PlantDetailScreen API Request ===');
      print('[API REQUEST] Assignment ID (from query param - widget.assignmentId): [1m${widget.assignmentId}[0m');
      print('API Endpoint: mother/plants/${widget.assignmentId}/details');
      final response = await ApiService.getMotherPlantDetails(widget.assignmentId!);
      print('=== PlantDetailScreen API Response ===');
      print('Response Success: [1m${response?.success}[0m');
      print('Response Message: ${response?.message}');
      print('Response Data: ${response?.data}');
      if (response != null && response.success) {
        print('[API RESPONSE] Assignment ID (from response): ${response.data.assignment.id}');
        print('[API RESPONSE] Plant ID (from response): ${response.data.assignment.plant.id}');
        print('Plant Detail Data Retrieved Successfully');
        print('Plant Name: ${response.data.assignment.plant.name}');
        print('Plant Local Name: ${response.data.assignment.plant.localName}');
        print('Assignment Status: ${response.data.assignment.status}');
        print('Stats - Total Schedules: ${response.data.stats.totalSchedules}');
        print('Stats - Completed: ${response.data.stats.completed}');
        print('Stats - Pending: ${response.data.stats.pending}');
        print('Stats - Overdue: ${response.data.stats.overdue}');
        print('Tracking History Count: ${response.data.trackingHistory.length}');
        
        setState(() {
          _plantDetailData = response.data;
          _isLoading = false;
        });
      } else {
        print('API Response Error: ${response?.message ?? 'Unknown error'}');
        setState(() {
          _errorMessage = 'पौधे की जानकारी लोड नहीं हो सकी';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('=== PlantDetailScreen API Exception ===');
      print('Error Type: ${e.runtimeType}');
      print('Error Message: $e');
      print('Stack Trace: ${StackTrace.current}');
      setState(() {
        _errorMessage = 'API Error: $e';
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    // Show loading state
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            l10n.plantDetails,
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 18, tablet: 20, desktop: 22),
            ),
          ),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppColors.primary),
              SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 16, tablet: 20, desktop: 24)),
              Text(
                'पौधे की जानकारी लोड हो रही है...',
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 16, tablet: 18, desktop: 20),
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    // Show error state
    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            l10n.plantDetails,
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 18, tablet: 20, desktop: 22),
            ),
          ),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Padding(
            padding: ResponsiveUtils.getResponsiveEdgeInsets(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: ResponsiveUtils.getResponsiveIconSize(context, mobile: 80, tablet: 100, desktop: 120),
                  color: AppColors.error.withOpacity(0.5),
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 16, tablet: 20, desktop: 24)),
                Text(
                  _errorMessage!,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.text,
                    fontWeight: FontWeight.w600,
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 18, tablet: 20, desktop: 22),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 24, tablet: 32, desktop: 40)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.textSecondary,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('वापस जाएं'),
                    ),
                    SizedBox(width: ResponsiveUtils.getResponsiveGap(context, mobile: 12, tablet: 16, desktop: 20)),
                    ElevatedButton(
                      onPressed: _fetchPlantDetails,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('पुनः प्रयास करें'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    // If plant detail data is null, show a message screen
    if (_plantDetailData == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            l10n.plantDetails,
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 18, tablet: 20, desktop: 22),
            ),
          ),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Padding(
            padding: ResponsiveUtils.getResponsiveEdgeInsets(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.eco,
                  size: ResponsiveUtils.getResponsiveIconSize(context, mobile: 80, tablet: 100, desktop: 120),
                  color: AppColors.primary.withOpacity(0.5),
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 16, tablet: 20, desktop: 24)),
                Text(
                  'पौधे की जानकारी उपलब्ध नहीं है',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.text,
                    fontWeight: FontWeight.w600,
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 18, tablet: 20, desktop: 22),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
                Text(
                  'यह पौधा अभी भी सक्रिय है, लेकिन विस्तृत जानकारी लोड नहीं हो सकी। कृपया बाद में पुनः प्रयास करें।',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 14, tablet: 16, desktop: 18),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 24, tablet: 32, desktop: 40)),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.getResponsiveGap(context, mobile: 24, tablet: 32, desktop: 40),
                      vertical: ResponsiveUtils.getResponsiveGap(context, mobile: 12, tablet: 16, desktop: 20),
                    ),
                  ),
                  child: Text(
                    'वापस जाएं',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 14, tablet: 16, desktop: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l10n.plantDetails,
          style: TextStyle(
            fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 18, tablet: 20, desktop: 22),
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: ResponsiveUtils.getResponsiveEdgeInsets(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plant Header
            PlantHeader(
              context: context,
              l10n: l10n,
              plant: _plantDetailData!.assignment.plant,
              assignment: _plantDetailData!.assignment,
              child: _plantDetailData!.assignment.child,
            ),
            if (widget.plantStatus != null) ...[
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.info, color: Colors.green, size: 18),
                  SizedBox(width: 6),
                  Text('Status: ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[800], fontSize: 14)),
                  Text(widget.plantStatus!, style: TextStyle(color: Colors.green[700], fontSize: 14)),
                ],
              ),
            ],
            SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 16, tablet: 24, desktop: 32)),
            
            // Overall Progress
            PlantOverallProgress(
              context: context,
              l10n: l10n,
              stats: _plantDetailData!.stats,
              trackingHistory: _plantDetailData!.trackingHistory,
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 16, tablet: 24, desktop: 32)),
            
            // Current Monitoring Status
            PlantCurrentStatusCard(
              context: context,
              l10n: l10n,
              stats: _plantDetailData!.stats,
              trackingHistory: _plantDetailData!.trackingHistory,
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 16, tablet: 24, desktop: 32)),
            
            // Monitoring Progress Cards
            Text(
              'मॉनिटरिंग प्रगति',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.text,
                fontWeight: FontWeight.w600,
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 18, tablet: 20, desktop: 22),
              ),
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 12, tablet: 16, desktop: 20)),
            
            // Month 1 Tracking
            _buildMonthSection(_plantDetailData!.trackingHistoryMonthwise.month1, 1, l10n),
            SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 16, tablet: 20, desktop: 24)),
            
            // Month 2 Tracking  
            _buildMonthSection(_plantDetailData!.trackingHistoryMonthwise.month2, 2, l10n),
            SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 16, tablet: 20, desktop: 24)),
            
            // Month 3 Tracking
            _buildMonthSection(_plantDetailData!.trackingHistoryMonthwise.month3, 3, l10n),
            
            SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 16, tablet: 24, desktop: 32)),
            
            // Care Instructions
            PlantCareInstructions(
              context: context,
              l10n: l10n,
              careInstructions: _plantDetailData!.assignment.plant.careInstructions,
            ),
            
            SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 24, tablet: 32, desktop: 40)),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthSection(MonthwiseDetail monthDetail, int monthNumber, AppLocalizations l10n) {
    final assignmentId = _plantDetailData!.assignment.id;
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: ResponsiveUtils.getResponsiveEdgeInsets(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              monthDetail.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 16, tablet: 18, desktop: 20),
              ),
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 4, tablet: 6, desktop: 8)),
            Text(
              monthDetail.description,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 12, tablet: 14, desktop: 16),
              ),
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 12, tablet: 16, desktop: 20)),
            
            // Show weeks if available, otherwise show default upload cards
            if (monthDetail.weeks.isNotEmpty)
              ...monthDetail.weeks.map((week) => _buildWeekCard(week, l10n, assignmentId, monthNumber)).toList()
            else
              _buildDefaultUploadCard(monthDetail, monthNumber, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekCard(WeekDetail week, AppLocalizations l10n, int assignmentId, int monthNumber) {
    Color statusColor;
    IconData statusIcon;
    String statusText;
    
    switch (week.uploadStatus.toLowerCase()) {
      case 'completed':
        statusColor = AppColors.success;
        statusIcon = Icons.check_circle;
        statusText = 'पूर्ण';
        break;
      case 'pending':
        statusColor = AppColors.warning;
        statusIcon = Icons.schedule;
        statusText = 'लंबित';
        break;
      case 'overdue':
        statusColor = AppColors.error;
        statusIcon = Icons.error;
        statusText = 'समय से अधिक';
        break;
      default:
        statusColor = AppColors.textSecondary;
        statusIcon = Icons.help;
        statusText = week.uploadStatus;
    }

    bool isCompleted = week.uploadStatus.toLowerCase() == 'completed';

    // Calculate upload window
    DateTime dueDate = DateTime.tryParse(week.dueDate) ?? DateTime.now();
    DateTime now = DateTime.now();
    DateTime earliest = dueDate.subtract(Duration(days: 3));
    DateTime latest = dueDate;
    bool canUpload = !isCompleted && now.isAfter(earliest) && (now.isBefore(latest) || now.isAtSameMomentAs(latest));

    return Card(
      margin: EdgeInsets.only(bottom: 8),
      elevation: 2,
      child: InkWell(
        onTap: () {
          if (isCompleted && week.photo != null) {
            _showPhotoDetails(week, l10n);
          } else if (canUpload) {
            _showUploadPhotoPopup(context, assignmentId, week.weekNumber, monthNumber);
          }
        },
        borderRadius: BorderRadius.circular(8),
        splashColor: AppColors.primary.withOpacity(0.1),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: statusColor.withOpacity(0.2),
                child: Icon(statusIcon, color: statusColor, size: 20),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      week.weekTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 14, tablet: 16, desktop: 18),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text('Due: ${week.dueDate}', 
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    Text('Status: $statusText', 
                      style: TextStyle(
                        color: statusColor, 
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (canUpload)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.camera_alt, size: 14, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        'फोटो लें',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              else if (isCompleted)
                Icon(Icons.check_circle, color: AppColors.success, size: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _showPhotoDetails(WeekDetail week, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${week.weekTitle} - फोटो विवरण'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (week.photo != null && week.photo!.photoUrl.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Image.network(week.photo!.photoUrl, height: 200),
                ),
              _buildDetailRow('समय सीमा', week.dueDate),
              if (week.completedDate != null)
                _buildDetailRow('पूर्ण दिनांक', week.completedDate!),
              if (week.uploadedDate != null)
                _buildDetailRow('अपलोड दिनांक', week.uploadedDate!),
              if (week.remarks != null && week.remarks!.isNotEmpty)
                _buildDetailRow('टिप्पणी', week.remarks!),
              _buildDetailRow('स्थिति', week.uploadStatus),
            ],
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 10, desktop: 12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 12, tablet: 14, desktop: 16),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 12, tablet: 14, desktop: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultUploadCard(MonthwiseDetail monthDetail, int monthNumber, AppLocalizations l10n) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      elevation: 3,
      shadowColor: AppColors.primary.withOpacity(0.2),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 1),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.2),
                    child: Icon(Icons.camera_alt, color: AppColors.primary, size: 20),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          monthDetail.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: AppColors.text,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'कोई शेड्यूल उपलब्ध नहीं',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.info.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.schedule, color: AppColors.info, size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'इस महीने के लिए अभी तक कोई शेड्यूल नहीं बनाया गया है',
                        style: TextStyle(
                          color: AppColors.info,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  // Helper: Show upload photo popup for a week
  void _showUploadPhotoPopup(BuildContext context, int assignmentId, int weekNumber, int monthNumber) async {
    final TextEditingController remarksController = TextEditingController();
    String? imagePath;
    String? latitude;
    String? longitude;
    bool isLoading = false;
    String? errorMessage;
    bool locationFetched = false;
    final ImagePicker _picker = ImagePicker();

    Future<void> fetchLocation(StateSetter setState) async {
      try {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          setState(() { errorMessage = 'Location services are disabled.'; });
          return;
        }
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            setState(() { errorMessage = 'Location permissions are denied.'; });
            return;
          }
        }
        if (permission == LocationPermission.deniedForever) {
          setState(() { errorMessage = 'Location permissions are permanently denied.'; });
          return;
        }
        final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        setState(() {
          latitude = pos.latitude.toString();
          longitude = pos.longitude.toString();
          locationFetched = true;
        });
      } catch (e) {
        setState(() { errorMessage = 'Failed to get location: $e'; });
      }
    }

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            if (!locationFetched) {
              fetchLocation(setState);
            }
            return AlertDialog(
              title: Text('फोटो अपलोड करें'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(errorMessage!, style: TextStyle(color: Colors.red)),
                      ),
                    Row(
                      children: [
                        Expanded(child: Text('Latitude: ${latitude ?? "-"}')),
                        SizedBox(width: 8),
                        Expanded(child: Text('Longitude: ${longitude ?? "-"}')),
                        IconButton(
                          icon: Icon(Icons.my_location),
                          onPressed: () async {
                            await fetchLocation(setState);
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    if (imagePath != null) ...[
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(imagePath!),
                            height: 140,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                    Row(
                      children: [
                        Expanded(
                          child: imagePath == null
                              ? Column(
                                  children: [
                                    ElevatedButton.icon(
                                      icon: Icon(Icons.camera_alt),
                                      label: Text('कैमरा से फोटो लें'),
                                      onPressed: () async {
                                        final XFile? photo = await _picker.pickImage(source: ImageSource.camera, imageQuality: 85);
                                        if (photo != null) {
                                          setState(() {
                                            imagePath = photo.path;
                                          });
                                        }
                                      },
                                    ),
                                    SizedBox(height: 8),
                                    ElevatedButton.icon(
                                      icon: Icon(Icons.photo_library),
                                      label: Text('गैलरी से फोटो चुनें'),
                                      onPressed: () async {
                                        final XFile? photo = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
                                        if (photo != null) {
                                          setState(() {
                                            imagePath = photo.path;
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Icon(Icons.check, color: Colors.green),
                                    SizedBox(width: 8),
                                    Text('फोटो चुना गया'),
                                  ],
                                ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: remarksController,
                      decoration: InputDecoration(labelText: 'टिप्पणी'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('रद्द करें'),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (imagePath == null || latitude == null || longitude == null) {
                            setState(() {
                              errorMessage = 'कृपया फोटो और लोकेशन चुनें';
                            });
                            return;
                          }
                          setState(() {
                            isLoading = true;
                            errorMessage = null;
                          });
                          final response = await ApiService.uploadMotherPlantAssignment(
                            assignmentId: assignmentId,
                            photoPath: imagePath!,
                            latitude: latitude!,
                            longitude: longitude!,
                            remarks: remarksController.text,
                          );
                          Map<String, dynamic>? aiResult;
                          if (response['success'] == true) {
                            // Call AI prediction API with the same image
                            aiResult = await ApiService.predictPlantImageAI(imagePath!);
                          }
                          setState(() {
                            isLoading = false;
                          });
                          if (response['success'] == true) {
                            Navigator.pop(context);
                            _showUploadSuccessPopup(context, response['data'], aiResult);
                          } else {
                            setState(() {
                              errorMessage = response['message'] ?? 'Upload failed';
                            });
                          }
                        },
                  child: isLoading ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text('अपलोड करें'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Helper: Show upload success popup
  void _showUploadSuccessPopup(BuildContext context, Map<String, dynamic> data, [Map<String, dynamic>? aiResult]) {
    final photo = data['photo'];
    final updatedSchedule = data['updated_schedule'];
    final stats = data['tracking_stats'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.success, size: 28),
            SizedBox(width: 8),
            Text('अपलोड सफल', style: TextStyle(color: AppColors.success)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (photo != null && photo['photo_url'] != null) ...[
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(photo['photo_url'], height: 160, fit: BoxFit.cover),
                  ),
                ),
                SizedBox(height: 12),
              ],
              if (photo != null) ...[
                _buildSuccessDetailRow(Icons.image, 'फोटो ID', photo['id'].toString()),
                _buildSuccessDetailRow(Icons.location_on, 'Latitude', photo['latitude'].toString()),
                _buildSuccessDetailRow(Icons.location_on, 'Longitude', photo['longitude'].toString()),
                _buildSuccessDetailRow(Icons.date_range, 'Upload Date', photo['upload_date'].toString()),
                if (photo['remarks'] != null && photo['remarks'].toString().isNotEmpty)
                  _buildSuccessDetailRow(Icons.comment, 'Remarks', photo['remarks'].toString()),
              ],
              Divider(),
              if (aiResult != null) ...[
                SizedBox(height: 8),
                Text('AI Prediction:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary)),
                SizedBox(height: 6),
                if (aiResult['success'] == true && aiResult['data'] != null) ...[
                  if (aiResult['data']['predicted_class'] != null)
                    _buildSuccessDetailRow(Icons.nature, 'पहचाना गया पेड़', aiResult['data']['predicted_class'].toString()),
                  if (aiResult['data']['confidence'] != null)
                    _buildSuccessDetailRow(Icons.percent, 'AI की विश्वसनीयता',
                      (aiResult['data']['confidence'] is num)
                        ? (aiResult['data']['confidence'] * 100).toStringAsFixed(2) + '%'
                        : aiResult['data']['confidence'].toString()),
                  ...aiResult['data'].entries.where((e) => e.key != 'predicted_class' && e.key != 'confidence').map((e) =>
                    _buildSuccessDetailRow(Icons.info_outline, e.key.toString(), e.value.toString())
                  ),
                ] else ...[
                  Text('AI prediction उपलब्ध नहीं: ' + (aiResult['message'] ?? 'Unknown error'), style: TextStyle(color: Colors.red)),
                ],
                Divider(),
              ],
              if (updatedSchedule != null) ...[
                _buildSuccessDetailRow(Icons.event, 'Schedule ID', updatedSchedule['schedule_id'].toString()),
                _buildSuccessDetailRow(Icons.calendar_today, 'Week Number', updatedSchedule['week_number'].toString()),
                _buildSuccessDetailRow(Icons.calendar_view_month, 'Month Number', updatedSchedule['month_number'].toString()),
                _buildSuccessDetailRow(Icons.info, 'Status', updatedSchedule['status'].toString()),
              ],
              Divider(),
              if (stats != null) ...[
                _buildSuccessDetailRow(Icons.list, 'Total Schedules', stats['total_schedules'].toString()),
                _buildSuccessDetailRow(Icons.check, 'Completed', stats['completed'].toString()),
                _buildSuccessDetailRow(Icons.pending, 'Pending', stats['pending'].toString()),
                _buildSuccessDetailRow(Icons.error, 'Overdue', stats['overdue'].toString()),
                _buildSuccessDetailRow(Icons.calendar_today, 'Next Due Date', stats['next_due_date'].toString()),
                _buildSuccessDetailRow(Icons.timelapse, 'Days Remaining', stats['days_remaining'].toString()),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _fetchPlantDetails(); // Refresh page after upload success
            },
            child: Text('ठीक है'),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          SizedBox(width: 6),
          Text('$label:', style: TextStyle(fontWeight: FontWeight.w500)),
          SizedBox(width: 4),
          Expanded(
            child: Text(value, style: TextStyle(color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }
}