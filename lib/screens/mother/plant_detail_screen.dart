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
import 'plant_detail_widgets/monitoring_period.dart';

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
    final trackingHistory = TrackingHistory(
      scheduleId: week.scheduleId,
      weekNumber: week.weekNumber,
      monthNumber: monthNumber,
      dueDate: week.dueDate,
      uploadStatus: week.uploadStatus.toLowerCase(),
      completedDate: week.completedDate,
      remarks: week.remarks ?? '',
      photo: week.photo
    );

    // If photo exists, make card clickable to show photo details
    if (week.uploadStatus.toLowerCase() == 'uploaded' && week.photo != null) {
      return GestureDetector(
        onTap: () => _showPhotoDetails(week, l10n),
        child: PlantMonitoringPeriodCard(
          context: context,
          l10n: l10n,
          trackingHistory: trackingHistory,
          onUploadTap: (history, l10n) {
            _showUploadPhotoPopup(context, assignmentId, history.weekNumber, monthNumber);
          },
        ),
      );
    }

    // Otherwise show standard monitoring card with upload functionality
    return PlantMonitoringPeriodCard(
      context: context,
      l10n: l10n,
      trackingHistory: trackingHistory,
      onUploadTap: (history, l10n) {
        _showUploadPhotoPopup(context, assignmentId, history.weekNumber, monthNumber);
      },
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
      margin: EdgeInsets.only(bottom: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
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
              Text(
                monthDetail.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 16, tablet: 18, desktop: 20),
                ),
              ),
              SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
              Text(
                monthDetail.description,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 12, tablet: 14, desktop: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to check if AI predicted plant matches expected plant
  bool _isCorrectPlantDetected(String predictedClass, String expectedPlant) {
    final predicted = predictedClass.toLowerCase().trim();
    final expected = expectedPlant.toLowerCase().trim();
    
    print('[PLANT DETECTION] Predicted: "$predicted"');
    print('[PLANT DETECTION] Expected: "$expected"');
    
    // Create comprehensive mapping for all plants with their AI detection keywords
    final plantKeywords = {
      // Mango (आम) - Only mango specific keywords
      'mango': ['mango', 'mangifera'],
      'आम': ['mango', 'aam', 'आम', 'mangifera'],
      'aam': ['mango', 'aam', 'आम', 'mangifera'],
      
      // Guava (अमरूद) - Only guava specific keywords  
      'guava': ['guava', 'psidium'],
      'अमरूद': ['guava', 'amrud', 'अमरूद', 'psidium'],
      'amrud': ['guava', 'amrud', 'अमरूद', 'psidium'],
      'aamrud': ['guava', 'amrud', 'अमरूद', 'psidium'], // Fix for aamrud
      
      // Lemon (नींबू)
      'lemon': ['lemon', 'citrus', 'lime'],
      'नींबू': ['lemon', 'nimbu', 'नींबू', 'citrus', 'lime'],
      'nimbu': ['lemon', 'nimbu', 'नींबू', 'citrus', 'lime'],
      
      // Pomegranate (अनार)
      'pomegranate': ['pomegranate', 'punica'],
      'अनार': ['pomegranate', 'anar', 'अनार', 'punica'],
      'anar': ['pomegranate', 'anar', 'अनार', 'punica'],
      
      // Papaya (पपीता)
      'papaya': ['papaya', 'carica'],
      'पपীता': ['papaya', 'papita', 'पपीता', 'carica'],
      'papita': ['papaya', 'papita', 'पपीता', 'carica'],
      
      // Moringa (मुनगा/सहजन)
      'moringa': ['moringa', 'drumstick'],
      'munga': ['moringa', 'munga', 'munaga', 'sahjan', 'मुनगा', 'सहजन', 'drumstick'],
      'मुनगा': ['moringa', 'munga', 'munaga', 'sahjan', 'मुनगा', 'सहजन', 'drumstick'],
      'सहजन': ['moringa', 'munga', 'munaga', 'sahjan', 'मुनगा', 'सहजन', 'drumstick'],
      
      // Amla (आंवला)
      'amla': ['amla', 'gooseberry', 'emblica', 'amalaki'],
      'आंवला': ['amla', 'aavla', 'आंवला', 'gooseberry', 'emblica', 'amalaki'],
      'aavla': ['amla', 'aavla', 'आंवला', 'gooseberry', 'emblica', 'amalaki'],
      'gooseberry': ['amla', 'aavla', 'आंवला', 'gooseberry', 'emblica', 'amalaki'],
    };
    
    // Find the EXACT expected plant type by checking for complete word matches
    List<String> expectedPlantNames = [];
    for (String plantKey in plantKeywords.keys) {
      // Use exact matching to avoid partial matches like "aam" in "aamrud"
      final plantKeyLower = plantKey.toLowerCase();
      if (expected == plantKeyLower || 
          expected.split(' ').contains(plantKeyLower) ||
          expected.split(' ').any((word) => word == plantKeyLower)) {
        expectedPlantNames.add(plantKey);
      }
    }
    
    print('[PLANT DETECTION] Detected expected plant names: $expectedPlantNames');
    
    if (expectedPlantNames.isNotEmpty) {
      // Check if predicted class matches any of the expected plant keywords
      for (String plantName in expectedPlantNames) {
        List<String>? keywords = plantKeywords[plantName];
        if (keywords != null) {
          bool hasMatch = keywords.any((keyword) => 
            predicted == keyword.toLowerCase() ||
            predicted.contains(keyword.toLowerCase())
          );
          if (hasMatch) {
            print('[PLANT DETECTION] Match found for $plantName with keywords: $keywords');
            return true;
          }
        }
      }
      print('[PLANT DETECTION] No direct match found in expected plant keywords');
    }
    
    // Enhanced fallback: Only match if both predicted and expected contain the same plant keywords
    for (String plantKey in plantKeywords.keys) {
      List<String> keywords = plantKeywords[plantKey]!;
      bool predictedMatches = keywords.any((keyword) => predicted.contains(keyword.toLowerCase()));
      bool expectedMatches = keywords.any((keyword) => expected.contains(keyword.toLowerCase()));
      
      if (predictedMatches && expectedMatches) {
        print('[PLANT DETECTION] Fallback match found for plant type: $plantKey');
        return true;
      }
    }
    
    print('[PLANT DETECTION] No match found - different plant types detected');
    return false;
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
                    if (errorMessage != null && !errorMessage!.contains('AI') && !errorMessage!.contains('500'))
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
                                        final XFile? photo = await _picker.pickImage(
                                          source: ImageSource.camera, 
                                          imageQuality: 70,
                                          maxWidth: 1024,
                                          maxHeight: 1024,
                                        );
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
                                        final XFile? photo = await _picker.pickImage(
                                          source: ImageSource.gallery, 
                                          imageQuality: 70,
                                          maxWidth: 1024,
                                          maxHeight: 1024,
                                        );
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

                          // Enhanced AI validation with proper error handling
                          Map<String, dynamic> aiResult = {'success': false}; // Default to failed
                          bool needsConfirmation = false;
                          String confirmationMessage = '';
                          
                          // Get current plant info for validation
                          final currentPlantName = _plantDetailData!.assignment.plant.name;
                          final currentPlantLocalName = _plantDetailData!.assignment.plant.localName;
                          final plantDisplayName = currentPlantLocalName.isNotEmpty ? currentPlantLocalName : currentPlantName;
                          
                          print('[AI VALIDATION] Starting validation for: $plantDisplayName');
                          print('[AI VALIDATION] Plant Name: $currentPlantName');
                          print('[AI VALIDATION] Plant Local Name: $currentPlantLocalName');
                          
                          try {
                            // Try AI validation
                            aiResult = await ApiService.predictPlantImageAI(imagePath!);
                            print('[AI VALIDATION] API Result: $aiResult');
                            
                            if (aiResult['success'] == true && aiResult['data'] != null) {
                              // AI successful - check if predicted plant matches current plant
                              final predictedClass = (aiResult['data']['predicted_class']?.toString() ?? '').toLowerCase();
                              final expectedPlant = '$currentPlantName $currentPlantLocalName'.toLowerCase();
                              
                              print('[AI VALIDATION] Predicted Class: "$predictedClass"');
                              print('[AI VALIDATION] Expected Plant: "$expectedPlant"');
                              
                              bool isCorrectPlant = _isCorrectPlantDetected(predictedClass, expectedPlant);
                              print('[AI VALIDATION] Is Correct Plant: $isCorrectPlant');
                              
                              if (!isCorrectPlant) {
                                // Wrong plant detected by working AI
                                needsConfirmation = true;
                                confirmationMessage = 'AI ने इस फोटो को "$predictedClass" बताया है, लेकिन आप $plantDisplayName upload कर रहे हैं।';
                              }
                              // If correct plant detected, proceed directly without confirmation
                            } else {
                              // AI failed - need confirmation
                              needsConfirmation = true;
                              confirmationMessage = 'AI से connect नहीं हो पाया।';
                              print('[AI VALIDATION] AI failed: ${aiResult['message']}');
                            }
                          } catch (e) {
                            // Network/connection errors - need confirmation
                            needsConfirmation = true;
                            confirmationMessage = 'AI से connect नहीं हो पाया।';
                            print('[AI VALIDATION] Exception: $e');
                            aiResult = {
                              'success': false,
                              'message': 'AI validation error: $e'
                            };
                          }
                          
                          print('[AI VALIDATION] Needs Confirmation: $needsConfirmation');
                          print('[AI VALIDATION] Confirmation Message: $confirmationMessage');
                          
                          // Show confirmation dialog only if needed
                          if (needsConfirmation) {
                            setState(() {
                              isLoading = false;
                            });
                            
                            bool shouldProceed = await showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => AlertDialog(
                                title: Text('चेतावनी!'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.warning, color: Colors.orange, size: 48),
                                    SizedBox(height: 16),
                                    Text(confirmationMessage),
                                    SizedBox(height: 12),
                                    Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.orange[50],
                                        border: Border.all(color: Colors.orange),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'क्या आप sure हैं कि यह $plantDisplayName के पौधे की photo है?',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: Text('नई फोटो लें'),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                    onPressed: () => Navigator.pop(context, true),
                                    child: Text('हाँ, यह $plantDisplayName का पौधा है'),
                                  ),
                                ],
                              ),
                            );

                            if (!shouldProceed) {
                              return;
                            }
                            
                            setState(() {
                              isLoading = true;
                            });
                          }

                          // Proceed with upload
                          final response = await ApiService.uploadMotherPlantAssignment(
                            assignmentId: assignmentId,
                            photoPath: imagePath!,
                            latitude: latitude!,
                            longitude: longitude!,
                            remarks: remarksController.text,
                          );

                          setState(() {
                            isLoading = false;
                          });

                          if (response['success']) {
                            Navigator.pop(context);
                            _showUploadSuccessPopup(context, response['data'], aiResult);
                          } else {
                            setState(() {
                              errorMessage = response['message'] ?? 'अपलोड विफल रहा';
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
              // Show AI results only if AI correctly predicted the plant
              if (aiResult != null && aiResult['success'] == true && aiResult['data'] != null) ...[
                // Check if AI prediction was correct
                Builder(
                  builder: (context) {
                    final predictedClass = (aiResult['data']['predicted_class']?.toString() ?? '').toLowerCase();
                    final currentPlantName = _plantDetailData!.assignment.plant.name;
                    final currentPlantLocalName = _plantDetailData!.assignment.plant.localName;
                    final expectedPlant = '$currentPlantName $currentPlantLocalName'.toLowerCase();
                    
                    bool isCorrectPrediction = _isCorrectPlantDetected(predictedClass, expectedPlant);
                    
                    if (isCorrectPrediction) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green, size: 20),
                              SizedBox(width: 6),
                              Text('AI Verification:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green)),
                            ],
                          ),
                          SizedBox(height: 6),
                          _buildSuccessDetailRow(Icons.nature, 'पहचाना गया पेड़', aiResult['data']['predicted_class'].toString()),
                          if (aiResult['data']['confidence'] != null)
                            _buildSuccessDetailRow(Icons.percent, 'AI की विश्वसनीयता',
                              (aiResult['data']['confidence'] is num)
                                ? (aiResult['data']['confidence'] * 100).toStringAsFixed(2) + '%'
                                : aiResult['data']['confidence'].toString()),
                          Container(
                            margin: EdgeInsets.only(top: 6),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              border: Border.all(color: Colors.green),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.verified, color: Colors.green, size: 16),
                                SizedBox(width: 6),
                                Text('सही पौधा verified!', style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                          Divider(),
                        ],
                      );
                    } else {
                      // Don't show AI results if prediction was incorrect
                      return SizedBox.shrink();
                    }
                  },
                ),
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