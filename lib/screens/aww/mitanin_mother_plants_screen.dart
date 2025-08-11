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
  List<dynamic> _plants = [];
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
          _plants = response['data']['plants'] ?? [];
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

    if (_plants.isEmpty) {
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
      itemCount: _plants.length,
      itemBuilder: (context, index) {
        return _buildPlantCard(_plants[index]);
      },
    );
  }

  Widget _buildPlantCard(dynamic plant) {
    final plantInfo = plant['plant'] ?? {};
    final assignmentId = plant['assignment_id'] ?? 0;
    
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
            child: Row(
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
                      Text(
                        'प्रजाति: ${plantInfo['species'] ?? 'अज्ञात'}',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'स्थानीय नाम: ${plantInfo['local_name'] ?? 'अज्ञात'}',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'फोटो अपलोड करने के लिए टैप करें',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.success,
                            fontWeight: FontWeight.w500,
                          ),
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
          isMitaninUpload: true,
        ),
      ),
    );
  }
}
