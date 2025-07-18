import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/plant_monitoring.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../services/plant_monitoring_service.dart';
import '../../utils/theme.dart';
import '../../utils/app_localizations.dart';
import '../../utils/responsive.dart';
import '../welcome_screen.dart';
import 'plant_detail_screen.dart';
import 'mother_dashboard_appbar.dart';
import 'mother_dashboard_welcome_header.dart';
import 'mother_dashboard_loading_state.dart';
import 'mother_dashboard_empty_state.dart';
import 'mother_dashboard_care_tips_card.dart';
import '../../models/mother_plants_response.dart';

class MotherDashboard extends StatefulWidget {
  @override
  _MotherDashboardState createState() => _MotherDashboardState();
}

class _MotherDashboardState extends State<MotherDashboard> {
  List<PlantMonitoring> plantMonitoring = [];
  List<MotherPlantCard> motherPlants = [];
  bool isLoading = true;
  String userName = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = await AuthService.getCurrentUser();
    if (user != null) {
      setState(() {
        userName = user.name;
        isLoading = true;
      });
      
      try {
        final response = await ApiService.getMotherPlants();
        if (response != null && response.success) {
          setState(() {
            motherPlants = response.data.plantSummary.plants;
            isLoading = false;
          });
        } else {
          // If API fails, try to load local monitoring data as fallback
          final monitoring = await PlantMonitoringService.getRealTimeMonitoringForMother(user.id);
          
          // If no monitoring data exists, generate demo data for 5 plants
          if (monitoring.isEmpty) {
            await _generateDemoPlants(user.id);
            final demoMonitoring = await PlantMonitoringService.getRealTimeMonitoringForMother(user.id);
            setState(() {
              plantMonitoring = demoMonitoring;
              motherPlants = []; // Keep empty for now, focus on API data
              isLoading = false;
            });
          } else {
            setState(() {
              plantMonitoring = monitoring;
              motherPlants = []; // Keep empty for now, focus on API data
              isLoading = false;
            });
          }
        }
      } catch (e) {
        print('Error loading mother plants: $e');
        setState(() {
          motherPlants = [];
          isLoading = false;
        });
      }
    }
  }

  Future<void> _generateDemoPlants(String motherId) async {
    final plantNames = ['आम', 'अमरुद', 'आंवला', 'पपीता', 'मुनगा'];
    
    for (int i = 0; i < 5; i++) {
      final plantId = 'plant_${motherId}_${i + 1}';
      final assignedDate = DateTime.now().subtract(Duration(days: i * 7)); // Staggered assignment dates
      
      final monitoring = PlantMonitoringService.generateMonitoringSchedule(
        plantId: plantId,
        motherId: motherId,
        plantName: plantNames[i],
        assignedDate: assignedDate,
      );
      
      await PlantMonitoringService.savePlantMonitoring(monitoring);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: MotherDashboardAppBar(
        context: context,
        l10n: l10n,
        onRefresh: _refreshMonitoringData,
        onLogout: () => _logout(context, l10n),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Welcome header with gradient
            MotherDashboardWelcomeHeader(context: context, userName: userName, l10n: l10n),
            
            // Plants section
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshMonitoringData,
                color: AppColors.primary,
                child: isLoading
                    ? MotherDashboardLoadingState(context: context, l10n: l10n)
                    : motherPlants.isEmpty
                        ? MotherDashboardEmptyState(context: context, l10n: l10n)
                        : _buildPlantsGrid(l10n),
              ),
            ),
            
            // Care tips card
            MotherDashboardCareTipsCard(context: context, l10n: l10n),
            // Certificate download button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.file_download, color: Colors.white),
                  label: Text('माँ का प्रमाणपत्र डाउनलोड करें', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _downloadMotherCertificate,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlantsGrid(AppLocalizations l10n) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: ResponsiveUtils.getResponsiveEdgeInsets(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.yourPlants,
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
                crossAxisCount: ResponsiveUtils.isTablet(context) ? 3 : 2,
                childAspectRatio: ResponsiveUtils.isTablet(context) ? 0.85 : 0.95,
                crossAxisSpacing: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16),
                mainAxisSpacing: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16),
              ),
              itemCount: motherPlants.length,
              itemBuilder: (context, index) {
                return _buildMotherPlantCard(motherPlants[index], l10n);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMotherPlantCard(MotherPlantCard plant, AppLocalizations l10n) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context)),
      color: Colors.white,
      child: InkWell(
        onTap: () => _navigateToPlantDetail(plant, l10n),
        borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
        child: Padding(
          padding: ResponsiveUtils.getResponsiveEdgeInsets(context, mobile: 8, tablet: 12, desktop: 16),
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: ResponsiveUtils.getResponsiveIconSize(context, mobile: 32, tablet: 36, desktop: 40),
                      height: ResponsiveUtils.getResponsiveIconSize(context, mobile: 32, tablet: 36, desktop: 40),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.15),
                        borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
                        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                      ),
                      child: Icon(
                        Icons.eco,
                        color: AppColors.primary,
                        size: ResponsiveUtils.getResponsiveIconSize(context, mobile: 16, tablet: 18, desktop: 20),
                      ),
                    ),
                    SizedBox(width: ResponsiveUtils.getResponsiveGap(context, mobile: 6, tablet: 8, desktop: 10)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Tooltip(
                            message: plant.plant.name,
                            child: Text(
                              plant.plant.name + ' (${plant.plant.localName})',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 13, tablet: 15, desktop: 17),
                                color: AppColors.text,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          Text(
                            plant.plant.species,
                            style: TextStyle(
                              color: AppColors.info,
                              fontWeight: FontWeight.w500,
                              fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 10, tablet: 12, desktop: 14),
                            ),
                          ),
                          Text(
                            'Assigned: ' + plant.assignedDate,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 9, tablet: 11, desktop: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 10, desktop: 12)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${plant.overallProgress.completionPercentage}%', // Added '%' sign
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 12, tablet: 14, desktop: 16),
                      ),
                    ),
                    Text(
                      '${plant.status}',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 10, tablet: 12, desktop: 14),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 2, tablet: 3, desktop: 4)),
                LinearProgressIndicator(
                  value: plant.overallProgress.completionPercentage / 100.0,
                  backgroundColor: AppColors.border,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  minHeight: 6,
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 10, desktop: 12)),
                Row(
                  children: [
                    Expanded(
                      child: _buildPlantProgressStat(
                        'पूर्ण',
                        plant.overallProgress.photosUploaded.toString(),
                        AppColors.success,
                      ),
                    ),
                    SizedBox(width: ResponsiveUtils.getResponsiveGap(context, mobile: 3, tablet: 4, desktop: 6)),
                    Expanded(
                      child: _buildPlantProgressStat(
                        'लंबित',
                        plant.overallProgress.photosPending.toString(),
                        AppColors.warning,
                      ),
                    ),
                    SizedBox(width: ResponsiveUtils.getResponsiveGap(context, mobile: 3, tablet: 4, desktop: 6)),
                    Expanded(
                      child: _buildPlantProgressStat(
                        'समय से अधिक',
                        plant.overallProgress.photosOverdue.toString(),
                        AppColors.error,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: ResponsiveUtils.getResponsiveGap(context, mobile: 6, tablet: 8, desktop: 10)),
                  padding: ResponsiveUtils.getResponsiveEdgeInsets(context, mobile: 4, tablet: 6, desktop: 8),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context, mobile: 4, tablet: 6, desktop: 8),
                    border: Border.all(color: AppColors.info.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        color: AppColors.info,
                        size: ResponsiveUtils.getResponsiveIconSize(context, mobile: 10, tablet: 12, desktop: 14),
                      ),
                      SizedBox(width: ResponsiveUtils.getResponsiveGap(context, mobile: 3, tablet: 4, desktop: 6)),
                      Expanded(
                        child: Tooltip(
                          message: plant.nextUpload != null && plant.nextUpload!.isOverdue
                              ? 'Overdue!'
                              : 'Due in ${plant.nextUpload?.daysRemaining ?? '-'} days',
                          child: Text(
                            plant.nextUpload != null
                                ? 'Next: ${plant.nextUpload!.dueDate} (Week ${plant.nextUpload!.weekNumber}, Month ${plant.nextUpload!.monthNumber})'
                                : 'अभी तक कोई फोटो अपलोड नहीं करना है',
                            style: TextStyle(
                              color: AppColors.info,
                              fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 8, tablet: 10, desktop: 12),
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 6, tablet: 8, desktop: 10)),
                Container(
                  padding: ResponsiveUtils.getResponsiveEdgeInsets(context, mobile: 4, tablet: 6, desktop: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.07),
                    borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context, mobile: 4, tablet: 6, desktop: 8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Schedule:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 10, tablet: 12, desktop: 14), color: AppColors.primary)),
                      Text(plant.scheduleInfo.month1, style: TextStyle(fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 9, tablet: 11, desktop: 13))),
                      Text(plant.scheduleInfo.month2, style: TextStyle(fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 9, tablet: 11, desktop: 13))),
                      Text(plant.scheduleInfo.month3, style: TextStyle(fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 9, tablet: 11, desktop: 13))),
                      Text(plant.scheduleInfo.totalDuration, style: TextStyle(fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 9, tablet: 11, desktop: 13), color: AppColors.textSecondary)),
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

  Widget _buildPlantProgressStat(String label, String value, Color color) {
    return Container(
      padding: ResponsiveUtils.getResponsiveEdgeInsets(context, mobile: 3, tablet: 4, desktop: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context, mobile: 3, tablet: 4, desktop: 6),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 10, tablet: 12, desktop: 14),
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 7, tablet: 8, desktop: 10),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _navigateToPlantDetail(MotherPlantCard plant, AppLocalizations l10n) async {
    // Always navigate to detail screen, pass assignment ID for API call
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlantDetailScreen(
          assignmentId: plant.assignmentId, // Pass assignment ID for API call
        ),
      ),
    );
  }

  Future<void> _refreshMonitoringData() async {
    await _loadData();
  }

  void _logout(BuildContext context, AppLocalizations l10n) {
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

  void _downloadMotherCertificate() async {
    // TODO: Implement actual download logic (API call, file save, etc.)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('प्रमाणपत्र डाउनलोड करने की सुविधा जल्द आ रही है!')),
    );
  }
}