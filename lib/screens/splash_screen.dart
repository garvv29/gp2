import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/theme.dart';
import '../utils/app_localizations.dart';
import '../utils/responsive.dart';
import 'welcome_screen.dart';
import '../services/auth_service.dart';
import '../models/user.dart';
import 'hospital/hospital_dashboard.dart';
import 'aww/aww_dashboard.dart';
import 'mother/mother_dashboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
    _checkLoginAndNavigate();
  }

  void _initializeAnimations() {
    // Logo animations
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));
    
    _logoRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeInOut,
    ));

    // Text animations
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutCubic,
    ));

    // Fade animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    // Pulse animation
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimations() {
    // Start logo animation
    _logoController.forward();
    
    // Start text animation after delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _textController.forward();
      }
    });
    
    // Start fade animation
    _fadeController.forward();
    
    // Start pulse animation
    _pulseController.repeat(reverse: true);
  }

  void _checkLoginAndNavigate() async {
    // Wait for splash animations (minimum 2 seconds for effect)
    await Future.delayed(const Duration(seconds: 2));
    User? user = await AuthService.getCurrentUser();
    if (!mounted) return;
    if (user != null) {
      // Navigate to dashboard based on user role
      Widget dashboard;
      switch (user.role) {
        case 'hospital':
          dashboard = HospitalDashboard();
          break;
        case 'aww':
          dashboard = AWWDashboard();
          break;
        case 'mother':
          dashboard = MotherDashboard();
          break;
        default:
          dashboard = WelcomeScreen();
      }
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => dashboard,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    } else {
      _navigateToWelcome();
    }
  }

  void _navigateToWelcome() {
    print('SplashScreen: Starting navigation timer');
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        print('SplashScreen: Navigating to WelcomeScreen');
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => WelcomeScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _fadeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.primary,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primary,
                AppColors.primaryLight,
                AppColors.secondary,
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Top section with animated elements
                Expanded(
                  flex: 3,
                  child: _buildTopSection(l10n),
                ),
                // Middle section with logo (move up by reducing gap)
                SizedBox(height: 8), // reduce gap
                Expanded(
                  flex: 3, // reduce flex to move logo up
                  child: _buildLogoSection(l10n),
                ),
                // Bottom section with loading (move up by reducing gap)
                SizedBox(height: 4), // reduce gap
                Expanded(
                  flex: 2,
                  child: _buildBottomSection(l10n),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection(AppLocalizations l10n) {
    return Container(
      padding: ResponsiveUtils.getResponsiveEdgeInsets(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated floating elements
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _textSlideAnimation,
              child: Column(
                children: [
                  // Floating leaves animation
                  _buildFloatingLeaves(),
                  
                  SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 20, tablet: 30, desktop: 40)),
                  
                  // App name with glow effect
                  Container(
                    padding: ResponsiveUtils.getResponsiveEdgeInsets(context, mobile: 16, tablet: 24, desktop: 32),
                    decoration: BoxDecoration(
                      borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Text(
                      l10n.appName,
                      style: TextStyle(
                        fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 28, tablet: 36, desktop: 44),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(2, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingLeaves() {
    return SizedBox(
      height: ResponsiveUtils.getResponsiveIconSize(context, mobile: 60, tablet: 80, desktop: 100),
      child: Stack(
        children: [
          // Leaf 1
          Positioned(
            left: ResponsiveUtils.getResponsiveGap(context, mobile: 20, tablet: 30, desktop: 40),
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Icon(
                    Icons.eco,
                    size: ResponsiveUtils.getResponsiveIconSize(context, mobile: 30, tablet: 40, desktop: 50),
                    color: Colors.white.withOpacity(0.8),
                  ),
                );
              },
            ),
          ),
          
          // Leaf 2
          Positioned(
            right: ResponsiveUtils.getResponsiveGap(context, mobile: 20, tablet: 30, desktop: 40),
            top: ResponsiveUtils.getResponsiveGap(context, mobile: 10, tablet: 15, desktop: 20),
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value * 0.8,
                  child: Icon(
                    Icons.eco,
                    size: ResponsiveUtils.getResponsiveIconSize(context, mobile: 25, tablet: 35, desktop: 45),
                    color: Colors.white.withOpacity(0.6),
                  ),
                );
              },
            ),
          ),
          
          // Leaf 3
          Positioned(
            left: MediaQuery.of(context).size.width * 0.5 - ResponsiveUtils.getResponsiveIconSize(context, mobile: 10, tablet: 15, desktop: 20),
            top: ResponsiveUtils.getResponsiveGap(context, mobile: 5, tablet: 10, desktop: 15),
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value * 0.6,
                  child: Icon(
                    Icons.eco,
                    size: ResponsiveUtils.getResponsiveIconSize(context, mobile: 20, tablet: 30, desktop: 40),
                    color: Colors.white.withOpacity(0.4),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoSection(AppLocalizations l10n) {
    return Container(
      padding: ResponsiveUtils.getResponsiveEdgeInsets(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Main logo with animations
          AnimatedBuilder(
            animation: _logoController,
            builder: (context, child) {
              return Transform.scale(
                scale: _logoScaleAnimation.value,
                child: Transform.rotate(
                  angle: _logoRotationAnimation.value * 0.1,
                  child: Container(
                    width: ResponsiveUtils.getResponsiveLogoSize(context, mobile: 120, tablet: 160, desktop: 200),
                    height: ResponsiveUtils.getResponsiveLogoSize(context, mobile: 120, tablet: 160, desktop: 200),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context, mobile: 20, tablet: 30, desktop: 40),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                        BoxShadow(
                          color: Colors.white.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context, mobile: 20, tablet: 30, desktop: 40),
                      child: Image.asset(
                        'assets/images/logo.jpg',
                        width: ResponsiveUtils.getResponsiveLogoSize(context, mobile: 120, tablet: 160, desktop: 200),
                        height: ResponsiveUtils.getResponsiveLogoSize(context, mobile: 120, tablet: 160, desktop: 200),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          // Add District Administration Raipur logo and text below main logo
          SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 18, tablet: 26, desktop: 34)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: ResponsiveUtils.getResponsiveIconSize(context, mobile: 24, tablet: 32, desktop: 40),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(
                      'assets/images/cg.png',
                      width: ResponsiveUtils.getResponsiveIconSize(context, mobile: 32, tablet: 40, desktop: 48),
                      height: ResponsiveUtils.getResponsiveIconSize(context, mobile: 32, tablet: 40, desktop: 48),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SizedBox(width: ResponsiveUtils.getResponsiveGap(context, mobile: 14, tablet: 20, desktop: 28)),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'District Administration Raipur',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 15, tablet: 19, desktop: 24),
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                  // Optional subtitle for extra polish
                  // SizedBox(height: 2),
                  // Text(
                  //   'Chhattisgarh',
                  //   style: TextStyle(
                  //     fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 11, tablet: 13, desktop: 15),
                  //     color: Colors.black45,
                  //     fontWeight: FontWeight.w400,
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 26, tablet: 38, desktop: 54)),
          // Tagline with slide animation
          SlideTransition(
            position: _textSlideAnimation,
            child: Container(
              padding: ResponsiveUtils.getResponsiveEdgeInsets(context, mobile: 12, tablet: 16, desktop: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                l10n.appTagline,
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 16, tablet: 18, desktop: 20),
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(AppLocalizations l10n) {
    return Container(
      padding: ResponsiveUtils.getResponsiveEdgeInsets(context).copyWith(
        top: ResponsiveUtils.getResponsiveGap(context, mobile: 6, tablet: 10, desktop: 14),
        bottom: ResponsiveUtils.getResponsiveGap(context, mobile: 0, tablet: 2, desktop: 4), // minimal bottom padding
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
      child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Loading indicator
          FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                SizedBox(
                  width: ResponsiveUtils.getResponsiveIconSize(context, mobile: 40, tablet: 50, desktop: 60),
                  height: ResponsiveUtils.getResponsiveIconSize(context, mobile: 40, tablet: 50, desktop: 60),
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 3,
                    backgroundColor: Colors.white24,
                  ),
                ),
                        SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 6, tablet: 8, desktop: 10)),
                // Loading text
                Text(
                  l10n.loading,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 14, tablet: 16, desktop: 18),
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                        // SSIPMT logo row (larger and closer)
                        SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 4, tablet: 6, desktop: 8)),
                        Column(
                          children: [
                            Text(
                              'Powered by',
                              style: TextStyle(
                                fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 13, tablet: 15, desktop: 18),
                                color: Colors.white.withOpacity(0.8),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                              ),
                            ),
                            SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 2, tablet: 3, desktop: 4)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 0,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        'assets/images/ssipmt.jpeg',
                                        width: ResponsiveUtils.getResponsiveIconSize(context, mobile: 36, tablet: 44, desktop: 52),
                                        height: ResponsiveUtils.getResponsiveIconSize(context, mobile: 36, tablet: 44, desktop: 52),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 10, desktop: 14)),
                                Flexible(
                                  child: Text(
                                    'SSIPMT',
                                    style: TextStyle(
                                      fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 16, tablet: 20, desktop: 24),
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.2),
                                          offset: Offset(1, 1),
                                          blurRadius: 2,
                                        ),
                                      ],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 2, tablet: 4, desktop: 6)),
                // App version or additional info
                Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 12, tablet: 14, desktop: 16),
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
              ),
            ),
          );
        },
      ),
    );
  }
}