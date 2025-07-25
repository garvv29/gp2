import 'package:flutter/material.dart';
import '../../utils/theme.dart';
import '../../utils/app_localizations.dart';
import '../../utils/responsive.dart';
import '../../services/auth_service.dart';
import '../../services/api_service.dart';
import '../../models/hospital_dashboard_response.dart';
import '../welcome_screen.dart';
import 'register_mother_screen.dart';
import 'mothers_list_screen.dart';

class HospitalDashboard extends StatefulWidget {
  @override
  _HospitalDashboardState createState() => _HospitalDashboardState();
}

class _HospitalDashboardState extends State<HospitalDashboard> {
  int _totalMothers = 0;
  int _activePlants = 0;
  int _photosUploaded = 0;
  int _reviewsPending = 0;

  List<dynamic> _plantList = [];

  @override
  void initState() {
    super.initState();
    _loadHospitalDashboard();
  }

  HospitalDashboardCounters? _dashboardCounters;

  Future<void> _loadHospitalDashboard() async {
    print('[DASHBOARD] Loading hospital dashboard...');
    final response = await ApiService.getHospitalDashboard();
    print('[DASHBOARD] Response: $response');
    
    if (response != null && response.success) {
      print('[DASHBOARD] API Success! Counters: ${response.data.counters}');
      setState(() {
        _dashboardCounters = response.data.counters;
        _totalMothers = _dashboardCounters!.totalMothers;
        _activePlants = _dashboardCounters!.activePlants;
        _photosUploaded = _dashboardCounters!.uploadedPhotos;
        _reviewsPending = _dashboardCounters!.distributedPlants;
        // Extract plant_list after block_list
        _plantList = response.data.plantList ?? [];
        print('[DASHBOARD] Updated counters: Total Mothers: $_totalMothers, Active Plants: $_activePlants, Photos Uploaded: $_photosUploaded, Reviews Pending: $_reviewsPending');
        print('[DASHBOARD] Plant List: $_plantList');
      });
    } else {
      print('[DASHBOARD] API failed or returned null');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(l10n),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: ResponsiveUtils.getResponsiveEdgeInsets(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome header
              _buildWelcomeHeader(l10n),
              SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 16, tablet: 24, desktop: 32)),
              
              // Quick stats
              _buildQuickStats(l10n),
              SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 16, tablet: 24, desktop: 32)),

              // Plant List Section
              if (_plantList.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'पौधों की सूची',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.text,
                        fontWeight: FontWeight.w600,
                        fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 18, tablet: 20, desktop: 22),
                      ),
                    ),
                    SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: ResponsiveUtils.isDesktop(context)
                            ? 4
                            : ResponsiveUtils.isTablet(context)
                                ? 3
                                : 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.3,
                      ),
                      itemCount: _plantList.length,
                      itemBuilder: (context, index) {
                        final plant = _plantList[index];
                        final id = plant is Map ? plant['id'] : plant.id;
                        final name = plant is Map ? plant['name'] : plant.name;
                        final localName = plant is Map ? plant['local_name'] : plant.localName;
                        final category = plant is Map ? plant['category'] : plant.category;
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context, mobile: 8, tablet: 10, desktop: 12),
                            boxShadow: AppShadows.small,
                            border: Border.all(color: AppColors.primary.withOpacity(0.08)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: AppColors.primary.withOpacity(0.12),
                                    radius: 16,
                                    child: Text('$id', style: TextStyle(color: AppColors.primary, fontSize: 13)),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(name ?? '', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                  ),
                                ],
                              ),
                              if (localName != null && localName.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(localName, style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                                ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: Text('श्रेणी: $category', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              // Action cards
              Text(
                l10n.quickActions,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.text,
                  fontWeight: FontWeight.w600,
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 18, tablet: 20, desktop: 22),
                ),
              ),
              SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 12, tablet: 16, desktop: 20)),
              
              _buildActionCard(
                l10n.registerNewMother,
                l10n.addNewMotherMessage,
                Icons.person_add,
                AppColors.primary,
                () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterMotherScreen(plantList: _plantList)),
                  );
                  if (result == true) {
                    _loadHospitalDashboard(); // Refresh statistics from API when a new mother is registered
                  }
                },
              ),
              SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
              
              _buildActionCard(
                l10n.viewAllMothers,
                l10n.seeAllMothersMessage,
                Icons.people,
                AppColors.secondary,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MothersListScreen(plantList: _plantList)),
                ),
              ),
              SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
              
              _buildActionCard(
                l10n.systemStatistics,
                l10n.viewSystemPerformance,
                Icons.analytics,
                AppColors.accent,
                () => _showStatsDialog(l10n),
              ),
              SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 16, tablet: 24, desktop: 32)),
              
              // Info card
              _buildInfoCard(l10n),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(AppLocalizations l10n) {
    return AppBar(
      title: Text(
        l10n.hospitalDashboard,
        style: TextStyle(
          fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 18, tablet: 20, desktop: 22),
        ),
      ),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      actions: [
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
            onPressed: () => _logout(l10n),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeHeader(AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: ResponsiveUtils.getResponsiveEdgeInsets(context),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.all(Radius.circular(ResponsiveUtils.getResponsiveBorderRadius(context).topLeft.x * 2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: ResponsiveUtils.getResponsiveIconSize(context, mobile: 50, tablet: 60, desktop: 70),
                height: ResponsiveUtils.getResponsiveIconSize(context, mobile: 50, tablet: 60, desktop: 70),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
                ),
                child: Icon(
                  Icons.local_hospital,
                  color: Colors.white,
                  size: ResponsiveUtils.getResponsiveIconSize(context, mobile: 25, tablet: 30, desktop: 35),
                ),
              ),
              SizedBox(width: ResponsiveUtils.getResponsiveGap(context, mobile: 12, tablet: 16, desktop: 20)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.hospitalStaff,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 14, tablet: 16, desktop: 18),
                      ),
                    ),
                    Text(
                      l10n.dashboard,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 18, tablet: 20, desktop: 22),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 12, tablet: 16, desktop: 20)),
          Container(
            padding: ResponsiveUtils.getResponsiveEdgeInsets(context, mobile: 12, tablet: 16, desktop: 20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.admin_panel_settings,
                  color: Colors.white,
                  size: ResponsiveUtils.getResponsiveIconSize(context, mobile: 20, tablet: 24, desktop: 28),
                ),
                SizedBox(width: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
                Expanded(
                  child: Text(
                    l10n.manageMothersMessage,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 14, tablet: 16, desktop: 18),
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

  Widget _buildQuickStats(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.systemOverview,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.text,
            fontWeight: FontWeight.w600,
            fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 18, tablet: 20, desktop: 22),
          ),
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 12, tablet: 16, desktop: 20)),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                l10n.totalMothers,
                '$_totalMothers',
                Icons.people,
                AppColors.primary,
              ),
            ),
            SizedBox(width: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
            Expanded(
              child: _buildStatCard(
                l10n.activePlants,
                '$_activePlants',
                Icons.eco,
                AppColors.secondary,
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                l10n.photosUploaded,
                '$_photosUploaded',
                Icons.photo_camera,
                AppColors.accent,
              ),
            ),
            SizedBox(width: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
            Expanded(
              child: _buildStatCard(
                l10n.reviewsPending,
                '$_reviewsPending',
                Icons.pending_actions,
                AppColors.warning,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: ResponsiveUtils.getResponsiveEdgeInsets(context, mobile: 12, tablet: 16, desktop: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
        boxShadow: AppShadows.small,
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Container(
            width: ResponsiveUtils.getResponsiveIconSize(context, mobile: 40, tablet: 48, desktop: 56),
            height: ResponsiveUtils.getResponsiveIconSize(context, mobile: 40, tablet: 48, desktop: 56),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
            ),
            child: Icon(
              icon, 
              size: ResponsiveUtils.getResponsiveIconSize(context, mobile: 20, tablet: 24, desktop: 28), 
              color: color,
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.text,
              fontWeight: FontWeight.bold,
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 18, tablet: 20, desktop: 22),
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 2, tablet: 4, desktop: 6)),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 12, tablet: 14, desktop: 16),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
        boxShadow: AppShadows.medium,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
          child: Container(
            padding: ResponsiveUtils.getResponsiveEdgeInsets(context, mobile: 12, tablet: 16, desktop: 20),
            child: Row(
              children: [
                Container(
                  width: ResponsiveUtils.getResponsiveIconSize(context, mobile: 50, tablet: 60, desktop: 70),
                  height: ResponsiveUtils.getResponsiveIconSize(context, mobile: 50, tablet: 60, desktop: 70),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
                  ),
                  child: Icon(
                    icon, 
                    size: ResponsiveUtils.getResponsiveIconSize(context, mobile: 24, tablet: 28, desktop: 32), 
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: ResponsiveUtils.getResponsiveGap(context, mobile: 12, tablet: 16, desktop: 20)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 16, tablet: 18, desktop: 20),
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 2, tablet: 4, desktop: 6)),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 14, tablet: 16, desktop: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withOpacity(0.8),
                  size: ResponsiveUtils.getResponsiveIconSize(context, mobile: 16, tablet: 20, desktop: 24),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(AppLocalizations l10n) {
    return Container(
      padding: ResponsiveUtils.getResponsiveEdgeInsets(context, mobile: 12, tablet: 16, desktop: 20),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
        border: Border.all(color: AppColors.info.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: ResponsiveUtils.getResponsiveIconSize(context, mobile: 40, tablet: 48, desktop: 56),
            height: ResponsiveUtils.getResponsiveIconSize(context, mobile: 40, tablet: 48, desktop: 56),
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.2),
              borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
            ),
            child: Icon(
              Icons.info_outline,
              color: AppColors.info,
              size: ResponsiveUtils.getResponsiveIconSize(context, mobile: 20, tablet: 24, desktop: 28),
            ),
          ),
          SizedBox(width: ResponsiveUtils.getResponsiveGap(context, mobile: 12, tablet: 16, desktop: 20)),
          Expanded(
            child: Text(
              l10n.welcomeHospitalMessage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.info,
                fontWeight: FontWeight.w500,
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 14, tablet: 16, desktop: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showStatsDialog(AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context)),
        title: Text(
          l10n.systemStatistics,
          style: TextStyle(
            fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 18, tablet: 20, desktop: 22),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatItem(l10n.totalMothers, '$_totalMothers'),
            _buildStatItem(l10n.activePlants, '$_activePlants'),
            _buildStatItem(l10n.photosUploaded, '$_photosUploaded'),
            _buildStatItem(l10n.reviewsPending, '$_reviewsPending'),
            _buildStatItem(l10n.systemUptime, '99.9%'),
          ],
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

  Widget _buildStatItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.getResponsiveGap(context, mobile: 4, tablet: 8, desktop: 12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label, 
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 14, tablet: 16, desktop: 18),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 14, tablet: 16, desktop: 18),
            ),
          ),
        ],
      ),
    );
  }

  void _logout(AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context)),
        title: Text(
          l10n.logout,
          style: TextStyle(
            fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 18, tablet: 20, desktop: 22),
          ),
        ),
        content: Text(
          l10n.logoutConfirmation,
          style: TextStyle(
            fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 14, tablet: 16, desktop: 18),
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
            onPressed: () async {
              await AuthService.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => WelcomeScreen()),
                (route) => false,
              );
            },
            child: Text(
              l10n.logout,
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 14, tablet: 16, desktop: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
