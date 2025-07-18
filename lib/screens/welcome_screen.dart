import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../utils/app_localizations.dart';
import '../utils/responsive.dart';
import '../services/api_service.dart';
import '../services/location_service.dart';
import 'hospital/hospital_dashboard.dart';
import 'aww/aww_dashboard.dart';
import 'mother/mother_dashboard.dart';
import 'change_password_screen.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _loginType = 'hospital';
  bool _isLoading = false;

  final List<DropdownMenuItem<String>> _loginTypes = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = AppLocalizations.of(context);
    _loginTypes.clear();
    _loginTypes.addAll([
      DropdownMenuItem(value: 'hospital', child: Text(l10n.hospitalStaffEntry)),
      DropdownMenuItem(value: 'mitanin', child: Text(l10n.aww)),
      DropdownMenuItem(value: 'mother', child: Text(l10n.mother)),
    ]);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _navigateToDashboard(String role) {
    Widget dashboard;
    switch (role) {
      case 'hospital':
        dashboard = HospitalDashboard();
        break;
      case 'aww':
      case 'mitanin':
        dashboard = AWWDashboard();
        break;
      case 'mother':
        dashboard = MotherDashboard();
        break;
      default:
        _showError('Unknown role: $role');
        return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => dashboard),
    );
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    
    try {
      // Request location permission - this will show system dialog
      final locationResult = await LocationService.requestLocationPermission();
      
      if (!locationResult.granted) {
        // Show error message
        _showError(locationResult.error ?? 'स्थान की अनुमति आवश्यक है।');
        
        // If should open settings, show dialog to guide user
        if (locationResult.shouldOpenSettings) {
          _showPermanentlyDeniedDialog();
        }
        
        setState(() => _isLoading = false);
        return;
      }

      // If location permission granted, proceed with login
      final loginResponse = await loginUser(
        _userIdController.text.trim(),
        _passwordController.text,
        _loginType,
      );
      _showSuccess(AppLocalizations.of(context).success);
      if (loginResponse.user.isFirstLogin == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
        );
      } else {
        _navigateToDashboard(loginResponse.user.role.name);
      }
    } catch (e) {
      String errorMessage = e.toString().replaceFirst('Exception: ', '');
      _showError(errorMessage);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showPermanentlyDeniedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Icon(Icons.location_off, color: AppColors.error, size: 48),
          title: Text(
            'स्थान की अनुमति आवश्यक',
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'स्थान की अनुमति स्थायी रूप से अस्वीकार कर दी गई है।',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 16),
              Text(
                'कृपया निम्नलिखित चरणों का पालन करें:\n\n'
                '1. सेटिंग्स खोलें\n'
                '2. ऐप्स या एप्लिकेशन मैनेजर खोलें\n'
                '3. "Green Palna Yojna" ढूंढें\n'
                '4. अनुमतियां पर क्लिक करें\n'
                '5. स्थान (Location) की अनुमति चालू करें',
                textAlign: TextAlign.left,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('ठीक है', style: TextStyle(color: AppColors.primary)),
            ),
          ],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: ResponsiveUtils.getResponsiveEdgeInsets(context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Container(
                      width: ResponsiveUtils.getResponsiveLogoSize(context),
                      height: ResponsiveUtils.getResponsiveLogoSize(context),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
                        boxShadow: AppShadows.large,
                      ),
                      child: ClipRRect(
                        borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
                        child: Image.asset(
                          'assets/images/logo.jpg',
                          width: ResponsiveUtils.getResponsiveLogoSize(context),
                          height: ResponsiveUtils.getResponsiveLogoSize(context),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 24, tablet: 32, desktop: 40)),
                    // App title
                    Text(
                      l10n.appName,
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 24, tablet: 28, desktop: 32),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
                    // Tagline
                    Text(
                      l10n.appTagline,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 16, tablet: 18, desktop: 20),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 24, tablet: 32, desktop: 40)),
                    // Login form
                    Container(
                      padding: ResponsiveUtils.getResponsiveEdgeInsets(context, mobile: 16, tablet: 24, desktop: 32),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: AppShadows.medium,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              controller: _userIdController,
                              decoration: InputDecoration(
                                labelText: 'यूज़र आईडी',
                                prefixIcon: Icon(Icons.person),
                              ),
                              validator: (value) => value == null || value.isEmpty ? 'कृपया यूज़र आईडी दर्ज करें' : null,
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'पासवर्ड',
                                prefixIcon: Icon(Icons.lock),
                              ),
                              validator: (value) => value == null || value.isEmpty ? 'कृपया पासवर्ड दर्ज करें' : null,
                            ),
                            SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: _loginType,
                              items: _loginTypes,
                              onChanged: (val) {
                                if (val != null) setState(() => _loginType = val);
                              },
                              decoration: InputDecoration(
                                labelText: l10n.selectRoleToContinue,
                                prefixIcon: Icon(Icons.account_circle),
                              ),
                            ),
                            SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: _isLoading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                backgroundColor: AppColors.primary,
                              ),
                              child: _isLoading
                                  ? SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                    )
                                  : Text('लॉगिन', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}