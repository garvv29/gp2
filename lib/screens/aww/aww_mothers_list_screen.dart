import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/mothers_list_response.dart';
import '../../models/mitanin_mother_detail_response.dart';
import '../../services/api_service.dart';
import '../../utils/theme.dart';
import '../../utils/app_localizations.dart';
import '../../utils/responsive.dart';
import '../../utils/constants.dart';

class AWWMothersListScreen extends StatefulWidget {
  @override
  _AWWMothersListScreenState createState() => _AWWMothersListScreenState();
}

class _AWWMothersListScreenState extends State<AWWMothersListScreen> {
  List<MotherListItem> _allMothers = [];
  List<MotherListItem> _filteredMothers = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadRegistrations();
  }

  Future<void> _loadRegistrations() async {
    setState(() => _isLoading = true);
    try {
      // Use mitanin/mothers API
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final url = Uri.parse('${AppConstants.baseUrl}/mitanin/mothers');
      final response = await ApiService.getMothersFromUrl(url, token);
      if (response != null && response.success) {
        setState(() {
          _allMothers = response.data.mothers;
          _filteredMothers = response.data.mothers;
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
                 mother.childName.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  Future<void> _showMotherDetails(int childId) async {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
    try {
      final response = await ApiService.getMitaninMotherDetail(childId);
      Navigator.pop(context);
      if (response != null && response.success) {
        _showMitaninDetailDialog(response.data, l10n);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load mother details'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading details: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _showMitaninDetailDialog(MitaninMotherDetailData data, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        title: Container(
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.primary.withOpacity(0.15),
                  child: Icon(
                    data.childInfo.childGender == 'male' ? Icons.male : Icons.female,
                    color: data.childInfo.childGender == 'male' ? Colors.blue : Colors.pink,
                    size: 40,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  data.childInfo.motherName,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  data.childInfo.childName,
                  style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500, fontSize: 15),
                ),
              ],
            ),
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _popupDetailRow(Icons.phone, 'मोबाइल', data.childInfo.motherMobile, Colors.green),
              Divider(),
              _popupDetailRow(Icons.calendar_month, 'प्रसव दिनांक', _formatDate(data.childInfo.deliveryDate), Colors.deepPurple),
              Divider(),
              _popupDetailRow(Icons.location_city, 'जिला', data.locationDetails.district.districtName, Colors.redAccent),
              _popupDetailRow(Icons.location_on, 'ब्लॉक', data.locationDetails.block.blockName, Colors.orange),
              if (data.locationDetails.village != null)
                _popupDetailRow(Icons.home, 'गांव', data.locationDetails.village!.villageName ?? '-', Colors.teal),
              Divider(),
              _popupDetailRow(Icons.verified_user, 'खाता स्थिति', data.userAccount.isActive ? 'सक्रिय' : 'निष्क्रिय', Colors.blue),
              _popupDetailRow(Icons.date_range, 'पंजीकरण दिनांक', _formatDate(data.childInfo.registrationDate), Colors.brown),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.close, color: AppColors.primary),
                SizedBox(width: 6),
                Text('बंद करें', style: TextStyle(color: AppColors.primary)),
              ],
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
                      Text(_formatDate(mother.deliveryDate), style: TextStyle(fontSize: 12.5, color: Colors.deepPurple, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Icon(Icons.chevron_right, color: Colors.grey[400], size: 24),
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
                  Text('Father/Husband: ${mother.fatherHusbandName}', style: TextStyle(fontSize: 13.2, color: Colors.blueGrey)),
                ],
              ),
              SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Gender: ${mother.childGender}', style: TextStyle(fontSize: 13.2, color: Colors.pink)),
                ],
              ),
              SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Order: ${mother.childOrder}', style: TextStyle(fontSize: 13.2, color: Colors.blueGrey)),
                ],
              ),
              SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Time: ${mother.deliveryTime}', style: TextStyle(fontSize: 13.2, color: Colors.deepPurple)),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text('Type: ${mother.deliveryType}', style: TextStyle(fontSize: 13.2, color: Colors.green)),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text('Blood Group: ${mother.bloodGroup}', style: TextStyle(fontSize: 13.2, color: Colors.red)),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text('District: ${mother.location.districtName}', style: TextStyle(fontSize: 13.2, color: Colors.indigo)),
                  SizedBox(width: 8),
                  Text('Block: ${mother.location.blockName}', style: TextStyle(fontSize: 13.2, color: Colors.indigo)),
                  SizedBox(width: 8),
                  Text('Village: ${mother.location.villageName}', style: TextStyle(fontSize: 13.2, color: Colors.indigo)),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text('Schemes: MMJY: ${mother.governmentSchemes?.mmjy ?? "-"}, PMMVY: ${mother.governmentSchemes?.pmmvy ?? "-"}', style: TextStyle(fontSize: 13.2, color: Colors.teal)),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text('Birth Certificate: ${mother.additionalInfo?.birthCertificate ?? "-"}', style: TextStyle(fontSize: 13.2, color: Colors.teal)),
                  SizedBox(width: 8),
                  Text('Shramik Card: ${mother.additionalInfo?.isShramikCard ?? "-"}', style: TextStyle(fontSize: 13.2, color: Colors.teal)),
                  SizedBox(width: 8),
                  Text('Ayushman Used: ${mother.additionalInfo?.isUsedAyushmanCard ?? "-"}', style: TextStyle(fontSize: 13.2, color: Colors.teal)),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text('Ayushman Amount: ${mother.additionalInfo?.ayushmanCardAmount ?? "-"}', style: TextStyle(fontSize: 13.2, color: Colors.teal)),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text('NSY Benefit: ${mother.additionalInfo?.isBenefitNsy ?? "-"}', style: TextStyle(fontSize: 13.2, color: Colors.teal)),
                  SizedBox(width: 8),
                  Text('NSY Form: ${mother.additionalInfo?.isNsyForm ?? "-"}', style: TextStyle(fontSize: 13.2, color: Colors.teal)),
                ],
              ),
              SizedBox(height: 8),
            ],
          ),
        ],
      ),
    );
  }
}

