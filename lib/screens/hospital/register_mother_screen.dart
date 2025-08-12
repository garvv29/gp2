import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/theme.dart';
import '../../utils/app_localizations.dart';
import '../../utils/responsive.dart';
import '../../utils/image_compression_service.dart';
import '../../services/api_service.dart';
import '../../models/hospital_dashboard_response.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterMotherScreen extends StatefulWidget {
  final List<dynamic> plantList;

  const RegisterMotherScreen({Key? key, required this.plantList}) : super(key: key);

  @override
  _RegisterMotherScreenState createState() => _RegisterMotherScreenState();
}

class _RegisterMotherScreenState extends State<RegisterMotherScreen> {
  final _formKey = GlobalKey<FormState>();
  final _motherNameController = TextEditingController();
  final _fatherHusbandNameController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _deliveryTimeController = TextEditingController();
  final _childOrderController = TextEditingController();
  final _weightAtBirthController = TextEditingController();
  final _villageController = TextEditingController(); // NEW: Village field
  final _addressController = TextEditingController(); // NEW: Additional address field
  
  DateTime? _deliveryDate;
  String? _selectedDeliveryType;
  String? _selectedBloodGroup;
  String? _selectedDistrict;
  String? _selectedBlock;
  String? _selectedChildGender;
  
  List<String> _selectedPlants = [];
  String? _certificatePath;
  String? _photoPath;
  
  bool _isLoading = false;

  File? _motherPhoto;
  File? _certificatePhoto;
  final ImagePicker _picker = ImagePicker();

  // Dashboard data
  List<HospitalDistrict> _districts = [];
  List<HospitalBlock> _blocks = [];
  List<HospitalPlant> _plants = [];
  List<HospitalBlock> _filteredBlocks = [];

  // Mock data for dropdowns
  final List<String> _deliveryTypes = ['normal', 'cesarean', 'assisted'];
  final List<String> _bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  final List<String> _childGenders = ['male', 'female'];
  final List<String> _plantTypes = [];

  // New fields for additional form data
  String? _selectedBirthCertificate;
  String? _selectedPmmvy;
  String? _selectedShramikCard;
  String? _selectedAyushmanCard;
  String? _selectedBenefitNsy;
  String? _selectedNsyForm;
  String? _mantraVandana;
  String? _ayushmanCardAmount;

  // For plant selection with quantity
  List<Map<String, dynamic>> _selectedPlantQuantities = [];

  // New state variables for yes/no questions
  String? _q1JananiSuraksha, _q2Ayushman, _q3PMMVY, _q4PMMVYAmount, _q5MahtariVandan, _q6ShramikCard, _q7NoniSuraksha;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
    _filteredBlocks = [];
    // Use widget.plantList if provided
    if (widget.plantList.isNotEmpty) {
      _plants = List<HospitalPlant>.from(widget.plantList);
    }
  }

  Future<void> _loadDashboardData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dashboardDataString = prefs.getString('dashboarddata');
      if (dashboardDataString != null) {
        final dashboardJson = jsonDecode(dashboardDataString);
        final dashboardResponse = HospitalDashboardResponse.fromJson(dashboardJson);
        setState(() {
          _districts = dashboardResponse.data.districtList
              .where((d) => d.districtCode > 0 && 
                          d.districtName != null && 
                          d.lgdDistrictCode != null && 
                          d.lgdDistrictCode!.isNotEmpty)
              .toList();
          _blocks = dashboardResponse.data.blockList
              .where((b) => b.blockCode > 0 && 
                          b.blockName != null && 
                          b.lgdBlockCode != null && 
                          b.lgdBlockCode!.isNotEmpty)
              .toList();
          _plants = dashboardResponse.data.plantList;
          _filteredBlocks = [];
        });
      }
    } catch (e) {
      print('Error loading dashboard data: $e');
    }
  }

  @override
  void dispose() {
    _motherNameController.dispose();
    _fatherHusbandNameController.dispose();
    _mobileNumberController.dispose();
    _deliveryTimeController.dispose();
    _childOrderController.dispose();
    _weightAtBirthController.dispose();
    _villageController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l10n.motherRegistration,
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
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: ResponsiveUtils.getResponsiveEdgeInsets(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Personal Information Section
                _buildSectionHeader(l10n.personalInformation, Icons.person),
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 12, tablet: 16, desktop: 20)),
                
                _buildTextField(
                  controller: _motherNameController,
                  label: l10n.motherName,
                  validator: (value) => value?.isEmpty == true ? 'Required' : null,
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
                
                _buildTextField(
                  controller: _fatherHusbandNameController,
                  label: l10n.fatherHusbandName,
                  validator: (value) => value?.isEmpty == true ? 'Required' : null,
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
                
                _buildTextField(
                  controller: _mobileNumberController,
                  label: l10n.mobileNumber,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value?.isEmpty == true) return 'Required';
                    if (value?.length != 10) return l10n.invalidMobileNumber;
                    return null;
                  },
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
                
                _buildDropdownField(
                  label: 'बच्चे का लिंग',
                  value: _selectedChildGender,
                  items: _childGenders,
                  onChanged: (value) => setState(() => _selectedChildGender = value),
                  getDisplayText: (value) => value == 'male' ? 'लड़का' : 'लड़की',
                  validator: (value) => value == null ? 'Required' : null,
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 16, tablet: 24, desktop: 32)),
                
                // Delivery Information Section
                _buildSectionHeader(l10n.deliveryInformation, Icons.local_hospital),
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 12, tablet: 16, desktop: 20)),
                
                _buildDateField(l10n.deliveryDate, _deliveryDate, (date) {
                  setState(() => _deliveryDate = date);
                }),
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
                
                _buildTimeField('डिलीवरी का समय', _deliveryTimeController),
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
                
                _buildDropdownField(
                  label: l10n.deliveryType,
                  value: _selectedDeliveryType,
                  items: _deliveryTypes,
                  onChanged: (value) => setState(() => _selectedDeliveryType = value),
                  getDisplayText: (value) {
                    switch (value) {
                      case 'normal': return l10n.getDisplayText('normalDelivery');
                      case 'cesarean': return l10n.getDisplayText('cesareanDelivery');
                      case 'assisted': return l10n.getDisplayText('assistedDelivery');
                      default: return value;
                    }
                  },
                  validator: (value) => value == null ? 'Required' : null,
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
                
                _buildDropdownField(
                  label: l10n.bloodGroup,
                  value: _selectedBloodGroup,
                  items: _bloodGroups,
                  onChanged: (value) => setState(() => _selectedBloodGroup = value),
                  validator: (value) => value == null ? 'Required' : null,
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
                
                _buildTextField(
                  controller: _childOrderController,
                  label: 'डिलीवरी का क्रम (1, 2, 3...)',
                  keyboardType: TextInputType.number,
                  validator: (value) => value?.isEmpty == true ? 'Required' : null,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
                
                _buildTextField(
                  controller: _weightAtBirthController,
                  label: 'जन्म के समय वजन (kg)',
                  keyboardType: TextInputType.number,
                  validator: (value) => value?.isEmpty == true ? 'Required' : null,
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
                
                _buildDropdownField(
                  label: 'बर्थ सर्टिफिकेट मिला?',
                  value: _selectedBirthCertificate,
                  items: ['yes', 'no'],
                  onChanged: (value) => setState(() => _selectedBirthCertificate = value),
                  validator: (value) => value == null ? 'Required' : null,
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
                
                _buildDropdownField(
                  label: 'PMMVY का लाभ मिला?',
                  value: _selectedPmmvy,
                  items: ['yes', 'no'],
                  onChanged: (value) => setState(() => _selectedPmmvy = value),
                  validator: (value) => value == null ? 'Required' : null,
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
                
                _buildDropdownField(
                  label: 'श्रमिक कार्ड बना?',
                  value: _selectedShramikCard,
                  items: ['yes', 'no'],
                  onChanged: (value) => setState(() => _selectedShramikCard = value),
                  validator: (value) => value == null ? 'Required' : null,
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
                
                _buildDropdownField(
                  label: 'आयुष्मान कार्ड का उपयोग?',
                  value: _selectedAyushmanCard,
                  items: ['yes', 'no'],
                  onChanged: (value) => setState(() => _selectedAyushmanCard = value),
                  validator: (value) => value == null ? 'Required' : null,
                ),
                if (_selectedAyushmanCard == 'yes')
                  _buildTextField(
                    controller: TextEditingController(text: _ayushmanCardAmount),
                    label: 'आयुष्मान कार्ड से खर्च (₹)',
                    keyboardType: TextInputType.number,
                    validator: (value) => value?.isEmpty == true ? 'Required' : null,
                    onChanged: (val) => _ayushmanCardAmount = val,
                  ),
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
                
                _buildDropdownField(
                  label: 'क्या लाभार्थी NSY के अंतर्गत आती है?',
                  value: _selectedBenefitNsy,
                  items: ['yes', 'no'],
                  onChanged: (value) => setState(() => _selectedBenefitNsy = value),
                  validator: (value) => value == null ? 'Required' : null,
                ),
                if (_selectedBenefitNsy == 'yes')
                  _buildDropdownField(
                    label: 'क्या NSY फॉर्म मिला?',
                    value: _selectedNsyForm,
                    items: ['yes', 'no'],
                    onChanged: (value) => setState(() => _selectedNsyForm = value),
                    validator: (value) => value == null ? 'Required' : null,
                  ),
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
                
                _buildDropdownField(
                  label: 'क्या Mantra Vandana के अंतर्गत ₹3000 मिला?',
                  value: _mantraVandana,
                  items: ['yes', 'no'],
                  onChanged: (value) => setState(() => _mantraVandana = value),
                  validator: (value) => value == null ? 'Required' : null,
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 16, tablet: 24, desktop: 32)),
                
                // Beneficiary Address Section
                _buildSectionHeader(l10n.beneficiaryAddress, Icons.location_on),
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 12, tablet: 16, desktop: 20)),
                
                _buildDropdownField(
                  label: l10n.district,
                  value: _selectedDistrict,
                  items: _districts.map((d) => d.lgdDistrictCode ?? '').where((code) => code.isNotEmpty).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDistrict = value;
                      _selectedBlock = null;
                      // Find the selected district's int code
                      final selectedDistrict = _districts.firstWhere(
                        (d) => d.lgdDistrictCode == value,
                        orElse: () => HospitalDistrict(districtCode: 0),
                      );
                      _filteredBlocks = _blocks.where((b) => b.districtCode == selectedDistrict.districtCode).toList();
                    });
                  },
                  getDisplayText: (value) {
                    final district = _districts.firstWhere(
                      (d) => d.lgdDistrictCode == value,
                      orElse: () => HospitalDistrict(districtCode: 0, districtName: 'जिला चुनें'),
                    );
                    return district.districtName ?? 'जिला चुनें';
                  },
                  validator: (value) => value == null ? 'Required' : null,
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
                _buildDropdownField(
                  label: 'ब्लॉक',
                  value: _selectedBlock,
                  items: _filteredBlocks.map((b) => b.lgdBlockCode ?? '').where((code) => code.isNotEmpty).toList(),
                  onChanged: (value) => setState(() => _selectedBlock = value),
                  getDisplayText: (value) {
                    final block = _filteredBlocks.firstWhere(
                      (b) => b.lgdBlockCode == value,
                      orElse: () => HospitalBlock(blockCode: 0, blockName: 'ब्लॉक चुनें'),
                    );
                    return block.blockName ?? 'ब्लॉक चुनें';
                  },
                  validator: (value) => value == null ? 'Required' : null,
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
                
                // NEW: Village Field
                _buildTextField(
                  controller: _villageController,
                  label: 'गाँव',
                  validator: (value) => value?.isEmpty == true ? 'गाँव का नाम आवश्यक है' : null,
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
                
                // NEW: Additional Address Field
                _buildTextField(
                  controller: _addressController,
                  label: 'पूरा पता (CHC/PHC/SHC या अन्य विवरण)',
                  validator: (value) => value?.isEmpty == true ? 'पूरा पता आवश्यक है' : null,
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 16, tablet: 24, desktop: 32)),
                
                // Plant Distribution Section
                _buildSectionHeader(l10n.plantDistributionInfo, Icons.eco),
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 12, tablet: 16, desktop: 20)),
                
                _buildPlantQuantitySelection(),
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 16, tablet: 24, desktop: 32)),
                
                // Certificate Upload Section (Birth Certificate, Discharge Papers)
                _buildSectionHeader('प्रमाण पत्र अपलोड (जन्म प्रमाण/डिस्चार्ज पेपर)', Icons.description),
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 12, tablet: 16, desktop: 20)),
                
                _buildFileUpload(
                  label: 'प्रमाण पत्र फोटो',
                  subtitle: 'जन्म प्रमाण पत्र या डिस्चार्ज पेपर की फोटो',
                  filePath: _certificatePath,
                  onTap: () => _pickImageFromCamera(true),
                  icon: Icons.description,
                ),
                if (_certificatePhoto != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Image.file(_certificatePhoto!, height: 120),
                  ),
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 16, tablet: 24, desktop: 32)),
                
                // Plant Distribution Photo Section (Mother+Child+Plant)
                _buildSectionHeader('पौधा वितरण फोटो (माँ+बच्चा+पौधा)', Icons.camera_alt),
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 12, tablet: 16, desktop: 20)),
                
                _buildFileUpload(
                  label: 'पौधा वितरण फोटो',
                  subtitle: 'माँ, बच्चा और पौधे की एक साथ फोटो',
                  filePath: _photoPath,
                  onTap: () => _pickImageFromCamera(false),
                  icon: Icons.camera_alt,
                ),
                if (_motherPhoto != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Image.file(_motherPhoto!, height: 120),
                  ),
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 24, tablet: 32, desktop: 40)),

                // --- NEW: Additional Yes/No Questions (bottom of form) ---
                
                Divider(),
                // --- END NEW ---
                // _buildYesNoQuestion(
                //   '1. जननी सुरक्षा योजना का लाभ दिया गया है?',
                //   _q1JananiSuraksha,
                //   (val) => setState(() => _q1JananiSuraksha = val),
                //   options: ['हाँ', 'प्रक्रियाधीन', 'नहीं'],
                // ),
                // _buildYesNoQuestion(
                //   '2. क्या प्रसव के लिये आयुष्मान कार्ड का उपयोग किया गया है?',
                //   _q2Ayushman,
                //   (val) => setState(() => _q2Ayushman = val),
                // ),
                // _buildYesNoQuestion(
                //   '3. प्रधानमंत्री मातृ वंदना योजना का लाभ मिला है?',
                //   _q3PMMVY,
                //   (val) => setState(() => _q3PMMVY = val),
                // ),
                // _buildYesNoQuestion(
                //   '4. प्रधानमंत्री मातृ वंदना योजना की राशि 3000/- प्राप्त हुई है?',
                //   _q4PMMVYAmount,
                //   (val) => setState(() => _q4PMMVYAmount = val),
                // ),
                // _buildYesNoQuestion(
                //   '5. क्या महतारी वंदन योजना का लाभ (प्रतिमाह 1000/- के मान से) मिल रहा है?',
                //   _q5MahtariVandan,
                //   (val) => setState(() => _q5MahtariVandan = val),
                // ),
                // _buildYesNoQuestion(
                //   '6. क्या श्रमिक कार्ड बना हुआ है?',
                //   _q6ShramikCard,
                //   (val) => setState(() => _q6ShramikCard = val),
                // ),
                // _buildYesNoQuestion(
                //   '7. क्या लाभार्थी नोनो सुरक्षा योजना योजना के लिये पात्र है?',
                //   _q7NoniSuraksha,
                //   (val) => setState(() => _q7NoniSuraksha = val),
                // ),
                // Divider(),
                // --- END NEW ---

                // Action Buttons
                _buildActionButtons(l10n),
                SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 16, tablet: 24, desktop: 32)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Container(
      padding: ResponsiveUtils.getResponsiveEdgeInsets(context, mobile: 12, tablet: 16, desktop: 20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: ResponsiveUtils.getResponsiveIconSize(context, mobile: 20, tablet: 24, desktop: 28),
          ),
          SizedBox(width: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 16, tablet: 18, desktop: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
        ),
        filled: true,
        fillColor: AppColors.surface,
      ),
    );
  }

  Widget _buildDateField(String label, DateTime? selectedDate, Function(DateTime?) onDateSelected) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
        );
        if (date != null) {
          onDateSelected(date);
        }
      },
      child: Container(
        padding: ResponsiveUtils.getResponsiveEdgeInsets(context, mobile: 12, tablet: 16, desktop: 20),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
          color: AppColors.surface,
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: AppColors.primary),
            SizedBox(width: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
            Expanded(
              child: Text(
                selectedDate != null 
                    ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
                    : label,
                style: TextStyle(
                  color: selectedDate != null ? AppColors.text : AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeField(String label, TextEditingController controller) {
    return InkWell(
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (picked != null) {
          final formatted = picked.hour.toString().padLeft(2, '0') + ':' + picked.minute.toString().padLeft(2, '0');
          setState(() {
            controller.text = formatted;
          });
        }
      },
      child: IgnorePointer(
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
              borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
            ),
            filled: true,
            fillColor: AppColors.surface,
          ),
          validator: (value) => value?.isEmpty == true ? 'Required' : null,
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    String Function(String)? getDisplayText,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(getDisplayText?.call(item) ?? item),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: label.contains('जिला') ? 'जिला चुनें' : 
                  label.contains('ब्लॉक') ? 'ब्लॉक चुनें' : 'चुनें',
        border: OutlineInputBorder(
          borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
        ),
        filled: true,
        fillColor: AppColors.surface,
      ),
    );
  }

  Widget _buildPlantQuantitySelection() {
    // Show all plants with a quantity selector
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('पौधों का चयन और मात्रा', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.text, fontWeight: FontWeight.w500)),
        SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
        ..._plants.map((plant) {
          final plantId = plant.id;
          final idx = _selectedPlantQuantities.indexWhere((p) => p['plant_id'] == plantId);
          int quantity = idx >= 0 ? _selectedPlantQuantities[idx]['quantity'] : 0;
          return Row(
            children: [
              Expanded(child: Text(plant.name)),
              SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.remove_circle_outline, color: Colors.green),
                onPressed: () {
                  setState(() {
                    if (quantity > 0) {
                      if (idx >= 0) {
                        _selectedPlantQuantities[idx]['quantity'] = quantity - 1;
                      } else {
                        _selectedPlantQuantities.add({'plant_id': plantId, 'quantity': 0});
                      }
                    }
                  });
                },
              ),
              Container(
                width: 40,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text('$quantity', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              IconButton(
                icon: Icon(Icons.add_circle_outline, color: Colors.green),
                onPressed: () {
                  setState(() {
                    if (idx >= 0) {
                      _selectedPlantQuantities[idx]['quantity'] = quantity + 1;
                    } else {
                      _selectedPlantQuantities.add({'plant_id': plantId, 'quantity': 1});
                    }
                  });
                },
              ),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _buildFileUpload({
    required String label,
    String? subtitle,
    required String? filePath,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    final l10n = AppLocalizations.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: ResponsiveUtils.getResponsiveEdgeInsets(context, mobile: 12, tablet: 16, desktop: 20),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
          color: AppColors.surface,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon ?? Icons.upload_file, color: AppColors.primary),
                SizedBox(width: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.text,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 2, tablet: 4, desktop: 6)),
                        Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: AppColors.textSecondary, size: 16),
              ],
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
            Container(
              width: double.infinity,
              padding: ResponsiveUtils.getResponsiveEdgeInsets(context, mobile: 8, tablet: 12, desktop: 16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context, mobile: 6, tablet: 8, desktop: 10),
                border: Border.all(color: AppColors.border.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  Icon(
                    filePath != null ? Icons.check_circle : Icons.add_circle_outline,
                    color: filePath != null ? AppColors.success : AppColors.textSecondary,
                    size: 20,
                  ),
                  SizedBox(width: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
                  Expanded(
                    child: Text(
                      filePath != null ? filePath.split('/').last : l10n.chooseFile,
                      style: TextStyle(
                        color: filePath != null ? AppColors.text : AppColors.textSecondary,
                        fontWeight: filePath != null ? FontWeight.w500 : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _resetForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.surface,
              foregroundColor: AppColors.text,
            ),
            child: Text(l10n.reset),
          ),
        ),
        SizedBox(width: ResponsiveUtils.getResponsiveGap(context, mobile: 8, tablet: 12, desktop: 16)),
        Expanded(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _submitForm,
            child: _isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(l10n.submit),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImageFromCamera(bool isCertificate) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 90,
        maxWidth: 1920,
        maxHeight: 1920,
      );
      
      if (pickedFile != null) {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: AppColors.primary),
                  SizedBox(height: 16),
                  Text('फोटो को optimize कर रहे हैं...'),
                ],
              ),
            ),
          ),
        );

        // Compress the image
        final File originalFile = File(pickedFile.path);
        final File? compressedFile = await ImageCompressionService.compressImage(originalFile);
        
        // Close loading dialog
        Navigator.pop(context);
        
        if (compressedFile != null) {
          setState(() {
            if (isCertificate) {
              _certificatePhoto = compressedFile;
            } else {
              _motherPhoto = compressedFile;
            }
          });
          
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('फोटो सफलतापूर्वक upload की गई'),
              backgroundColor: AppColors.success,
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('फोटो upload में समस्या हुई'),
              backgroundColor: AppColors.error,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      // Close loading dialog if open
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('फोटो upload में त्रुटि: $e'),
          backgroundColor: AppColors.error,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      _motherNameController.clear();
      _fatherHusbandNameController.clear();
      _mobileNumberController.clear();
      _deliveryTimeController.clear();
      _childOrderController.clear();
      _weightAtBirthController.clear();
      _deliveryDate = null;
      _selectedDeliveryType = null;
      _selectedBloodGroup = null;
      _selectedDistrict = null;
      _selectedBlock = null;
      _selectedChildGender = null;
      _selectedPlants.clear();
      _certificatePath = null;
      _photoPath = null;
      _motherPhoto = null;
      _certificatePhoto = null;
      _selectedBirthCertificate = null;
      _selectedPmmvy = null;
      _selectedShramikCard = null;
      _selectedAyushmanCard = null;
      _selectedBenefitNsy = null;
      _selectedNsyForm = null;
      _mantraVandana = null;
      _ayushmanCardAmount = null;
      _selectedPlantQuantities.clear();
      // Reset new yes/no questions
      _q1JananiSuraksha = null;
      _q2Ayushman = null;
      _q3PMMVY = null;
      _q4PMMVYAmount = null;
      _q5MahtariVandan = null;
      _q6ShramikCard = null;
      _q7NoniSuraksha = null;
    });
  }

  Future<void> _submitForm() async {
    final l10n = AppLocalizations.of(context);
    
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.pleaseFillAllFields),
          backgroundColor: AppColors.error,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (_deliveryDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.invalidDate),
          backgroundColor: AppColors.error,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Check if at least one plant quantity is selected
    final totalPlantQty = _selectedPlantQuantities.fold<int>(0, (sum, p) => sum + ((p['quantity'] ?? 0) as int));
    if (totalPlantQty == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('कम से कम एक पौधा चुनें'),
          backgroundColor: AppColors.error,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    if (totalPlantQty > 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('कुल पौधों की मात्रा 5 से अधिक नहीं हो सकती'),
          backgroundColor: AppColors.error,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (_certificatePhoto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('कृपया प्रमाण पत्र अपलोड करें'),
          backgroundColor: AppColors.error,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (_motherPhoto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('कृपया माता का फोटो अपलोड करें'),
          backgroundColor: AppColors.error,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Format delivery date as YYYY-MM-DD
      final formattedDate = _deliveryDate != null
          ? '${_deliveryDate!.year.toString().padLeft(4, '0')}-${_deliveryDate!.month.toString().padLeft(2, '0')}-${_deliveryDate!.day.toString().padLeft(2, '0')}'
          : '';
      
      // Prepare plant_quantity and plants arrays
      final plantQuantity = _selectedPlantQuantities.where((p) => p['quantity'] > 0).toList();
      
      // Map child order number to string
      String childOrderStr = '';
      switch (_childOrderController.text.trim()) {
        case '1': childOrderStr = 'first'; break;
        case '2': childOrderStr = 'second'; break;
        case '3': childOrderStr = 'third'; break;
        case '4': childOrderStr = 'fourth'; break;
        default: childOrderStr = _childOrderController.text.trim(); // fallback
      }
      
      // Call the API
      final response = await ApiService.registerMother(
        motherName: _motherNameController.text,
        fatherHusbandName: _fatherHusbandNameController.text,
        childGender: _selectedChildGender!,
        mobileNumber: _mobileNumberController.text,
        deliveryDate: formattedDate,
        deliveryTime: _deliveryTimeController.text,
        deliveryType: _selectedDeliveryType!,
        bloodGroup: _selectedBloodGroup!,
        childOrder: childOrderStr,
        weightAtBirth: _weightAtBirthController.text,
        districtLgdCode: _selectedDistrict!,
        blockLgdCode: _selectedBlock!,
        village: _villageController.text,
        address: _addressController.text,
        plantQuantity: plantQuantity,
        birthCertificate: _selectedBirthCertificate!,
        pmmvy: _selectedPmmvy!,
        plants: plantQuantity,
        isShramikCard: _selectedShramikCard!,
        isUsedAyushmanCard: _selectedAyushmanCard!,
        ayushmanCardAmount: _ayushmanCardAmount ?? '',
        isBenefitNsy: _selectedChildGender == 'female' ? _selectedBenefitNsy! : '',
        isNsyForm: _selectedChildGender == 'female' ? _selectedNsyForm ?? '' : '',
        mantraVandana: _mantraVandana ?? '',
        deliveryDocumentPath: _certificatePhoto?.path,
        motherPhotoPath: _motherPhoto?.path,
        // Pass new yes/no questions
        jananiSurakshaYojana: _q1JananiSuraksha,
        ayushmanCardUsed: _q2Ayushman,
        pmMatruVandanaYojana: _q3PMMVY,
        pmMatruVandanaYojanaAmount: _q4PMMVYAmount,
        mahtariVandanYojana: _q5MahtariVandan,
        shramikCard: _q6ShramikCard,
        noniSurakshaYojana: _q7NoniSuraksha,
      );

      setState(() => _isLoading = false);

      print('[REGISTRATION RESPONSE] success: \\${response?.success}, message: \\${response?.message}, data: \\${response?.data}');

      if (response != null && response.success) {
        // Upload photos to the new mother photos storage system if available
        bool photosUploaded = true;
        if (_motherPhoto != null || _certificatePhoto != null) {
          try {
            // Prepare photo paths according to new photo types
            List<String>? certificatePhotoPaths;
            List<String>? plantDistributionPhotoPaths;
            
            if (_certificatePhoto != null) {
              certificatePhotoPaths = [_certificatePhoto!.path];
            }
            
            if (_motherPhoto != null) {
              plantDistributionPhotoPaths = [_motherPhoto!.path];
            }
            
            photosUploaded = await ApiService.uploadMotherPhotos(
              childId: response.data.childId,
              certificatePhotoPaths: certificatePhotoPaths,
              plantDistributionPhotoPaths: plantDistributionPhotoPaths,
            );
            
            if (!photosUploaded) {
              print('[WARNING] Photos upload failed but registration was successful');
            }
          } catch (e) {
            print('[ERROR] Photos upload error: $e');
            photosUploaded = false;
          }
        }
        
        // Show a dialog with registration details
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            titlePadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            title: Container(
              decoration: BoxDecoration(
                color: Colors.green[600],
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  Icon(Icons.check_circle, color: Colors.white, size: 48),
                  SizedBox(height: 10),
                  Text(
                    'पंजीकरण सफल',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  if (!photosUploaded && (_motherPhoto != null || _certificatePhoto != null))
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'फोटो अपलोड में समस्या',
                        style: TextStyle(color: Colors.orange[200], fontSize: 14),
                      ),
                    ),
                ],
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(response.message, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.green[800], fontSize: 16)),
                  SizedBox(height: 12),
                  Divider(),
                  _buildDetailRow('Registration ID', response.data.registrationId),
                  _buildDetailRow('Login ID', response.data.loginCredentials.userid),
                  _buildDetailRow('Default Password', response.data.loginCredentials.defaultPassword),
                  Divider(),
                  _buildDetailRow('District', response.data.location.district),
                  _buildDetailRow('Block', response.data.location.block),
                  _buildDetailRow('Village', response.data.location.village),
                  if (response.data.assignedPlants.isNotEmpty) ...[
                    Divider(),
                    Text('Assigned Plants:', style: TextStyle(fontWeight: FontWeight.w600)),
                    ...response.data.assignedPlants.map((p) => Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 2, bottom: 2),
                      child: Row(
                        children: [
                          Icon(Icons.eco, color: Colors.green, size: 18),
                          SizedBox(width: 6),
                          Text(p.name ?? '', style: TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                    )),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pop(true); // Go back to previous screen
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check, color: Colors.green[700]),
                    SizedBox(width: 6),
                    Text('ठीक है', style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response?.message ?? 'Registration failed'),
            backgroundColor: AppColors.error,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration failed: $e'),
          backgroundColor: AppColors.error,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700])),
          ),
          Expanded(
            child: Text(value, style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

// Extension to get display text for localization
extension LocalizationExtension on AppLocalizations {
  String getDisplayText(String key) {
    switch (key) {
      case 'mango': return mango;
      case 'guava': return guava;
      case 'amla': return amla;
      case 'papaya': return papaya;
      case 'moon': return moon;
      case 'normalDelivery': return normalDelivery;
      case 'cesareanDelivery': return cesareanDelivery;
      case 'assistedDelivery': return assistedDelivery;
      case 'aPositive': return aPositive;
      case 'aNegative': return aNegative;
      case 'bPositive': return bPositive;
      case 'bNegative': return bNegative;
      case 'abPositive': return abPositive;
      case 'abNegative': return abNegative;
      case 'oPositive': return oPositive;
      case 'oNegative': return oNegative;
      default: return key;
    }
  }
}

// Helper widget for yes/no questions
