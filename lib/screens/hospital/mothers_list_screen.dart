import 'package:flutter/material.dart';
import '../../models/mothers_list_response.dart';
import '../../models/mother_detail_response.dart';
import '../../services/api_service.dart';
import '../../utils/theme.dart';
import '../../utils/app_localizations.dart';
import '../../utils/responsive.dart';

class MothersListScreen extends StatefulWidget {
  final List<dynamic> plantList;

  const MothersListScreen({Key? key, required this.plantList}) : super(key: key);

  @override
  _MothersListScreenState createState() => _MothersListScreenState();
}

class _MothersListScreenState extends State<MothersListScreen> {
  List<MotherListItem> _allMothers = [];
  List<MotherListItem> _filteredMothers = [];
  bool _isLoading = true;
  String _searchQuery = '';
  Pagination? _pagination;

  @override
  void initState() {
    super.initState();
    _loadRegistrations();
  }

  Future<void> _loadRegistrations() async {
    setState(() => _isLoading = true);
    
    try {
      final response = await ApiService.getMothers();
      if (response != null && response.success) {
        setState(() {
          _allMothers = response.data.mothers;
          _filteredMothers = response.data.mothers;
          _pagination = response.data.pagination;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error loading mothers: $e');
      setState(() => _isLoading = false);
    }
  }

  void _filterRegistrations(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredMothers = _allMothers;
      } else {
        _filteredMothers = _allMothers.where((mother) {
          return mother.motherName.toLowerCase().contains(query.toLowerCase()) ||
                 mother.motherMobile.contains(query) ||
                 mother.childName.toLowerCase().contains(query.toLowerCase()) ||
                 mother.fatherHusbandName.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  Future<void> _showMotherDetails(int childId) async {
    final l10n = AppLocalizations.of(context);
    
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
    
    try {
      final response = await ApiService.getMotherDetail(childId);
      Navigator.pop(context); // Close loading dialog
      
      if (response != null && response.success) {
        _showDetailDialog(response.data, l10n);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load mother details'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading details: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
  
  void _showDetailDialog(MotherDetailData data, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: AppColors.primary.withOpacity(0.15),
                          child: Icon(
                            data.childInfo.childGender == 'male' ? Icons.male : Icons.female,
                            color: data.childInfo.childGender == 'male' ? Colors.blue : Colors.pink,
                            size: 44,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          data.childInfo.motherName,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Text(
                          data.childInfo.childName,
                          style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Mother & Child Info
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _popupDetailRow(Icons.phone, 'मोबाइल', data.childInfo.motherMobile, Colors.green),
                              _popupDetailRow(Icons.calendar_month, 'प्रसव दिनांक', _formatDate(data.childInfo.deliveryDate), Colors.deepPurple),
                              _popupDetailRow(Icons.access_time, 'प्रसव समय', data.childInfo.deliveryTime, Colors.deepPurple),
                              _popupDetailRow(Icons.local_hospital, 'प्रसव प्रकार', data.childInfo.deliveryType, Colors.green),
                              _popupDetailRow(Icons.bloodtype, 'ब्लड ग्रुप', data.childInfo.bloodGroup, Colors.red),
                              _popupDetailRow(Icons.monitor_weight, 'वजन जन्म के समय', '${data.childInfo.weightAtBirth} kg', Colors.teal),
                              _popupDetailRow(Icons.child_care, 'बच्चे का क्रम', data.childInfo.childOrder, Colors.blueGrey),
                              Divider(),
                              _popupDetailRow(Icons.verified_user, 'खाता स्थिति', data.userAccount.isActive ? 'सक्रिय' : 'निष्क्रिय', Colors.blue),
                              _popupDetailRow(Icons.date_range, 'पंजीकरण दिनांक', _formatDate(data.childInfo.registrationDate), Colors.brown),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      // Location Info
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _popupDetailRow(Icons.location_city, 'जिला', data.locationDetails.district.districtName, Colors.redAccent),
                              _popupDetailRow(Icons.location_on, 'ब्लॉक', data.locationDetails.block.blockName, Colors.orange),
                              _popupDetailRow(Icons.home, 'गांव', data.locationDetails.village.villageName, Colors.teal),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      // Government Schemes
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('सरकारी योजनाएं', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              SizedBox(height: 8),
                              _buildDetailRow('MMJY', data.governmentSchemes.mmjy ?? 'नहीं'),
                              _buildDetailRow('PMMVY', data.governmentSchemes.pmmvy ?? 'नहीं'),
                              if (data.governmentSchemes.description != null) ...[
                                _buildDetailRow('MMJY विवरण', data.governmentSchemes.description?['mmjy'] ?? ''),
                                _buildDetailRow('PMMVY विवरण', data.governmentSchemes.description?['pmmvy'] ?? ''),
                              ],
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      // Additional Info
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('अतिरिक्त जानकारी', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              SizedBox(height: 8),
                              _buildDetailRow('जन्म प्रमाण पत्र', data.additionalInfo.birthCertificate ?? '-'),
                              _buildDetailRow('श्रमिक कार्ड', data.additionalInfo.isShramikCard ?? '-'),
                              _buildDetailRow('आयुष्मान कार्ड उपयोग', data.additionalInfo.isUsedAyushmanCard ?? '-'),
                              _buildDetailRow('आयुष्मान कार्ड राशि', data.additionalInfo.ayushmanCardAmount ?? '-'),
                              _buildDetailRow('NSY लाभ', data.additionalInfo.isBenefitNsy ?? '-'),
                              _buildDetailRow('NSY फॉर्म', data.additionalInfo.isNsyForm ?? '-'),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      // Plant Tracking Summary
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('पौधा ट्रैकिंग', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              SizedBox(height: 8),
                              _buildDetailRow('कुल असाइनमेंट', data.plantTrackingInfo.totalAssignments.toString()),
                              _buildDetailRow('कुल शेड्यूल', data.plantTrackingInfo.totalSchedules.toString()),
                              _buildDetailRow('ट्रैकिंग अवधि', data.plantTrackingInfo.trackingDuration ?? '-'),
                              _buildDetailRow('फोटो आवृत्ति', data.plantTrackingInfo.photoFrequency ?? '-'),
                              Divider(),
                              Text('पौधों की सूची:', style: TextStyle(fontWeight: FontWeight.w600)),
                              ...data.plantTrackingInfo.assignments.map((assignment) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.eco, color: Colors.green, size: 18),
                                    SizedBox(width: 6),
                                    Expanded(child: Text('${assignment.plantInfo.plant_local_name} (${assignment.plantInfo.plant_name}) - ${assignment.assignmentDetails.status}', style: TextStyle(fontSize: 13.2))),
                                  ],
                                ),
                              )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Actions
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close, color: AppColors.primary),
                        label: Text('बंद करें', style: TextStyle(color: AppColors.primary)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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

  Widget _popupDetailRow(IconData icon, String label, String value, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 22),
          SizedBox(width: 10),
          SizedBox(
            width: 90,
            child: Text(label + ':', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: Text(value, style: TextStyle(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.getResponsiveGap(context, mobile: 4, tablet: 6, desktop: 8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'पंजीकृत माताएं',
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
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadRegistrations,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: ResponsiveUtils.getResponsiveEdgeInsets(context),
            child: TextField(
              onChanged: _filterRegistrations,
              decoration: InputDecoration(
                hintText: 'माताओं को खोजें',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
                ),
                filled: true,
                fillColor: AppColors.surface,
              ),
            ),
          ),
          
          // Registrations List
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                : _filteredMothers.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 64,
                              color: AppColors.textSecondary,
                            ),
                            SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 16, tablet: 24, desktop: 32)),
                            Text(
                              _searchQuery.isEmpty ? 'कोई माताएं पंजीकृत नहीं हैं' : 'कोई परिणाम नहीं मिला',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: ResponsiveUtils.getResponsiveEdgeInsets(context),
                        itemCount: _filteredMothers.length,
                        itemBuilder: (context, index) {
                          final mother = _filteredMothers[index];
                          return _buildMotherCard(mother, l10n);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildMotherCard(MotherListItem mother, AppLocalizations l10n) {
    final isMale = mother.childGender == 'male';
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        childrenPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: isMale ? Colors.blue[50] : Colors.pink[50],
              child: Icon(
                isMale ? Icons.male : Icons.female,
                color: isMale ? Colors.blue : Colors.pink,
                size: 32,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(mother.motherName, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15.5)),
                  SizedBox(height: 2),
                  // Text(mother.childName, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.5, color: AppColors.textSecondary)), // HIDDEN
                  Text(mother.motherMobile, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.5, color: AppColors.textSecondary)),
                ],
              ),
            ),
            SizedBox(width: 8),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calendar_month, color: Colors.deepPurple, size: 15),
                      SizedBox(width: 3),
                      Text(_formatDate(mother.deliveryDate), style: TextStyle(fontSize: 12.5, color: Colors.deepPurple, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.person, color: Colors.purple, size: 15),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      mother.fatherHusbandName,
                      style: TextStyle(fontSize: 13.2, color: Colors.grey[800]),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.phone, color: Colors.green, size: 15),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      mother.motherMobile,
                      style: TextStyle(fontSize: 13.2, color: Colors.grey[800]),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.location_on, color: Colors.redAccent, size: 15),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${mother.location.districtName}, ${mother.location.blockName}, ${mother.location.villageName}',
                      style: TextStyle(fontSize: 13.2, color: Colors.grey[800]),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.monitor_weight, color: Colors.teal, size: 15),
                  SizedBox(width: 4),
                  Text('${mother.weightAtBirth} kg', style: TextStyle(fontSize: 13.2, color: Colors.teal)),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.bloodtype, color: Colors.red, size: 15),
                  SizedBox(width: 4),
                  Text(mother.bloodGroup, style: TextStyle(fontSize: 13.2, color: Colors.red)),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.child_care, color: Colors.blueGrey, size: 15),
                  SizedBox(width: 4),
                  Text('Order: ${mother.childOrder}', style: TextStyle(fontSize: 13.2, color: Colors.blueGrey)),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.access_time, color: Colors.deepPurple, size: 15),
                  SizedBox(width: 4),
                  Text('Time: ${mother.deliveryTime}', style: TextStyle(fontSize: 13.2, color: Colors.deepPurple)),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.local_hospital, color: Colors.green, size: 15),
                  SizedBox(width: 4),
                  Text('Type: ${mother.deliveryType}', style: TextStyle(fontSize: 13.2, color: Colors.green)),
                ],
              ),
              SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: Icon(Icons.visibility),
                  label: Text('View Details'),
                  onPressed: () => _showMotherDetails(mother.childId),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}