import 'package:flutter/material.dart';
import '../../models/pending_verification_response.dart';
import '../../models/mothers_list_response.dart';
import '../../services/api_service.dart';
import '../../utils/theme.dart';
import '../../utils/app_localizations.dart';
import '../../utils/responsive.dart';

class MothersListScreen extends StatefulWidget {
  @override
  _MothersListScreenState createState() => _MothersListScreenState();
}

class _MothersListScreenState extends State<MothersListScreen> {
  List<PendingPhoto> pendingPhotos = [];
  Map<String, List<PendingPhoto>> motherPhotoMap = {};
  bool isLoading = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    
    try {
      final response = await ApiService.getPendingVerificationPhotos();
      if (response != null && response.success) {
        setState(() {
          pendingPhotos = response.data.photos;
          _groupPhotosByMother();
          isLoading = false;
        });
      } else {
        setState(() {
          pendingPhotos = [];
          motherPhotoMap = {};
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading pending verification photos: $e');
      setState(() {
        pendingPhotos = [];
        motherPhotoMap = {};
        isLoading = false;
      });
    }
  }

  void _groupPhotosByMother() {
    motherPhotoMap.clear();
    for (var photo in pendingPhotos) {
      final motherKey = '${photo.assignment.child.motherName}_${photo.assignment.child.motherMobile}';
      if (!motherPhotoMap.containsKey(motherKey)) {
        motherPhotoMap[motherKey] = [];
      }
      motherPhotoMap[motherKey]!.add(photo);
    }
  }

  List<String> get filteredMotherKeys {
    if (searchQuery.isEmpty) {
      return motherPhotoMap.keys.toList();
    }
    return motherPhotoMap.keys.where((key) {
      final photos = motherPhotoMap[key]!;
      final motherName = photos.first.assignment.child.motherName;
      final motherMobile = photos.first.assignment.child.motherMobile;
      return motherName.toLowerCase().contains(searchQuery.toLowerCase()) ||
             motherMobile.contains(searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l10n.mothersList,
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
          Container(
            margin: EdgeInsets.only(right: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
            ),
            child: IconButton(
              icon: Icon(
                Icons.refresh,
                size: ResponsiveUtils.getResponsiveIconSize(context, mobile: 20, tablet: 24, desktop: 28),
              ),
              onPressed: () => _loadData(),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            _buildSearchBar(l10n),
            
            // Statistics summary
            _buildStatisticsSummary(l10n),
            
            // Mothers list
            Expanded(
              child: isLoading
                  ? _buildLoadingState(l10n)
                  : filteredMotherKeys.isEmpty
                      ? _buildEmptyState(l10n)
                      : _buildMothersList(l10n),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(AppLocalizations l10n) {
    return Container(
      margin: ResponsiveUtils.getResponsiveEdgeInsets(context),
      child: TextField(
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: l10n.searchMothers,
          prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
          border: OutlineInputBorder(
            borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
            borderSide: BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
            borderSide: BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
          filled: true,
          fillColor: AppColors.surface,
        ),
      ),
    );
  }

  Widget _buildStatisticsSummary(AppLocalizations l10n) {
    int totalMothers = motherPhotoMap.length;
    int totalPhotos = pendingPhotos.length;
    int uniquePlants = pendingPhotos.map((p) => p.assignment.plantId).toSet().length;
    
    return Container(
      margin: ResponsiveUtils.getResponsiveEdgeInsets(context),
      padding: ResponsiveUtils.getResponsiveEdgeInsets(context, mobile: 12, tablet: 16, desktop: 20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
        boxShadow: AppShadows.medium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'समग्र सांख्यिकी - सत्यापन हेतु',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 16, tablet: 18, desktop: 20),
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 12, tablet: 16, desktop: 20)),
          Row(
            children: [
              Expanded(
                child: _buildStatItem('कुल माताएं', '$totalMothers', Colors.white),
              ),
              SizedBox(width: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
              Expanded(
                child: _buildStatItem('लंबित फोटो', '$totalPhotos', AppColors.warning),
              ),
              SizedBox(width: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
              Expanded(
                child: _buildStatItem('पौधे प्रकार', '$uniquePlants', Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Container(
      padding: ResponsiveUtils.getResponsiveEdgeInsets(context, mobile: 8, tablet: 12, desktop: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context, mobile: 6, tablet: 8, desktop: 10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 16, tablet: 18, desktop: 20),
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 10, tablet: 12, desktop: 14),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary),
          SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 12, tablet: 16, desktop: 20)),
          Text(
            'डेटा लोड हो रहा है...',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 14, tablet: 16, desktop: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: ResponsiveUtils.getResponsiveEdgeInsets(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: ResponsiveUtils.getResponsiveIconSize(context, mobile: 100, tablet: 120, desktop: 140),
              height: ResponsiveUtils.getResponsiveIconSize(context, mobile: 100, tablet: 120, desktop: 140),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context, mobile: 16, tablet: 20, desktop: 24),
              ),
              child: Icon(
                Icons.people,
                size: ResponsiveUtils.getResponsiveIconSize(context, mobile: 50, tablet: 60, desktop: 70),
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 16, tablet: 24, desktop: 32)),
            Text(
              searchQuery.isEmpty ? 'कोई सत्यापन लंबित नहीं' : 'कोई परिणाम नहीं मिला',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.text,
                fontWeight: FontWeight.w600,
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 18, tablet: 20, desktop: 22),
              ),
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
            Text(
              searchQuery.isEmpty 
                  ? 'सभी फोटो सत्यापित हो गई हैं या कोई फोटो अपलोड नहीं की गई है'
                  : 'आपके खोज के अनुसार कोई माता नहीं मिली',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 14, tablet: 16, desktop: 18),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMothersList(AppLocalizations l10n) {
    return ListView.builder(
      padding: ResponsiveUtils.getResponsiveEdgeInsets(context),
      itemCount: filteredMotherKeys.length,
      itemBuilder: (context, index) {
        final motherKey = filteredMotherKeys[index];
        final motherPhotos = motherPhotoMap[motherKey]!;
        return _buildMotherCard(motherKey, motherPhotos, l10n);
      },
    );
  }

  Widget _buildMotherCard(String motherKey, List<PendingPhoto> motherPhotos, AppLocalizations l10n) {
    final firstPhoto = motherPhotos.first;
    final motherName = firstPhoto.assignment.child.motherName;
    final motherMobile = firstPhoto.assignment.child.motherMobile;

    // Calculate statistics for this mother
    int totalPhotos = motherPhotos.length;
    Set<int> uniquePlants = motherPhotos.map((p) => p.assignment.plantId).toSet();
    Set<int> uniqueWeeks = motherPhotos.map((p) => p.weekNumber).toSet();
    
    // Group by health status
    Map<String, int> healthStatusCount = {};
    for (var photo in motherPhotos) {
      healthStatusCount[photo.healthStatus] = (healthStatusCount[photo.healthStatus] ?? 0) + 1;
    }
    
    // Find matching MotherListItem if available
    MotherListItem? motherItem;
    // If you have a list of MotherListItem, you can match by name/mobile
    // motherItem = mothersList.firstWhereOrNull((m) => m.motherName == motherName && m.motherMobile == motherMobile);
    // For demo, assume not available, so use null checks below
    
    return Card(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context)),
      child: InkWell(
        onTap: () => _showMotherDetails(motherKey, motherPhotos, l10n),
        borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
        child: Padding(
          padding: ResponsiveUtils.getResponsiveEdgeInsets(context, mobile: 12, tablet: 16, desktop: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mother header
              Row(
                children: [
                  Container(
                    width: ResponsiveUtils.getResponsiveIconSize(context, mobile: 50, tablet: 60, desktop: 70),
                    height: ResponsiveUtils.getResponsiveIconSize(context, mobile: 50, tablet: 60, desktop: 70),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
                    ),
                    child: Icon(
                      Icons.person,
                      color: AppColors.primary,
                      size: ResponsiveUtils.getResponsiveIconSize(context, mobile: 25, tablet: 30, desktop: 35),
                    ),
                  ),
                  SizedBox(width: ResponsiveUtils.getResponsiveGap(context, mobile: 12, tablet: 16, desktop: 20)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          motherName,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 16, tablet: 18, desktop: 20),
                          ),
                        ),
                        Text(
                          motherMobile,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 14, tablet: 16, desktop: 18),
                          ),
                        ),
                        // Plant assignment hidden (do not show plant assignment info here)
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.textSecondary,
                    size: ResponsiveUtils.getResponsiveIconSize(context, mobile: 16, tablet: 20, desktop: 24),
                  ),
                ],
              ),
              
              SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 12, tablet: 16, desktop: 20)),
              
              // Verification status info
              Container(
                padding: ResponsiveUtils.getResponsiveEdgeInsets(context, mobile: 8, tablet: 12, desktop: 16),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
                  border: Border.all(color: AppColors.warning.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.pending_actions,
                      color: AppColors.warning,
                      size: ResponsiveUtils.getResponsiveIconSize(context, mobile: 16, tablet: 20, desktop: 24),
                    ),
                    SizedBox(width: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
                    Expanded(
                      child: Text(
                        '$totalPhotos फोटो सत्यापन हेतु लंबित',
                        style: TextStyle(
                          color: AppColors.warning,
                          fontWeight: FontWeight.w500,
                          fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 14, tablet: 16, desktop: 18),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _showMotherDetails(motherKey, motherPhotos, l10n),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: ResponsiveUtils.getResponsiveEdgeInsets(context, mobile: 8, tablet: 12, desktop: 16),
                      ),
                      child: Text(
                        'सत्यापित करें',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 12, tablet: 14, desktop: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 12, tablet: 16, desktop: 20)),
              
              // Statistics
              Row(
                children: [
                  Expanded(
                    child: _buildProgressStat('पौधे प्रकार', '${uniquePlants.length}', AppColors.primary),
                  ),
                  SizedBox(width: ResponsiveUtils.getResponsiveGap(context, mobile: 4, tablet: 6, desktop: 8)),
                  Expanded(
                    child: _buildProgressStat('सप्ताह', '${uniqueWeeks.length}', AppColors.info),
                  ),
                  SizedBox(width: ResponsiveUtils.getResponsiveGap(context, mobile: 4, tablet: 6, desktop: 8)),
                  Expanded(
                    child: _buildProgressStat('लंबित फोटो', '$totalPhotos', AppColors.warning),
                  ),
                ],
              ),
              
              // NEW: Show plant quantity, schemes, additional info if available
              SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
              if (motherItem != null) ...[
                Text('पौधों की जानकारी:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...motherItem.plantQuantityList.map((pq) => Text('ID: \\${pq.plantId}, Qty: \\${pq.quantity}, Status: \\${pq.status}')),
                SizedBox(height: 4),
                Text('Schemes: MMJY: \\${motherItem.governmentSchemes?.mmjy ?? "-"}, PMMVY: \\${motherItem.governmentSchemes?.pmmvy ?? "-"}'),
                SizedBox(height: 4),
                Text('Birth Certificate: \\${motherItem.additionalInfo?.birthCertificate ?? "-"}'),
                Text('Shramik Card: \\${motherItem.additionalInfo?.isShramikCard ?? "-"}'),
                Text('Ayushman Used: \\${motherItem.additionalInfo?.isUsedAyushmanCard ?? "-"}'),
                Text('Ayushman Amount: \\${motherItem.additionalInfo?.ayushmanCardAmount ?? "-"}'),
                Text('NSY Benefit: \\${motherItem.additionalInfo?.isBenefitNsy ?? "-"}'),
                Text('NSY Form: \\${motherItem.additionalInfo?.isNsyForm ?? "-"}'),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressStat(String label, String value, Color color) {
    return Container(
      padding: ResponsiveUtils.getResponsiveEdgeInsets(context, mobile: 6, tablet: 8, desktop: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context, mobile: 6, tablet: 8, desktop: 10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 14, tablet: 16, desktop: 18),
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 10, tablet: 12, desktop: 14),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showMotherDetails(String motherKey, List<PendingPhoto> motherPhotos, AppLocalizations l10n) {
    final firstPhoto = motherPhotos.first;
    final motherName = firstPhoto.assignment.child.motherName;
    final motherMobile = firstPhoto.assignment.child.motherMobile;
    final childName = firstPhoto.assignment.child.childName;
    final childDob = firstPhoto.assignment.child.dob;
    
    // Group photos by plant
    Map<int, List<PendingPhoto>> plantPhotoMap = {};
    for (var photo in motherPhotos) {
      if (!plantPhotoMap.containsKey(photo.assignment.plantId)) {
        plantPhotoMap[photo.assignment.plantId] = [];
      }
      plantPhotoMap[photo.assignment.plantId]!.add(photo);
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context)),
        title: Text(
          motherName,
          style: TextStyle(
            fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 18, tablet: 20, desktop: 22),
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailItem('मोबाइल नंबर', motherMobile),
              _buildDetailItem('बच्चे का नाम', childName),
              _buildDetailItem('बच्चे का जन्म दिनांक', childDob),
              
              SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 16, tablet: 24, desktop: 32)),
              Text(
                'लंबित सत्यापन फोटो',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 16, tablet: 18, desktop: 20),
                ),
              ),
              SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
              
              ...plantPhotoMap.entries.map((entry) => _buildPlantPhotoDetail(entry.key, entry.value, l10n)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.close,
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 14, tablet: 16, desktop: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
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
                fontWeight: FontWeight.w500,
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 14, tablet: 16, desktop: 18),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 14, tablet: 16, desktop: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlantPhotoDetail(int plantId, List<PendingPhoto> plantPhotos, AppLocalizations l10n) {
    final plantName = plantPhotos.first.assignment.plant.name;
    
    // Group by week
    Map<int, List<PendingPhoto>> weekPhotoMap = {};
    for (var photo in plantPhotos) {
      if (!weekPhotoMap.containsKey(photo.weekNumber)) {
        weekPhotoMap[photo.weekNumber] = [];
      }
      weekPhotoMap[photo.weekNumber]!.add(photo);
    }
    
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
      padding: ResponsiveUtils.getResponsiveEdgeInsets(context, mobile: 8, tablet: 12, desktop: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'पौधा: $plantName',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 14, tablet: 16, desktop: 18),
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 4, tablet: 6, desktop: 8)),
          Text(
            'सप्ताह: ${weekPhotoMap.keys.join(', ')}',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 12, tablet: 14, desktop: 16),
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
          Row(
            children: [
              _buildPeriodStat('कुल फोटो', '${plantPhotos.length}', AppColors.primary),
              SizedBox(width: ResponsiveUtils.getResponsiveGap(context, mobile: 4, tablet: 6, desktop: 8)),
              _buildPeriodStat('सप्ताह', '${weekPhotoMap.length}', AppColors.info),
              SizedBox(width: ResponsiveUtils.getResponsiveGap(context, mobile: 4, tablet: 6, desktop: 8)),
              _buildPeriodStat('लंबित', '${plantPhotos.length}', AppColors.warning),
            ],
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
          
          // Photo verification list
          Column(
            children: plantPhotos.map((photo) => _buildPhotoVerificationItem(photo, l10n)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoVerificationItem(PendingPhoto photo, AppLocalizations l10n) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.getResponsiveGap(context, mobile: 4, tablet: 6, desktop: 8)),
      padding: ResponsiveUtils.getResponsiveEdgeInsets(context, mobile: 8, tablet: 12, desktop: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context, mobile: 6, tablet: 8, desktop: 10),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          // Photo thumbnail
          Container(
            width: ResponsiveUtils.getResponsiveIconSize(context, mobile: 60, tablet: 70, desktop: 80),
            height: ResponsiveUtils.getResponsiveIconSize(context, mobile: 60, tablet: 70, desktop: 80),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context, mobile: 4, tablet: 6, desktop: 8),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: ClipRRect(
              borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context, mobile: 4, tablet: 6, desktop: 8),
              child: Image.network(
                photo.fullUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.image,
                    color: AppColors.primary,
                    size: ResponsiveUtils.getResponsiveIconSize(context, mobile: 30, tablet: 35, desktop: 40),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                          : null,
                      strokeWidth: 2,
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(width: ResponsiveUtils.getResponsiveGap(context, mobile: 12, tablet: 16, desktop: 20)),
          
          // Photo details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'सप्ताह ${photo.weekNumber} - ${photo.growthStage}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 12, tablet: 14, desktop: 16),
                  ),
                ),
                Text(
                  'स्वास्थ्य: ${photo.healthStatus}',
                  style: TextStyle(
                    color: _getHealthStatusColor(photo.healthStatus),
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 11, tablet: 13, desktop: 15),
                  ),
                ),
                if (photo.notes.isNotEmpty)
                  Text(
                    photo.notes,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 10, tablet: 12, desktop: 14),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          
          // Verification actions
          Column(
            children: [
              ElevatedButton(
                onPressed: () => _showPhotoVerificationDialog(photo, l10n),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                  padding: ResponsiveUtils.getResponsiveEdgeInsets(context, mobile: 4, tablet: 6, desktop: 8),
                  minimumSize: Size(
                    ResponsiveUtils.getResponsiveIconSize(context, mobile: 60, tablet: 70, desktop: 80),
                    ResponsiveUtils.getResponsiveIconSize(context, mobile: 28, tablet: 32, desktop: 36),
                  ),
                ),
                child: Text(
                  'सत्यापित करें',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 10, tablet: 12, desktop: 14),
                  ),
                ),
              ),
              SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 4, tablet: 6, desktop: 8)),
              OutlinedButton(
                onPressed: () => _showPhotoVerificationDialog(photo, l10n, isRejection: true),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: BorderSide(color: AppColors.error),
                  padding: ResponsiveUtils.getResponsiveEdgeInsets(context, mobile: 4, tablet: 6, desktop: 8),
                  minimumSize: Size(
                    ResponsiveUtils.getResponsiveIconSize(context, mobile: 60, tablet: 70, desktop: 80),
                    ResponsiveUtils.getResponsiveIconSize(context, mobile: 28, tablet: 32, desktop: 36),
                  ),
                ),
                child: Text(
                  'अस्वीकार करें',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 10, tablet: 12, desktop: 14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getHealthStatusColor(String healthStatus) {
    switch (healthStatus.toLowerCase()) {
      case 'healthy':
        return AppColors.success;
      case 'unhealthy':
        return AppColors.error;
      case 'moderate':
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }

  void _showPhotoVerificationDialog(PendingPhoto photo, AppLocalizations l10n, {bool isRejection = false}) {
    final TextEditingController remarksController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context)),
        title: Text(
          isRejection ? 'फोटो अस्वीकार करें' : 'फोटो सत्यापित करें',
          style: TextStyle(
            color: isRejection ? AppColors.error : AppColors.success,
            fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 18, tablet: 20, desktop: 22),
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo preview
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
                  border: Border.all(color: AppColors.border),
                ),
                child: ClipRRect(
                  borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
                  child: Image.network(
                    photo.fullUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          Icons.image,
                          size: 50,
                          color: AppColors.textSecondary,
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 16, tablet: 20, desktop: 24)),
              
              // Photo details
              _buildDetailItem('सप्ताह', '${photo.weekNumber}'),
              _buildDetailItem('वृद्धि चरण', photo.growthStage),
              _buildDetailItem('स्वास्थ्य स्थिति', photo.healthStatus),
              _buildDetailItem('अपलोड तिथि', photo.uploadDate.split('T')[0]),
              if (photo.notes.isNotEmpty)
                _buildDetailItem('टिप्पणी', photo.notes),
              
              SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 16, tablet: 20, desktop: 24)),
              
              // Remarks input
              Text(
                'सत्यापन टिप्पणी:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 14, tablet: 16, desktop: 18),
                ),
              ),
              SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
              TextField(
                controller: remarksController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: isRejection 
                      ? 'अस्वीकार करने का कारण बताएं...'
                      : 'सत्यापन संबंधी टिप्पणी लिखें...',
                  border: OutlineInputBorder(
                    borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.cancel,
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 14, tablet: 16, desktop: 18),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => _verifyPhoto(
              photo.id,
              isRejection ? 'rejected' : 'verified',
              remarksController.text.trim(),
              l10n,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: isRejection ? AppColors.error : AppColors.success,
              foregroundColor: Colors.white,
            ),
            child: Text(
              isRejection ? 'अस्वीकार करें' : 'सत्यापित करें',
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 14, tablet: 16, desktop: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _verifyPhoto(int photoId, String status, String remarks, AppLocalizations l10n) async {
    if (remarks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('कृपया टिप्पणी भरें'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    try {
      // Show loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 16),
              Text('फोटो सत्यापन हो रहा है...'),
            ],
          ),
          duration: Duration(seconds: 30),
        ),
      );

      final result = await ApiService.verifyPhoto(
        photoId: photoId,
        verificationStatus: status,
        verificationRemarks: remarks,
      );

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (result != null && result['success'] == true) {
        Navigator.pop(context); // Close verification dialog
        Navigator.pop(context); // Close mother details dialog
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              status == 'verified' ? 'फोटो सफलतापूर्वक सत्यापित की गई!' : 'फोटो अस्वीकार की गई!',
            ),
            backgroundColor: status == 'verified' ? AppColors.success : AppColors.warning,
          ),
        );
        
        // Refresh the list
        _loadData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('सत्यापन में त्रुटि हुई, कृपया पुनः प्रयास करें'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('सत्यापन में त्रुटि: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Widget _buildPeriodStat(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.getResponsiveGap(context, mobile: 6, tablet: 8, desktop: 10),
        vertical: ResponsiveUtils.getResponsiveGap(context, mobile: 2, tablet: 4, desktop: 6),
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context, mobile: 4, tablet: 6, desktop: 8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          color: color,
          fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 12, tablet: 14, desktop: 16),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}