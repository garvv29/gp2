import 'package:flutter/material.dart';
import 'dart:async';
import '../../models/mothers_list_response.dart';
import '../../services/api_service.dart';
import '../../utils/theme.dart';
import '../../utils/app_localizations.dart';
import '../../utils/responsive.dart';
import 'mitanin_mother_plants_screen.dart';

class AWWMothersListScreen extends StatefulWidget {
  final int? initialTotalCount;

  const AWWMothersListScreen({Key? key, this.initialTotalCount}) : super(key: key);

  @override
  _AWWMothersListScreenState createState() => _AWWMothersListScreenState();
}

class _AWWMothersListScreenState extends State<AWWMothersListScreen> {
  List<MotherListItem> _allMothers = [];
  List<MotherListItem> _filteredMothers = [];
  bool _isLoading = true;
  String _searchQuery = '';
  int _currentPage = 1;
  int _totalPages = 1;
  bool _hasNextPage = false;
  int _totalMothersCount = 0;
  bool _isSearching = false;
  Timer? _debounceTimer;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setInitialTotalCount();
    _loadMothers();
  }

  void _setInitialTotalCount() {
    // Get the count from dashboard if available
    if (widget.initialTotalCount != null) {
      setState(() {
        _totalMothersCount = widget.initialTotalCount!;
      });
    }
  }

  Future<void> _loadMothers({int page = 1, String? search}) async {
    setState(() => _isLoading = true);
    try {
      final response = await ApiService.getMitaninMothersList(
        page: page, 
        limit: 20,
        search: search ?? _searchQuery,
      );
      if (response != null && response.success) {
        setState(() {
          if (page == 1) {
            _allMothers = response.data.mothers;
          } else {
            _allMothers.addAll(response.data.mothers);
          }
          _filteredMothers = _allMothers;
          _currentPage = response.data.pagination.currentPage;
          _totalPages = response.data.pagination.totalPages;
          _hasNextPage = response.data.pagination.hasNextPage;
          
          // Only update count if we don't have initial count from dashboard
          // या अगर search कर रहे हैं तो API का count use करें
          if (widget.initialTotalCount == null || (search != null && search.isNotEmpty)) {
            _totalMothersCount = response.data.pagination.totalRecords;
          }
          
          _isLoading = false;
          _isSearching = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _isSearching = false;
        });
      }
    } catch (e) {
      print('Error loading mothers list: $e');
      setState(() {
        _isLoading = false;
        _isSearching = false;
      });
    }
  }

  void _filterMothers(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: 500), () {
      setState(() {
        _searchQuery = query;
        _isSearching = true;
      });
      _loadMothers(page: 1, search: query);
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadMoreMothers() async {
    if (!_isLoading && _hasNextPage) {
      await _loadMothers(page: _currentPage + 1, search: _searchQuery);
    }
  }

  Widget _buildPhotoSummaryItem(String label, String count, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(height: 2),
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

  int _calculateUploadedPhotos(MotherListItem mother) {
    // Since we don't have plant tracking data in Mitanin response,
    // we'll use a placeholder calculation based on registration date
    try {
      final regDate = DateTime.parse(mother.registrationDate);
      final daysSinceReg = DateTime.now().difference(regDate).inDays;
      
      // Estimate photos based on days since registration
      // Assuming weekly uploads for first month, bi-weekly after
      if (daysSinceReg < 30) {
        return (daysSinceReg / 7).floor();
      } else {
        return 4 + ((daysSinceReg - 30) / 14).floor();
      }
    } catch (e) {
      return 0;
    }
  }

  int _calculateExpectedPhotos(MotherListItem mother) {
    // Calculate expected photos (8 photos over 3 months per plant)
    // Assume 1 plant per child for now
    return 8;
  }

  int _calculateMissedPhotos(MotherListItem mother) {
    int expected = _calculateExpectedPhotos(mother);
    int uploaded = _calculateUploadedPhotos(mother);
    return (expected - uploaded).clamp(0, expected);
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  void _navigateToMotherPlants(MotherListItem mother) {
    // Navigate to mother's plant dashboard for mitanin to upload photos
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
            onPressed: () => _loadMothers(page: 1, search: _searchQuery),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: ResponsiveUtils.getResponsiveEdgeInsets(context),
            child: TextField(
              controller: _searchController,
              onChanged: _filterMothers,
              decoration: InputDecoration(
                hintText: 'माता का नाम, मोबाइल, बच्चे का नाम या जिला खोजें...',
                prefixIcon: _isSearching 
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _debounceTimer?.cancel();
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                          _isSearching = false;
                          // Restore original dashboard count when clearing search
                          if (widget.initialTotalCount != null) {
                            _totalMothersCount = widget.initialTotalCount!;
                          }
                        });
                        // Clear the text field and reload original data
                        FocusScope.of(context).unfocus();
                        _loadMothers(page: 1, search: '');
                      },
                    )
                  : null,
                border: OutlineInputBorder(
                  borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
                ),
                filled: true,
                fillColor: AppColors.surface,
              ),
            ),
          ),
          
          // Stats Header
          Container(
            padding: ResponsiveUtils.getResponsiveEdgeInsets(context, mobile: 16, tablet: 20, desktop: 24),
            color: AppColors.surface,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatItem('कुल माताएं', '${_totalMothersCount}', AppColors.primary),
              ],
            ),
          ),
          
          // Registrations List
          Expanded(
            child: _isLoading && _allMothers.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: AppColors.primary),
                        SizedBox(height: 16),
                        Text(
                          _isSearching ? 'खोज रही है...' : 'माताओं की सूची लोड हो रही है...',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
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
                            if (_searchQuery.isNotEmpty) ...[
                              SizedBox(height: 8),
                              Text(
                                '"$_searchQuery" के लिए कोई परिणाम नहीं मिला',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ],
                        ),
                      )
                    : NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollInfo) {
                          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent && !_isLoading && _hasNextPage) {
                            _loadMoreMothers();
                          }
                          return true;
                        },
                        child: ListView.builder(
                          padding: ResponsiveUtils.getResponsiveEdgeInsets(context),
                          itemCount: _filteredMothers.length + (_hasNextPage ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == _filteredMothers.length) {
                              return Container(
                                padding: EdgeInsets.all(16),
                                child: Center(
                                  child: CircularProgressIndicator(color: AppColors.primary),
                                ),
                              );
                            }
                            final mother = _filteredMothers[index];
                            return _buildMotherCard(mother, l10n);
                          },
                        ),
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
                ],
              ),
              // SizedBox(height: 8),
              // Row(
              //   children: [
              //     Text('Schemes: MMJY: ${mother.governmentSchemes?.mmjy ?? "-"}, PMMVY: ${mother.governmentSchemes?.pmmvy ?? "-"}', style: TextStyle(fontSize: 13.2, color: Colors.teal)),
              //   ],
              // ),
              SizedBox(height: 8),
              Row(
                children: [
                  // Expanded(
                  //   child: Text('Birth Certificate: ${mother.additionalInfo?.birthCertificate ?? "-"}', 
                  //     style: TextStyle(fontSize: 12, color: Colors.teal),
                  //     overflow: TextOverflow.ellipsis,
                  //   ),
                  // ),
                  // SizedBox(width: 4),
                  // Expanded(
                  //   child: Text('Shramik Card: ${mother.additionalInfo?.isShramikCard ?? "-"}', 
                  //     style: TextStyle(fontSize: 12, color: Colors.teal),
                  //     overflow: TextOverflow.ellipsis,
                  //   ),
                  // ),
                  // SizedBox(width: 4),
                  // Expanded(
                  //   child: Text('Ayushman Used: ${mother.additionalInfo?.isUsedAyushmanCard ?? "-"}', 
                  //     style: TextStyle(fontSize: 12, color: Colors.teal),
                  //     overflow: TextOverflow.ellipsis,
                  //   ),
                  // ),
                ],
              ),
              // SizedBox(height: 8),
              // Row(
              //   children: [
              //     Text('Ayushman Amount: ${mother.additionalInfo?.ayushmanCardAmount ?? "-"}', style: TextStyle(fontSize: 13.2, color: Colors.teal)),
              //   ],
              // ),
              // SizedBox(height: 8),
              // Row(
              //   children: [
              //     Text('NSY Benefit: ${mother.additionalInfo?.isBenefitNsy ?? "-"}', style: TextStyle(fontSize: 13.2, color: Colors.teal)),
              //     SizedBox(width: 8),
              //     Text('NSY Form: ${mother.additionalInfo?.isNsyForm ?? "-"}', style: TextStyle(fontSize: 13.2, color: Colors.teal)),
              //   ],
              // ),
              SizedBox(height: 12),
              // Photo Upload Summary
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('फोटो अपलोड सारांश', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primary)),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildPhotoSummaryItem(
                          'अपलोड की गई',
                          '${_calculateUploadedPhotos(mother)}',
                          Icons.photo,
                          Colors.green,
                        ),
                        _buildPhotoSummaryItem(
                          'लंबित',
                          '40',
                          Icons.pending,
                          Colors.orange,
                        ),
                        _buildPhotoSummaryItem(
                          'छूटी हुई',
                          '${_calculateMissedPhotos(mother)}',
                          Icons.warning,
                          Colors.red,
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    // Upload button for mitanin
                    Container(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _navigateToMotherPlants(mother),
                        icon: Icon(Icons.add_a_photo, color: Colors.white),
                        label: Text(
                          'फोटो अपलोड करें',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 20, tablet: 24, desktop: 28),
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 12, tablet: 14, desktop: 16),
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
