import 'package:flutter/material.dart';
import '../../utils/theme.dart';
import '../../utils/responsive.dart';
import '../../utils/app_localizations.dart';

class MotherDashboardAppBar extends StatefulWidget implements PreferredSizeWidget {
  final BuildContext context;
  final AppLocalizations l10n;
  final VoidCallback onRefresh;
  final VoidCallback onLogout;
  final VoidCallback? onDownloadCertificate;

  const MotherDashboardAppBar({
    required this.context,
    required this.l10n,
    required this.onRefresh,
    required this.onLogout,
    this.onDownloadCertificate,
    Key? key,
  }) : super(key: key);

  @override
  State<MotherDashboardAppBar> createState() => _MotherDashboardAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _MotherDashboardAppBarState extends State<MotherDashboardAppBar> {

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        widget.l10n.myPlants,
        style: TextStyle(
          fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 18, tablet: 20, desktop: 22),
        ),
      ),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      actions: [
        if (widget.onDownloadCertificate != null)
          Container(
            margin: EdgeInsets.only(right: ResponsiveUtils.getResponsiveGap(context, mobile: 4, tablet: 6, desktop: 8)),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
            ),
            child: IconButton(
              icon: Icon(
                Icons.download,
                size: ResponsiveUtils.getResponsiveIconSize(context, mobile: 20, tablet: 24, desktop: 28),
              ),
              onPressed: widget.onDownloadCertificate,
              tooltip: 'Download Certificate',
            ),
          ),
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
            onPressed: widget.onRefresh,
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
            onPressed: widget.onLogout,
          ),
        ),
      ],
    );
  }
}
