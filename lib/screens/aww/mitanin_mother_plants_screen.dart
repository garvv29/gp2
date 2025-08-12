import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../utils/theme.dart';
import '../../utils/responsive.dart';
import '../mother/plant_detail_screen.dart';

class MitaninMotherPlantsScreen extends StatefulWidget {
  final String motherId;
  final String motherName;
  final String childName;

  const MitaninMotherPlantsScreen({
    Key? key,
    required this.motherId,
    required this.motherName,
    required this.childName,
  }) : super(key: key);

  @override
  _MitaninMotherPlantsScreenState createState() => _MitaninMotherPlantsScreenState();
}

class _MitaninMotherPlantsScreenState extends State<MitaninMotherPlantsScreen> {
  Map<String, dynamic>? _motherData;
  List<dynamic> _plantAssignments = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMotherPlants();
  }

  Future<void> _loadMotherPlants() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await ApiService.getMitaninMotherPlants(widget.motherId);
      if (response != null && response['success'] == true) {
        setState(() {
          _motherData = response['data'];
          _plantAssignments = response['data']['plant_assignments'] ?? [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = response?['message'] ?? 'पौधों की जानकारी लोड नहीं हो सकी';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'सर्वर से कनेक्ट नहीं हो सका: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.motherName} के पौधे',
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 16, tablet: 18, desktop: 20),
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'बच्चा: ${widget.childName}',
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 12, tablet: 14, desktop: 16),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.primary),
            SizedBox(height: 16),
            Text(
              'पौधों की जानकारी लोड हो रही है...',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            SizedBox(height: 16),
            Text(
              _error!,
              style: TextStyle(
                color: AppColors.error,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadMotherPlants,
              child: Text('पुनः प्रयास करें'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    if (_plantAssignments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.eco_outlined,
              size: 64,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: 16),
            Text(
              'इस माता के लिए कोई पौधे नहीं मिले',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _plantAssignments.length,
      itemBuilder: (context, index) {
        return _buildPlantCard(_plantAssignments[index]);
      },
    );
  }

  Widget _buildPlantCard(dynamic plantAssignment) {
    final plantInfo = plantAssignment['plant'] ?? {};
    final assignmentId = plantAssignment['assignment_id'] ?? 0;
    final trackingSchedules = plantAssignment['tracking_schedules'] ?? [];
    
    // Calculate progress
    int totalWeeks = trackingSchedules.length;
    int completedWeeks = trackingSchedules.where((schedule) => 
      schedule['upload_status'] == 'completed').length;
    int pendingWeeks = trackingSchedules.where((schedule) => 
      schedule['upload_status'] == 'pending').length;
    double progressPercentage = totalWeeks > 0 ? (completedWeeks / totalWeeks) : 0.0;
    
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToPlantDetail(assignmentId),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Plant Icon
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.eco,
                        color: AppColors.primary,
                        size: 30,
                      ),
                    ),
                    SizedBox(width: 16),
                    // Plant Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plantInfo['name'] ?? 'अज्ञात पौधा',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.text,
                            ),
                          ),
                          SizedBox(height: 4),
                          if (plantInfo['local_name'] != null && plantInfo['local_name'].isNotEmpty)
                            Text(
                              'स्थानीय नाम: ${plantInfo['local_name']}',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          SizedBox(height: 4),
                          if (plantInfo['category'] != null && plantInfo['category'].isNotEmpty)
                            Text(
                              'श्रेणी: ${plantInfo['category']}',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Arrow
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.textSecondary,
                      size: 16,
                    ),
                  ],
                ),
                SizedBox(height: 12),
                
                // Progress Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'प्रगति: $completedWeeks/$totalWeeks सप्ताह पूर्ण',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${(progressPercentage * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: progressPercentage == 1.0 ? AppColors.success : AppColors.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                
                // Progress Bar
                LinearProgressIndicator(
                  value: progressPercentage,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progressPercentage == 1.0 ? AppColors.success : AppColors.primary,
                  ),
                ),
                SizedBox(height: 12),
                
                // Action Button
                Container(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showPlantStatsDialog(plantAssignment),
                    icon: Icon(Icons.visibility, size: 18),
                    label: Text(
                      pendingWeeks > 0 ? 'विवरण देखें और फोटो अपलोड करें' : 'सभी फोटो अपलोड हो गए',
                      style: TextStyle(fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pendingWeeks > 0 ? AppColors.primary : AppColors.success,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToPlantDetail(int assignmentId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlantDetailScreen(
          assignmentId: assignmentId,
          isMitaninUpload: false,  // Use mother endpoint instead of mitanin
        ),
      ),
    );
  }

  void _showPlantStatsDialog(dynamic plantAssignment) {
    final plantInfo = plantAssignment['plant'] ?? {};
    final assignmentId = plantAssignment['assignment_id'] ?? 0;
    final trackingSchedules = plantAssignment['tracking_schedules'] ?? [];
    
    // Calculate detailed stats
    int totalWeeks = trackingSchedules.length;
    int completedWeeks = trackingSchedules.where((schedule) => 
      schedule['upload_status'] == 'completed').length;
    int pendingWeeks = trackingSchedules.where((schedule) => 
      schedule['upload_status'] == 'pending').length;
    int overdueWeeks = trackingSchedules.where((schedule) => 
      schedule['upload_status'] == 'pending' && 
      DateTime.tryParse(schedule['due_date'] ?? '')?.isBefore(DateTime.now()) == true).length;
    
    // Find current week (earliest pending)
    var currentWeekSchedule = trackingSchedules.where((schedule) => 
      schedule['upload_status'] == 'pending').isNotEmpty 
        ? trackingSchedules.where((schedule) => 
            schedule['upload_status'] == 'pending').first
        : null;
    
    double progressPercentage = totalWeeks > 0 ? (completedWeeks / totalWeeks) : 0.0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Icon(Icons.eco, color: AppColors.primary, size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plantInfo['name'] ?? 'अज्ञात पौधा',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.text,
                            ),
                          ),
                          if (plantInfo['local_name'] != null && plantInfo['local_name'].isNotEmpty)
                            Text(
                              'स्थानीय नाम: ${plantInfo['local_name']}',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                
                SizedBox(height: 16),
                
                // Progress Summary
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'कुल प्रगति',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${(progressPercentage * 100).toInt()}%',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: progressPercentage,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem('पूर्ण', '$completedWeeks', AppColors.success),
                          _buildStatItem('बाकी', '$pendingWeeks', AppColors.warning),
                          _buildStatItem('देर', '$overdueWeeks', AppColors.error),
                        ],
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 16),
                
                // Current Week Info
                if (currentWeekSchedule != null) ...[
                  Text(
                    'अगला अपलोड',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.schedule, color: AppColors.primary),
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'सप्ताह ${currentWeekSchedule['week_number']} - महीना ${currentWeekSchedule['month_number']}',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              if (currentWeekSchedule['due_date'] != null)
                                Text(
                                  'देय तिथि: ${_formatDate(DateTime.tryParse(currentWeekSchedule['due_date']) ?? DateTime.now())}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                ],
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('बंद करें'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: pendingWeeks > 0 
                            ? () {
                                Navigator.pop(context);
                                _navigateToPlantDetail(assignmentId);
                              }
                            : null,
                        icon: Icon(Icons.camera_alt, size: 18),
                        label: Text('फोटो अपलोड करें'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: pendingWeeks > 0 ? AppColors.primary : Colors.grey,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'जन', 'फर', 'मार', 'अप्र', 'मई', 'जून',
      'जुल', 'अग', 'सित', 'अक्ट', 'नव', 'दिस'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
