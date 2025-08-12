import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../utils/theme.dart';
import '../../utils/app_localizations.dart';
import '../../utils/responsive.dart';
import '../welcome_screen.dart';
import 'aww_mothers_search_screen.dart';
import 'aww_mothers_list_screen.dart';
import 'uploaded_photos_list_screen.dart';
import '../../models/mitanin_dashboard_response.dart';

class AWWDashboard extends StatefulWidget {
  @override
  _AWWDashboardState createState() => _AWWDashboardState();
}

class _AWWDashboardState extends State<AWWDashboard> {
  MitaninDashboardResponse? dashboard;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    setState(() => isLoading = true);
    final response = await ApiService.getMitaninDashboard();
    if (response != null && response['success'] == true) {
      setState(() {
        dashboard = MitaninDashboardResponse.fromJson(response);
        isLoading = false;
      });
    } else {
      setState(() {
        dashboard = null;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(l10n),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : dashboard == null
              ? Center(child: Text('डैशबोर्ड डेटा लोड नहीं हुआ'))
              : SafeArea(
                  child: SingleChildScrollView(
                    padding: ResponsiveUtils.getResponsiveEdgeInsets(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildWelcomeHeader(l10n),
                        SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 16, tablet: 24, desktop: 32)),
                        _buildStatsCards(l10n),
                        SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 16, tablet: 24, desktop: 32)),
                        _buildQuickActions(l10n),
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
        l10n.awwDashboard,
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
          margin: EdgeInsets.only(right: ResponsiveUtils.getResponsiveGap(context, mobile: 4, tablet: 6, desktop: 8)),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
          ),
          child: IconButton(
            icon: Icon(
              Icons.refresh,
              size: ResponsiveUtils.getResponsiveIconSize(context, mobile: 20, tablet: 24, desktop: 28),
            ),
            onPressed: _loadDashboard,
          ),
        ),
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
    if (dashboard == null) return SizedBox.shrink();
    final info = dashboard!.data.mitaninInfo;
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
                  Icons.work,
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
                      l10n.welcomeBack,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 14, tablet: 16, desktop: 18),
                      ),
                    ),
                    Text(
                      info.name,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 18, tablet: 20, desktop: 22),
                      ),
                    ),
                    Text(
                      'यूज़र आईडी: ${info.userid}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 12, tablet: 14, desktop: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(AppLocalizations l10n) {
    if (dashboard == null) return SizedBox.shrink();
    final counters = dashboard!.data.counters;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.overview,
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
                'अपलोड की गई फोटो',
                '${counters.totalUploadedPhotos}',
                Icons.photo_library,
                AppColors.success,
              ),
            ),
            SizedBox(width: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
            Expanded(
              child: _buildStatCard(
                'कुल माताएं',
                '${counters.totalMothers}',
                Icons.people,
                AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
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
    String badge,
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
                      SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 4, tablet: 8, desktop: 12)),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16),
                          vertical: ResponsiveUtils.getResponsiveGap(context, mobile: 2, tablet: 4, desktop: 6),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context, mobile: 6, tablet: 8, desktop: 10),
                        ),
                        child: Text(
                          badge,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 12, tablet: 14, desktop: 16),
                          ),
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

  Widget _buildQuickActions(AppLocalizations l10n) {
    if (dashboard == null) return SizedBox.shrink();
    final counters = dashboard!.data.counters;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          'माता खोजें',
          'मोबाइल नंबर से माता की जानकारी खोजें',
          Icons.search,
          'खोजें',
          AppColors.primary,
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AWWMothersSearchScreen()),
          ),
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
        _buildActionCard(
          l10n.mothersList,
          'सभी अस्पतालों की माताओं की सूची देखें',
          Icons.people,
          '${counters.totalMothers}',
          AppColors.secondary,
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AWWMothersListScreen(
              initialTotalCount: counters.totalMothers,
            )),
          ),
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
        _buildActionCard(
          'अपलोड की गई फोटो देखें',
          'माताओं द्वारा अपलोड की गई फोटो देखें',
          Icons.photo_library,
          '${counters.totalUploadedPhotos}',
          AppColors.accent,
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UploadedPhotosListScreen()),
          ),
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 16, tablet: 24, desktop: 32)),
      ],
    );
  }

  Widget _buildInfoCard(AppLocalizations l10n) {
    return Container(
      padding: ResponsiveUtils.getResponsiveEdgeInsets(context, mobile: 12, tablet: 16, desktop: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.accent, AppColors.accent.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
        boxShadow: AppShadows.medium,
      ),
      child: Row(
        children: [
          Container(
            width: ResponsiveUtils.getResponsiveIconSize(context, mobile: 40, tablet: 48, desktop: 56),
            height: ResponsiveUtils.getResponsiveIconSize(context, mobile: 40, tablet: 48, desktop: 56),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
            ),
            child: Icon(
              Icons.info_outline,
              color: Colors.white,
              size: ResponsiveUtils.getResponsiveIconSize(context, mobile: 20, tablet: 24, desktop: 28),
            ),
          ),
          SizedBox(width: ResponsiveUtils.getResponsiveGap(context, mobile: 12, tablet: 16, desktop: 20)),
          Expanded(
            child: Text(
              'आप यहाँ माताओं द्वारा अपलोड की गई फोटो देख सकते हैं और उनकी प्रगति की निगरानी कर सकते हैं।',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 14, tablet: 16, desktop: 18),
              ),
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
              try {
                // Clear shared preferences first
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                await AuthService.logout();
              } catch (e) {
                // Ignore errors, proceed to navigation
              } finally {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomeScreen()),
                  (route) => false,
                );
              }
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
