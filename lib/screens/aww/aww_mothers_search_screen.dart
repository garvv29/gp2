import 'package:flutter/material.dart';
import '../../models/mother_search_response.dart';
import '../../services/api_service.dart';
import '../../utils/theme.dart';
import '../../utils/responsive.dart';
import 'mitanin_mother_plants_screen.dart';

class AWWMothersSearchScreen extends StatefulWidget {
  @override
  _AWWMothersSearchScreenState createState() => _AWWMothersSearchScreenState();
}

class _AWWMothersSearchScreenState extends State<AWWMothersSearchScreen> {
  final TextEditingController _mobileController = TextEditingController();
  MotherSearchData? _foundMother;
  bool _isSearching = false;
  bool _hasSearched = false;
  String? _errorMessage;

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  Future<void> _searchMother() async {
    if (_mobileController.text.trim().length < 10) {
      setState(() {
        _errorMessage = 'कृपया 10 अंक का वैध मोबाइल नंबर दर्ज करें';
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _hasSearched = false;
      _errorMessage = null;
      _foundMother = null;
    });

    try {
      final response = await ApiService.searchMotherByMobile(_mobileController.text.trim());
      
      setState(() {
        _isSearching = false;
        _hasSearched = true;
        
        if (response != null && response.success && response.data != null) {
          _foundMother = response.data;
          _errorMessage = null;
        } else {
          _foundMother = null;
          _errorMessage = response?.message ?? 'इस मोबाइल नंबर से कोई माता पंजीकृत नहीं है';
        }
      });
    } catch (e) {
      setState(() {
        _isSearching = false;
        _hasSearched = true;
        _foundMother = null;
        _errorMessage = 'खोजने में त्रुटि: ${e.toString()}';
      });
    }
  }

  void _clearSearch() {
    setState(() {
      _mobileController.clear();
      _foundMother = null;
      _hasSearched = false;
      _errorMessage = null;
    });
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  void _navigateToMotherPlants(MotherSearchData mother) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MitaninMotherPlantsScreen(
          motherId: mother.childId.toString(),
          motherName: mother.motherName,
          childName: mother.childName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'माता खोजें',
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
          if (_hasSearched && (_foundMother != null || _errorMessage != null))
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: _clearSearch,
              tooltip: 'खोज साफ़ करें',
            ),
        ],
      ),
      body: Padding(
        padding: ResponsiveUtils.getResponsiveEdgeInsets(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Instruction
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[700], size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'माता का मोबाइल नंबर दर्ज करके खोजें और फोटो अपलोड करें',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            
            // Search Bar
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _mobileController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      decoration: InputDecoration(
                        labelText: 'मोबाइल नंबर',
                        hintText: '10 अंक का मोबाइल नंबर दर्ज करें',
                        prefixIcon: Icon(Icons.phone_android),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        counterText: '',
                        errorText: _errorMessage,
                      ),
                      onSubmitted: (_) => _searchMother(),
                    ),
                  ),
                  SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _isSearching ? null : _searchMother,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isSearching
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 24,
                          ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            
            // Search Results
            Expanded(
              child: _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (!_hasSearched && !_isSearching) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_outlined,
              size: 80,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: 16),
            Text(
              'मोबाइल नंबर से माता की खोज करें',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'फोटो अपलोड करने के लिए माता का\nमोबाइल नंबर दर्ज करें',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }

    if (_isSearching) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.primary),
            SizedBox(height: 16),
            Text(
              'माता की जानकारी खोजी जा रही है...',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null && _foundMother == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_search,
              size: 80,
              color: Colors.red[300],
            ),
            SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.red[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _clearSearch,
              icon: Icon(Icons.refresh),
              label: Text('फिर से खोजें'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    if (_foundMother != null) {
      return SingleChildScrollView(
        child: _buildMotherDetailsCard(_foundMother!),
      );
    }

    return Container();
  }

  Widget _buildMotherDetailsCard(MotherSearchData mother) {
    final isMale = mother.childGender.toLowerCase() == 'male';
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with mother info
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: isMale ? Colors.blue[100] : Colors.pink[100],
                  child: Icon(
                    isMale ? Icons.male : Icons.female,
                    color: isMale ? Colors.blue[700] : Colors.pink[700],
                    size: 36,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mother.motherName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'बच्चा: ${mother.childName}',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        mother.motherMobile,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Text(
                    'मिल गया ✓',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Mother details
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'व्यक्तिगत जानकारी',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 12),
                _buildInfoRow('प्रसव दिनांक', _formatDate(mother.deliveryDate)),
                _buildInfoRow('बच्चे का लिंग', mother.childGender == 'male' ? 'लड़का' : 'लड़की'),
                _buildInfoRow('पंजीकरण दिनांक', _formatDate(mother.registrationDate)),
                SizedBox(height: 16),
                
                Text(
                  'पता',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 12),
                _buildInfoRow('जिला', mother.location.districtName),
                _buildInfoRow('ब्लॉक', mother.location.blockName),
                _buildInfoRow('गांव', mother.location.villageName),
                SizedBox(height: 20),
                
                // Tracking Summary
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'फोटो ट्रैकिंग सारांश',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildSummaryItem(
                            'कुल सप्ताह',
                            '${mother.trackingSummary.totalWeeks}',
                            Icons.calendar_today,
                            Colors.blue,
                          ),
                          _buildSummaryItem(
                            'पूर्ण',
                            '${mother.trackingSummary.completedWeeks}',
                            Icons.check_circle,
                            Colors.green,
                          ),
                          _buildSummaryItem(
                            'लंबित',
                            '${mother.trackingSummary.pendingWeeks}',
                            Icons.pending,
                            Colors.orange,
                          ),
                          _buildSummaryItem(
                            'विलंबित',
                            '${mother.trackingSummary.overdueWeeks}',
                            Icons.warning,
                            Colors.red,
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: mother.trackingSummary.completionPercentage / 100,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          mother.trackingSummary.completionPercentage >= 75
                              ? Colors.green
                              : mother.trackingSummary.completionPercentage >= 50
                                  ? Colors.orange
                                  : Colors.red,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '${mother.trackingSummary.completionPercentage}% पूर्ण',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                
                // Photo Upload Button
                Container(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _navigateToMotherPlants(mother),
                    icon: Icon(Icons.add_a_photo, color: Colors.white, size: 24),
                    label: Text(
                      'फोटो अपलोड करें',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.text,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String count, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(height: 4),
        Text(
          count,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
