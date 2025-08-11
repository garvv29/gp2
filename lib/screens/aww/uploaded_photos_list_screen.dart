import 'package:flutter/material.dart';
import '../../models/uploaded_photos_response.dart';
import '../../services/api_service.dart';
import '../../utils/theme.dart';
import '../../utils/app_localizations.dart';
import '../../utils/responsive.dart';

class UploadedPhotosListScreen extends StatefulWidget {
  @override
  _UploadedPhotosListScreenState createState() => _UploadedPhotosListScreenState();
}

class _UploadedPhotosListScreenState extends State<UploadedPhotosListScreen> {
  List<UploadedPhoto> _allPhotos = [];
  List<UploadedPhoto> _filteredPhotos = [];
  bool _isLoading = true;
  String _searchQuery = '';
  int _currentPage = 1;
  int _totalPages = 1;
  bool _hasNextPage = false;

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  Future<void> _loadPhotos({int page = 1}) async {
    setState(() => _isLoading = true);
    try {
      final response = await ApiService.getUploadedPhotos(page: page, limit: 20);
      if (response != null && response.success) {
        setState(() {
          if (page == 1) {
            _allPhotos = response.data.photos;
          } else {
            _allPhotos.addAll(response.data.photos);
          }
          _filteredPhotos = _allPhotos;
          _currentPage = response.data.pagination.currentPage;
          _totalPages = response.data.pagination.totalPages;
          _hasNextPage = response.data.pagination.hasNextPage;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error loading uploaded photos: $e');
      setState(() => _isLoading = false);
    }
  }

  void _filterPhotos(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredPhotos = _allPhotos;
      } else {
        _filteredPhotos = _allPhotos.where((photo) {
          return photo.assignment.child.motherName.toLowerCase().contains(query.toLowerCase()) ||
                 photo.assignment.child.motherMobile.contains(query) ||
                 photo.assignment.child.childName.toLowerCase().contains(query.toLowerCase()) ||
                 photo.assignment.plant.name.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  Future<void> _loadMorePhotos() async {
    if (!_isLoading && _hasNextPage) {
      await _loadPhotos(page: _currentPage + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'अपलोड की गई फोटो',
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
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: ResponsiveUtils.getResponsiveEdgeInsets(context, mobile: 16, tablet: 20, desktop: 24),
            color: AppColors.primary,
            child: TextField(
              onChanged: _filterPhotos,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'माता का नाम, मोबाइल या पौधे का नाम खोजें...',
                hintStyle: TextStyle(color: Colors.white70),
                prefixIcon: Icon(Icons.search, color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
                  borderSide: BorderSide(color: Colors.white30),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
                  borderSide: BorderSide(color: Colors.white30),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
                  borderSide: BorderSide(color: Colors.white),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
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
                _buildStatItem('कुल फोटो', '${_allPhotos.length}', AppColors.primary),
              ],
            ),
          ),

          // Photos List
          Expanded(
            child: _isLoading && _allPhotos.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: AppColors.primary),
                        SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 16, tablet: 20, desktop: 24)),
                        Text(
                          'फोटो लोड हो रही हैं...',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 14, tablet: 16, desktop: 18),
                          ),
                        ),
                      ],
                    ),
                  )
                : _filteredPhotos.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.photo_library_outlined,
                              size: ResponsiveUtils.getResponsiveIconSize(context, mobile: 64, tablet: 80, desktop: 96),
                              color: AppColors.textSecondary,
                            ),
                            SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 16, tablet: 20, desktop: 24)),
                            Text(
                              _searchQuery.isEmpty ? 'कोई फोटो नहीं मिली' : 'कोई खोज परिणाम नहीं मिला',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 16, tablet: 18, desktop: 20),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollInfo) {
                          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent && !_isLoading && _hasNextPage) {
                            _loadMorePhotos();
                          }
                          return true;
                        },
                        child: ListView.builder(
                          padding: ResponsiveUtils.getResponsiveEdgeInsets(context, mobile: 8, tablet: 12, desktop: 16),
                          itemCount: _filteredPhotos.length + (_hasNextPage ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == _filteredPhotos.length) {
                              return Container(
                                padding: ResponsiveUtils.getResponsiveEdgeInsets(context, mobile: 16, tablet: 20, desktop: 24),
                                child: Center(
                                  child: CircularProgressIndicator(color: AppColors.primary),
                                ),
                              );
                            }
                            return _buildPhotoCard(_filteredPhotos[index]);
                          },
                        ),
                      ),
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

  Widget _buildPhotoCard(UploadedPhoto photo) {
    return Card(
      margin: ResponsiveUtils.getResponsiveEdgeInsets(context, mobile: 8, tablet: 12, desktop: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
      ),
      child: InkWell(
        onTap: () => _showPhotoDetail(photo),
        borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
        child: Padding(
          padding: ResponsiveUtils.getResponsiveEdgeInsets(context, mobile: 12, tablet: 16, desktop: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  Container(
                    width: ResponsiveUtils.getResponsiveIconSize(context, mobile: 40, tablet: 48, desktop: 56),
                    height: ResponsiveUtils.getResponsiveIconSize(context, mobile: 40, tablet: 48, desktop: 56),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
                    ),
                    child: Icon(
                      Icons.person,
                      color: AppColors.primary,
                      size: ResponsiveUtils.getResponsiveIconSize(context, mobile: 20, tablet: 24, desktop: 28),
                    ),
                  ),
                  SizedBox(width: ResponsiveUtils.getResponsiveGap(context, mobile: 12, tablet: 16, desktop: 20)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          photo.assignment.child.motherName,
                          style: TextStyle(
                            fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 16, tablet: 18, desktop: 20),
                            fontWeight: FontWeight.w600,
                            color: AppColors.text,
                          ),
                        ),
                        Text(
                          photo.assignment.child.motherMobile,
                          style: TextStyle(
                            fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 14, tablet: 16, desktop: 18),
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16),
                          vertical: ResponsiveUtils.getResponsiveGap(context, mobile: 4, tablet: 6, desktop: 8),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context, mobile: 6, tablet: 8, desktop: 10),
                        ),
                        child: Text(
                          'अपलोड की गई',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 10, tablet: 12, desktop: 14),
                            color: AppColors.success,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 12, tablet: 16, desktop: 20)),
              
              // Photo and Plant Info
              Row(
                children: [
                  ClipRRect(
                    borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
                    child: Image.network(
                      photo.fullUrl,
                      width: ResponsiveUtils.getResponsiveIconSize(context, mobile: 60, tablet: 80, desktop: 100),
                      height: ResponsiveUtils.getResponsiveIconSize(context, mobile: 60, tablet: 80, desktop: 100),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: ResponsiveUtils.getResponsiveIconSize(context, mobile: 60, tablet: 80, desktop: 100),
                          height: ResponsiveUtils.getResponsiveIconSize(context, mobile: 60, tablet: 80, desktop: 100),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Icon(
                            Icons.image_not_supported,
                            color: AppColors.textSecondary,
                            size: ResponsiveUtils.getResponsiveIconSize(context, mobile: 30, tablet: 40, desktop: 50),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: ResponsiveUtils.getResponsiveGap(context, mobile: 12, tablet: 16, desktop: 20)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.local_florist,
                              size: ResponsiveUtils.getResponsiveIconSize(context, mobile: 16, tablet: 20, desktop: 24),
                              color: AppColors.success,
                            ),
                            SizedBox(width: ResponsiveUtils.getResponsiveGap(context, mobile: 4, tablet: 6, desktop: 8)),
                            Expanded(
                              child: Text(
                                photo.assignment.plant.name,
                                style: TextStyle(
                                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 14, tablet: 16, desktop: 18),
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.text,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 4, tablet: 6, desktop: 8)),
                        Row(
                          children: [
                            Icon(
                              Icons.child_care,
                              size: ResponsiveUtils.getResponsiveIconSize(context, mobile: 16, tablet: 20, desktop: 24),
                              color: AppColors.secondary,
                            ),
                            SizedBox(width: ResponsiveUtils.getResponsiveGap(context, mobile: 4, tablet: 6, desktop: 8)),
                            Expanded(
                              child: Text(
                                photo.assignment.child.childName,
                                style: TextStyle(
                                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 14, tablet: 16, desktop: 18),
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 4, tablet: 6, desktop: 8)),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: ResponsiveUtils.getResponsiveIconSize(context, mobile: 16, tablet: 20, desktop: 24),
                              color: AppColors.accent,
                            ),
                            SizedBox(width: ResponsiveUtils.getResponsiveGap(context, mobile: 4, tablet: 6, desktop: 8)),
                            Text(
                              _formatDate(photo.uploadDate),
                              style: TextStyle(
                                fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 12, tablet: 14, desktop: 16),
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              if (photo.notes != null && photo.notes!.isNotEmpty) ...[
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
                Container(
                  padding: ResponsiveUtils.getResponsiveEdgeInsets(context, mobile: 8, tablet: 12, desktop: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.note,
                        size: ResponsiveUtils.getResponsiveIconSize(context, mobile: 16, tablet: 20, desktop: 24),
                        color: AppColors.accent,
                      ),
                      SizedBox(width: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
                      Expanded(
                        child: Text(
                          photo.notes!,
                          style: TextStyle(
                            fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 12, tablet: 14, desktop: 16),
                            color: AppColors.textSecondary,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'आज ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'कल ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} दिन पहले';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showPhotoDetail(UploadedPhoto photo) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
              ),
              child: ClipRRect(
                borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
                child: InteractiveViewer(
                  panEnabled: true,
                  boundaryMargin: EdgeInsets.all(100),
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Image.network(
                    photo.fullUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error,
                              color: Colors.white,
                              size: ResponsiveUtils.getResponsiveIconSize(context, mobile: 48, tablet: 64, desktop: 80),
                            ),
                            SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 16, tablet: 20, desktop: 24)),
                            Text(
                              'फोटो लोड नहीं हो सकी',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 16, tablet: 18, desktop: 20),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              top: ResponsiveUtils.getResponsiveGap(context, mobile: 10, tablet: 15, desktop: 20),
              right: ResponsiveUtils.getResponsiveGap(context, mobile: 10, tablet: 15, desktop: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            Positioned(
              bottom: ResponsiveUtils.getResponsiveGap(context, mobile: 10, tablet: 15, desktop: 20),
              left: ResponsiveUtils.getResponsiveGap(context, mobile: 10, tablet: 15, desktop: 20),
              right: ResponsiveUtils.getResponsiveGap(context, mobile: 10, tablet: 15, desktop: 20),
              child: Container(
                padding: ResponsiveUtils.getResponsiveEdgeInsets(context, mobile: 12, tablet: 16, desktop: 20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${photo.assignment.child.motherName} - ${photo.assignment.plant.name}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 16, tablet: 18, desktop: 20),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 4, tablet: 6, desktop: 8)),
                    Text(
                      _formatDate(photo.uploadDate),
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 14, tablet: 16, desktop: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
