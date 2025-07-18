import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // App
      'appName': 'ग्रीन पालना योजना',
      'appTagline': 'हर जन्म के साथ हरियाली',
      
      // Welcome Screen
      'chooseYourRole': 'Choose your role',
      'selectRoleToContinue': 'Select your role to continue',
      'hospitalStaffEntry': 'Hospital Staff Entry',
      'mother': 'Mother',
      'aww': 'AWW/Mitanin',
      
      // OTP Screen
      'loginAs': 'Login as',
      'welcomeBack': 'Welcome Back!',
      'enterPhoneForOTP': 'Enter your phone number to receive OTP',
      'phoneNumber': 'Phone Number',
      'enterPhoneNumber': 'Enter 10-digit number',
      'sendOTP': 'Send OTP',
      'enterOTP': 'Enter OTP',
      'enterOTPHint': 'Enter 6-digit OTP',
      'verifyOTP': 'Verify OTP',
      'demoOTPMessage': 'For demo purposes, use OTP: 123456',
      
      // Common
      'welcome': 'Welcome',
      'logout': 'Logout',
      'close': 'Close',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'info': 'Info',
      'warning': 'Warning',
      
      // Mother Dashboard
      'myPlants': 'My Plants',
      'yourPlants': 'Your Plants',
      'takeCareMessage': 'Take care of your plants and upload photos regularly',
      'noPlantsMessage': 'Your plants will appear here once assigned by hospital staff',
      'contactHospitalStaff': 'Contact your hospital staff to get started',
      'careTip': 'Tip: Take photos of your plants every 2-3 days to track their growth!',
      'plantDetailComingSoon': 'Plant detail screen coming soon!',
      'loadingPlants': 'Loading your plants...',
      'plant': 'Plant',
      'updated': 'Updated',
      'noUploadsYet': 'No uploads yet',
      'lastUpload': 'Last',
      
      // Hospital Dashboard
      'hospitalDashboard': 'Hospital Dashboard',
      'hospitalStaff': 'Hospital Staff',
      'dashboard': 'Dashboard',
      'manageMothersMessage': 'Manage mothers and monitor plant care progress',
      'systemOverview': 'System Overview',
      'quickActions': 'Quick Actions',
      'registerNewMother': 'Register New Mother',
      'addNewMotherMessage': 'Add a new mother to the system',
      'viewAllMothers': 'View All Mothers',
      'seeAllMothersMessage': 'See all registered mothers',
      'systemStatistics': 'System Statistics',
      'viewSystemPerformance': 'View overall system performance',
      'totalMothers': 'Total Mothers',
      'activePlants': 'Active Plants',
      'photosUploaded': 'Photos Uploaded',
      'reviewsPending': 'Reviews Pending',
      'systemUptime': 'System Uptime',
      'comingSoon': 'This feature is coming soon!',
      'welcomeHospitalMessage': 'Welcome to the Hospital Dashboard. You can register new mothers and monitor their plant care progress.',
      
      // AWW Dashboard
      'awwDashboard': 'AWW Dashboard',
      'reviewUploads': 'Review Uploads',
      'reviewPendingPhotos': 'Review pending plant photos',
      'pendingReviews': 'Pending Reviews',
      'noPendingReviews': 'No pending reviews',
      'totalReviews': 'Total Reviews',
      'mothersList': 'Mothers List',
      'viewAllMothersAWW': 'View all registered mothers',
      'viewAndManageMothers': 'View and manage mothers',
      'progressReports': 'Progress Reports',
      'generateProgressReports': 'Generate progress reports',
      'exportDataAndReports': 'Export data and reports',
      'overview': 'Overview',
      'reviewPhotosMessage': 'Review plant photos regularly to provide timely feedback to mothers.',
      'mothersListMessage': 'This feature will show all registered mothers and their plant care status.',
      'progressReportsMessage': 'Generate and export progress reports for plant care monitoring.',
      
      // Validation Messages
      'enterValidPhone': 'Please enter a valid 10-digit phone number',
      'enterCompleteOTP': 'Please enter the complete OTP',
      'invalidOTP': 'Invalid OTP',
      'otpSentSuccessfully': 'OTP sent successfully',
      'failedToSendOTP': 'Failed to send OTP',
      'logoutConfirmation': 'Are you sure you want to logout?',
      
      // Mother Registration Form
      'motherRegistration': 'Mother Registration',
      'personalInformation': 'Personal Information',
      'motherName': 'Mother Name',
      'fatherHusbandName': 'Father/Husband Name',
      'mobileNumber': 'Mobile Number',
      'deliveryInformation': 'Delivery Information',
      'deliveryDate': 'Delivery Date',
      'deliveryType': 'Delivery Type',
      'bloodGroup': 'Blood Group',
      'beneficiaryAddress': 'Beneficiary Address',
      'district': 'District',
      'project': 'Project',
      'sector': 'Sector',
      'anganwadiCenter': 'Anganwadi Center',
      'plantDistributionInfo': 'Plant Distribution Information',
      'selectPlants': 'Select Plants',
      'certificateUpload': 'Certificate Upload',
      'photoUpload': 'Photo Upload',
      'submit': 'Submit',
      'save': 'Save',
      'reset': 'Reset',
      'selectDate': 'Select Date',
      'selectDeliveryType': 'Select Delivery Type',
      'selectBloodGroup': 'Select Blood Group',
      'selectDistrict': 'Select District',
      'selectProject': 'Select Project',
      'selectSector': 'Select Sector',
      'selectAnganwadi': 'Select Anganwadi Center',
      'selectPlant': 'Select Plant',
      'addPlant': 'Add Plant',
      'removePlant': 'Remove Plant',
      'uploadCertificate': 'Upload Certificate',
      'uploadPhoto': 'Upload Photo',
      'chooseFile': 'Choose File',
      'noFileSelected': 'No file selected',
      'registrationSuccess': 'Mother registered successfully!',
      'registrationFailed': 'Failed to register mother. Please try again.',
      'pleaseFillAllFields': 'Please fill all required fields',
      'invalidMobileNumber': 'Please enter a valid mobile number',
      'invalidDate': 'Please select a valid date',
      'pleaseSelectPlants': 'Please select at least one plant',
      'pleaseUploadCertificate': 'Please upload the certificate',
      'pleaseUploadPhoto': 'Please upload the photo',
      
      // Plant Types
      'mango': 'Mango',
      'guava': 'Guava',
      'amla': 'Amla',
      'papaya': 'Papaya',
      'moon': 'Moon',
      
      // Delivery Types
      'normalDelivery': 'Normal Delivery',
      'cesareanDelivery': 'Cesarean Delivery',
      'assistedDelivery': 'Assisted Delivery',
      
      // Blood Groups
      'aPositive': 'A+',
      'aNegative': 'A-',
      'bPositive': 'B+',
      'bNegative': 'B-',
      'abPositive': 'AB+',
      'abNegative': 'AB-',
      'oPositive': 'O+',
      'oNegative': 'O-',
      
      // Demo Messages
      'demoUpload': 'Demo Upload',
      'fileUploadDemo': 'File upload functionality will be implemented with proper platform configuration. For now, this is a demo simulation.',
      'demoFileSelected': 'Demo file selected: ',
      'certificateUploadHint': 'Upload birth certificate or medical documents',
      'photoUploadHint': 'Upload mother\'s photo',
      'registeredMothers': 'Registered Mothers',
      'noMothersRegistered': 'No mothers registered yet',
      'searchMothers': 'Search mothers...',
      'viewDetails': 'View Details',
      'deleteRegistration': 'Delete Registration',
      'deleteConfirmation': 'Are you sure you want to delete this registration?',
      'registrationDeleted': 'Registration deleted successfully',
      'registrationDate': 'Registration Date',
      'selectedPlants': 'Selected Plants',
      'registrationDetails': 'Registration Details',
      'plantMonitoring': 'Plant Monitoring',
      'plantDetails': 'Plant Details',
      'monitoringStatus': 'Monitoring Status',
      'addDescription': 'Add Description',
      'dueDate': 'Due Date',
      'uploadDate': 'Upload Date',
      'uploaded': 'Uploaded',
      'overdue': 'Overdue',
      'inProgress': 'In Progress',
      'completed': 'Completed',
      'firstMonth': 'First Month',
      'secondMonth': 'Second Month',
      'thirdMonth': 'Third Month',
      'firstWeek': 'First Week',
      'secondWeek': 'Second Week',
      'thirdWeek': 'Third Week',
      'fourthWeek': 'Fourth Week',
      'firstHalf': 'First Half',
      'secondHalf': 'Second Half',
      'uploadSuccess': 'Upload successful',
      'uploadFailed': 'Upload failed',
      'photoRequired': 'Photo is required',
      'descriptionOptional': 'Description (optional)',
      'saveUpload': 'Save Upload',
      'assignedDate': 'Assigned Date',
      'plantCareInstructions': 'Plant Care Instructions',
      'wateringInstructions': 'Watering Instructions',
      'fertilizerInstructions': 'Fertilizer Instructions',
      'pruningInstructions': 'Pruning Instructions',
      'pestControlInstructions': 'Pest Control Instructions',
      'cancel': 'Cancel',
      'noPlantsAssigned': 'No plants assigned',
      'pending': 'Pending',
      'overallStatistics': 'Overall Statistics',
      'mothersWithPlants': 'Mothers with Plants',
      'totalPlants': 'Total Plants',
      'completedUploads': 'Completed Uploads',
      'pendingUploads': 'Pending Uploads',
      'overdueUploads': 'Overdue Uploads',
      'noMothersFound': 'No mothers found',
      'noResultsFound': 'No results found',
      'noMothersRegisteredYet': 'No mothers registered yet',
      'noMothersForSearch': 'No mothers found for your search',
      'motherDetails': 'Mother Details',
      'plantMonitoringDetails': 'Plant Monitoring Details',
    },
    'hi': {
      // App
      'appName': 'ग्रीन पालना योजना',
      'appTagline': 'हर जन्म के साथ हरियाली',
      
      // Welcome Screen
      'chooseYourRole': 'अपनी भूमिका चुनें',
      'selectRoleToContinue': 'जारी रखने के लिए अपनी भूमिका चुनें',
      'hospitalStaffEntry': 'हॉस्पिटल स्टाफ एंट्री',
      'mother': 'माता',
      'aww': 'मितानिन',
      
      // OTP Screen
      'loginAs': 'लॉगिन करें',
      'welcomeBack': 'वापसी पर स्वागत है!',
      'enterPhoneForOTP': 'OTP प्राप्त करने के लिए अपना फोन नंबर दर्ज करें',
      'phoneNumber': 'फोन नंबर',
      'enterPhoneNumber': '10 अंकों का नंबर दर्ज करें',
      'sendOTP': 'OTP भेजें',
      'enterOTP': 'OTP दर्ज करें',
      'enterOTPHint': '6 अंकों का OTP दर्ज करें',
      'verifyOTP': 'OTP सत्यापित करें',
      'demoOTPMessage': 'डेमो के लिए, OTP का उपयोग करें: 123456',
      
      // Common
      'welcome': 'स्वागत है',
      'logout': 'लॉगआउट',
      'close': 'बंद करें',
      'loading': 'लोड हो रहा है...',
      'error': 'त्रुटि',
      'success': 'सफलता',
      'info': 'जानकारी',
      'warning': 'चेतावनी',
      
      // Mother Dashboard
      'myPlants': 'मेरे पौधे',
      'yourPlants': 'आपके पौधे',
      'takeCareMessage': 'अपने पौधों की देखभाल करें और नियमित रूप से फोटो अपलोड करें',
      'noPlantsMessage': 'हॉस्पिटल स्टाफ द्वारा सौंपे जाने के बाद आपके पौधे यहां दिखाई देंगे',
      'contactHospitalStaff': 'शुरू करने के लिए अपने हॉस्पिटल स्टाफ से संपर्क करें',
      'careTip': 'सुझाव: अपने पौधों के विकास को ट्रैक करने के लिए हर 2-3 दिन में फोटो लें!',
      'plantDetailComingSoon': 'पौधा विवरण स्क्रीन जल्द आ रहा है!',
      'loadingPlants': 'आपके पौधे लोड हो रहे हैं...',
      'plant': 'पौधा',
      'updated': 'अपडेटेड',
      'noUploadsYet': 'अभी तक कोई अपलोड नहीं',
      'lastUpload': 'अंतिम',
      
      // Hospital Dashboard
      'hospitalDashboard': 'हॉस्पिटल डैशबोर्ड',
      'hospitalStaff': 'हॉस्पिटल स्टाफ',
      'dashboard': 'डैशबोर्ड',
      'manageMothersMessage': 'माताओं का प्रबंधन करें और पौधों के प्रगति की निगरानी करें',
      'systemOverview': 'सिस्टम अवलोकन',
      'quickActions': 'त्वरित कार्य',
      'registerNewMother': 'नई हितग्राही/माता पंजीकृत करें',
      'addNewMotherMessage': 'सिस्टम में एक नई माता जोड़ें',
      'viewAllMothers': 'सभी माताएं देखें',
      'seeAllMothersMessage': 'सभी पंजीकृत माताएं देखें',
      'systemStatistics': 'सिस्टम आंकड़े',
      'viewSystemPerformance': 'समग्र सिस्टम प्रदर्शन देखें',
      'totalMothers': 'कुल माताएं',
      'activePlants': 'सक्रिय पौधे',
      'photosUploaded': 'अपलोड किए गए फोटो',
      'reviewsPending': 'लंबित समीक्षाएं',
      'systemUptime': 'सिस्टम अपटाइम',
      'comingSoon': 'यह सुविधा जल्द आ रही है!',
      'welcomeHospitalMessage': 'हॉस्पिटल डैशबोर्ड में आपका स्वागत है। आप नई माताओं को पंजीकृत कर सकते हैं और पौधों के प्रगति की निगरानी कर सकते हैं।',
      
      // AWW Dashboard
      'awwDashboard': 'आंगनवाड़ी डैशबोर्ड',
      'reviewUploads': 'अपलोड की समीक्षा करें',
      'reviewPendingPhotos': 'लंबित पौधा फोटो की समीक्षा करें',
      'pendingReviews': 'लंबित समीक्षाएं',
      'noPendingReviews': 'कोई लंबित समीक्षा नहीं',
      'totalReviews': 'कुल समीक्षाएं',
      'mothersList': 'माताओं की सूची',
      'viewAllMothersAWW': 'सभी पंजीकृत माताएं देखें',
      'viewAndManageMothers': 'माताओं को देखें और प्रबंधित करें',
      'progressReports': 'प्रगति रिपोर्ट',
      'generateProgressReports': 'प्रगति रिपोर्ट तैयार करें',
      'exportDataAndReports': 'डेटा और रिपोर्ट निर्यात करें',
      'overview': 'अवलोकन',
      'reviewPhotosMessage': 'माताओं को समय पर प्रतिक्रिया देने के लिए नियमित रूप से पौधा की समीक्षा करें।',
      'mothersListMessage': 'यह सुविधा सभी पंजीकृत माताओं और उनके पौधों की स्थिति दिखाएगी।',
      'progressReportsMessage': 'पौधा देखभाल निगरानी के लिए प्रगति रिपोर्ट तैयार और निर्यात करें।',
      
      // Validation Messages
      'enterValidPhone': 'कृपया एक वैध 10-अंकीय फोन नंबर दर्ज करें',
      'enterCompleteOTP': 'कृपया पूरा OTP दर्ज करें',
      'invalidOTP': 'अमान्य OTP',
      'otpSentSuccessfully': 'OTP सफलतापूर्वक भेजा गया',
      'failedToSendOTP': 'OTP भेजने में विफल',
      'logoutConfirmation': 'क्या आप वाकई लॉगआउट करना चाहते हैं?',
      
      // Mother Registration Form
      'motherRegistration': 'माता पंजीकरण',
      'personalInformation': 'व्यक्तिगत जानकारी',
      'motherName': 'माता का नाम',
      'fatherHusbandName': 'पिता/पति का नाम',
      'mobileNumber': 'मोबाइल नंबर',
      'deliveryInformation': 'प्रसव की जानकारी',
      'deliveryDate': 'प्रसव दिनांक',
      'deliveryType': 'प्रसव का प्रकार',
      'bloodGroup': 'ब्लड ग्रुप',
      'beneficiaryAddress': 'हितग्राही का पता',
      'district': 'ज़िला',
      'project': 'परियोजना',
      'sector': 'सेक्टर',
      'anganwadiCenter': 'आंगनबाड़ी केंद्र',
      'plantDistributionInfo': 'पौधों के वितरण की जानकारी',
      'selectPlants': 'पौधे चुनें',
      'certificateUpload': 'शपथ पत्र अपलोड',
      'photoUpload': 'फोटो अपलोड',
      'submit': 'जमा करें',
      'save': 'सहेजें',
      'reset': 'रीसेट',
      'selectDate': 'दिनांक चुनें',
      'selectDeliveryType': 'प्रसव का प्रकार चुनें',
      'selectBloodGroup': 'ब्लड ग्रुप चुनें',
      'selectDistrict': 'ज़िला चुनें',
      'selectProject': 'परियोजना चुनें',
      'selectSector': 'सेक्टर चुनें',
      'selectAnganwadi': 'आंगनबाड़ी केंद्र चुनें',
      'selectPlant': 'पौधा चुनें',
      'addPlant': 'पौधा जोड़ें',
      'removePlant': 'पौधा हटाएं',
      'uploadCertificate': 'प्रमाण पत्र अपलोड करें',
      'uploadPhoto': 'फोटो अपलोड करें',
      'chooseFile': 'फ़ाइल चुनें',
      'noFileSelected': 'कोई फ़ाइल नहीं चुनी गई',
      'registrationSuccess': 'माता सफलतापूर्वक पंजीकृत की गई!',
      'registrationFailed': 'माता को पंजीकृत करने में विफल। कृपया पुनः प्रयास करें।',
      'pleaseFillAllFields': 'कृपया सभी आवश्यक फ़ील्ड भरें',
      'invalidMobileNumber': 'कृपया एक वैध मोबाइल नंबर दर्ज करें',
      'invalidDate': 'कृपया एक वैध दिनांक चुनें',
      'pleaseSelectPlants': 'कृपया कम से कम एक पौधा चुनें',
      'pleaseUploadCertificate': 'कृपया प्रमाण पत्र अपलोड करें',
      'pleaseUploadPhoto': 'कृपया फोटो अपलोड करें',
      
      // Plant Types
      'mango': 'आम',
      'guava': 'अमरुद',
      'amla': 'आंवला',
      'papaya': 'पपीता',
      'moon': 'मुनगा',
      
      // Delivery Types
      'normalDelivery': 'सामान्य प्रसव',
      'cesareanDelivery': 'सिजेरियन प्रसव',
      'assistedDelivery': 'सहायक प्रसव',
      
      // Blood Groups
      'aPositive': 'ए+',
      'aNegative': 'ए-',
      'bPositive': 'बी+',
      'bNegative': 'बी-',
      'abPositive': 'एबी+',
      'abNegative': 'एबी-',
      'oPositive': 'ओ+',
      'oNegative': 'ओ-',
      
      // Demo Messages
      'demoUpload': 'डेमो अपलोड',
      'fileUploadDemo': 'फ़ाइल अपलोड कार्यक्षमता उचित प्लेटफ़ॉर्म कॉन्फ़िगरेशन के साथ लागू की जाएगी। अभी के लिए, यह एक डेमो सिमुलेशन है।',
      'demoFileSelected': 'डेमो फ़ाइल चुनी गई: ',
      'certificateUploadHint': 'शपथ पत्र दस्तावेज़ अपलोड करें',
      'photoUploadHint': 'हितग्राही को पौधा वितरित करते हुए फोटो खींचें।',
      'registeredMothers': 'पंजीकृत माताएं',
      'noMothersRegistered': 'अभी तक कोई माता पंजीकृत नहीं',
      'searchMothers': 'माताओं को खोजें...',
      'viewDetails': 'विवरण देखें',
      'deleteRegistration': 'पंजीकरण हटाएं',
      'deleteConfirmation': 'क्या आप वाकई इस पंजीकरण को हटाना चाहते हैं?',
      'registrationDeleted': 'पंजीकरण सफलतापूर्वक हटा दिया गया',
      'registrationDate': 'पंजीकरण दिनांक',
      'selectedPlants': 'चयनित पौधे',
      'registrationDetails': 'पंजीकरण विवरण',
      'plantMonitoring': 'पौधा निगरानी',
      'plantDetails': 'पौधा विवरण',
      'monitoringStatus': 'निगरानी स्थिति',
      'addDescription': 'विवरण जोड़ें',
      'dueDate': 'नियत तारीख',
      'uploadDate': 'अपलोड तारीख',
      'uploaded': 'अपलोड किया गया',
      'overdue': 'समय से अधिक',
      'inProgress': 'प्रगति में',
      'completed': 'पूर्ण',
      'firstMonth': 'पहला महीना',
      'secondMonth': 'दूसरा महीना',
      'thirdMonth': 'तीसरा महीना',
      'firstWeek': 'पहला सप्ताह',
      'secondWeek': 'दूसरा सप्ताह',
      'thirdWeek': 'तीसरा सप्ताह',
      'fourthWeek': 'चौथा सप्ताह',
      'firstHalf': 'पहला पखवाड़ा',
      'secondHalf': 'दूसरा पखवाड़ा',
      'uploadSuccess': 'अपलोड सफल',
      'uploadFailed': 'अपलोड विफल',
      'photoRequired': 'फोटो आवश्यक है',
      'descriptionOptional': 'विवरण (वैकल्पिक)',
      'saveUpload': 'अपलोड सहेजें',
      'assignedDate': 'सौंपी गई तारीख',
      'plantCareInstructions': 'पौधा देखभाल निर्देश',
      'wateringInstructions': 'पानी देने के निर्देश',
      'fertilizerInstructions': 'खाद देने के निर्देश',
      'pruningInstructions': 'छंटाई के निर्देश',
      'pestControlInstructions': 'कीट नियंत्रण निर्देश',
      'cancel': 'रद्द करें',
      'noPlantsAssigned': 'कोई पौधे नहीं सौंपे गए',
      'pending': 'लंबित',
      'overallStatistics': 'समग्र सांख्यिकी',
      'mothersWithPlants': 'पौधे वाली माताएं',
      'totalPlants': 'कुल पौधे',
      'completedUploads': 'पूर्ण अपलोड',
      'pendingUploads': 'लंबित अपलोड',
      'overdueUploads': 'समय से अधिक अपलोड',
      'noMothersFound': 'कोई माता नहीं मिली',
      'noResultsFound': 'कोई परिणाम नहीं मिला',
      'noMothersRegisteredYet': 'अभी तक कोई माता पंजीकृत नहीं की गई है',
      'noMothersForSearch': 'आपके खोज के अनुसार कोई माता नहीं मिली',
      'motherDetails': 'माता का विवरण',
      'plantMonitoringDetails': 'पौधा निगरानी विवरण',
    },
  };

  String get appName => _localizedValues[locale.languageCode]?['appName'] ?? _localizedValues['en']!['appName']!;
  String get appTagline => _localizedValues[locale.languageCode]?['appTagline'] ?? _localizedValues['en']!['appTagline']!;
  String get chooseYourRole => _localizedValues[locale.languageCode]?['chooseYourRole'] ?? _localizedValues['en']!['chooseYourRole']!;
  String get selectRoleToContinue => _localizedValues[locale.languageCode]?['selectRoleToContinue'] ?? _localizedValues['en']!['selectRoleToContinue']!;
  String get hospitalStaffEntry => _localizedValues[locale.languageCode]?['hospitalStaffEntry'] ?? _localizedValues['en']!['hospitalStaffEntry']!;
  String get mother => _localizedValues[locale.languageCode]?['mother'] ?? _localizedValues['en']!['mother']!;
  String get aww => _localizedValues[locale.languageCode]?['aww'] ?? _localizedValues['en']!['aww']!;
  String get loginAs => _localizedValues[locale.languageCode]?['loginAs'] ?? _localizedValues['en']!['loginAs']!;
  String get welcomeBack => _localizedValues[locale.languageCode]?['welcomeBack'] ?? _localizedValues['en']!['welcomeBack']!;
  String get enterPhoneForOTP => _localizedValues[locale.languageCode]?['enterPhoneForOTP'] ?? _localizedValues['en']!['enterPhoneForOTP']!;
  String get phoneNumber => _localizedValues[locale.languageCode]?['phoneNumber'] ?? _localizedValues['en']!['phoneNumber']!;
  String get enterPhoneNumber => _localizedValues[locale.languageCode]?['enterPhoneNumber'] ?? _localizedValues['en']!['enterPhoneNumber']!;
  String get sendOTP => _localizedValues[locale.languageCode]?['sendOTP'] ?? _localizedValues['en']!['sendOTP']!;
  String get enterOTP => _localizedValues[locale.languageCode]?['enterOTP'] ?? _localizedValues['en']!['enterOTP']!;
  String get enterOTPHint => _localizedValues[locale.languageCode]?['enterOTPHint'] ?? _localizedValues['en']!['enterOTPHint']!;
  String get verifyOTP => _localizedValues[locale.languageCode]?['verifyOTP'] ?? _localizedValues['en']!['verifyOTP']!;
  String get demoOTPMessage => _localizedValues[locale.languageCode]?['demoOTPMessage'] ?? _localizedValues['en']!['demoOTPMessage']!;
  String get welcome => _localizedValues[locale.languageCode]?['welcome'] ?? _localizedValues['en']!['welcome']!;
  String get logout => _localizedValues[locale.languageCode]?['logout'] ?? _localizedValues['en']!['logout']!;
  String get close => _localizedValues[locale.languageCode]?['close'] ?? _localizedValues['en']!['close']!;
  String get loading => _localizedValues[locale.languageCode]?['loading'] ?? _localizedValues['en']!['loading']!;
  String get error => _localizedValues[locale.languageCode]?['error'] ?? _localizedValues['en']!['error']!;
  String get success => _localizedValues[locale.languageCode]?['success'] ?? _localizedValues['en']!['success']!;
  String get info => _localizedValues[locale.languageCode]?['info'] ?? _localizedValues['en']!['info']!;
  String get warning => _localizedValues[locale.languageCode]?['warning'] ?? _localizedValues['en']!['warning']!;
  String get myPlants => _localizedValues[locale.languageCode]?['myPlants'] ?? _localizedValues['en']!['myPlants']!;
  String get yourPlants => _localizedValues[locale.languageCode]?['yourPlants'] ?? _localizedValues['en']!['yourPlants']!;
  String get takeCareMessage => _localizedValues[locale.languageCode]?['takeCareMessage'] ?? _localizedValues['en']!['takeCareMessage']!;
  String get noPlantsMessage => _localizedValues[locale.languageCode]?['noPlantsMessage'] ?? _localizedValues['en']!['noPlantsMessage']!;
  String get contactHospitalStaff => _localizedValues[locale.languageCode]?['contactHospitalStaff'] ?? _localizedValues['en']!['contactHospitalStaff']!;
  String get careTip => _localizedValues[locale.languageCode]?['careTip'] ?? _localizedValues['en']!['careTip']!;
  String get plantDetailComingSoon => _localizedValues[locale.languageCode]?['plantDetailComingSoon'] ?? _localizedValues['en']!['plantDetailComingSoon']!;
  String get loadingPlants => _localizedValues[locale.languageCode]?['loadingPlants'] ?? _localizedValues['en']!['loadingPlants']!;
  String get plant => _localizedValues[locale.languageCode]?['plant'] ?? _localizedValues['en']!['plant']!;
  String get updated => _localizedValues[locale.languageCode]?['updated'] ?? _localizedValues['en']!['updated']!;
  String get noUploadsYet => _localizedValues[locale.languageCode]?['noUploadsYet'] ?? _localizedValues['en']!['noUploadsYet']!;
  String get lastUpload => _localizedValues[locale.languageCode]?['lastUpload'] ?? _localizedValues['en']!['lastUpload']!;
  String get hospitalDashboard => _localizedValues[locale.languageCode]?['hospitalDashboard'] ?? _localizedValues['en']!['hospitalDashboard']!;
  String get hospitalStaff => _localizedValues[locale.languageCode]?['hospitalStaff'] ?? _localizedValues['en']!['hospitalStaff']!;
  String get dashboard => _localizedValues[locale.languageCode]?['dashboard'] ?? _localizedValues['en']!['dashboard']!;
  String get manageMothersMessage => _localizedValues[locale.languageCode]?['manageMothersMessage'] ?? _localizedValues['en']!['manageMothersMessage']!;
  String get systemOverview => _localizedValues[locale.languageCode]?['systemOverview'] ?? _localizedValues['en']!['systemOverview']!;
  String get quickActions => _localizedValues[locale.languageCode]?['quickActions'] ?? _localizedValues['en']!['quickActions']!;
  String get registerNewMother => _localizedValues[locale.languageCode]?['registerNewMother'] ?? _localizedValues['en']!['registerNewMother']!;
  String get addNewMotherMessage => _localizedValues[locale.languageCode]?['addNewMotherMessage'] ?? _localizedValues['en']!['addNewMotherMessage']!;
  String get viewAllMothers => _localizedValues[locale.languageCode]?['viewAllMothers'] ?? _localizedValues['en']!['viewAllMothers']!;
  String get seeAllMothersMessage => _localizedValues[locale.languageCode]?['seeAllMothersMessage'] ?? _localizedValues['en']!['seeAllMothersMessage']!;
  String get systemStatistics => _localizedValues[locale.languageCode]?['systemStatistics'] ?? _localizedValues['en']!['systemStatistics']!;
  String get viewSystemPerformance => _localizedValues[locale.languageCode]?['viewSystemPerformance'] ?? _localizedValues['en']!['viewSystemPerformance']!;
  String get totalMothers => _localizedValues[locale.languageCode]?['totalMothers'] ?? _localizedValues['en']!['totalMothers']!;
  String get activePlants => _localizedValues[locale.languageCode]?['activePlants'] ?? _localizedValues['en']!['activePlants']!;
  String get photosUploaded => _localizedValues[locale.languageCode]?['photosUploaded'] ?? _localizedValues['en']!['photosUploaded']!;
  String get reviewsPending => _localizedValues[locale.languageCode]?['reviewsPending'] ?? _localizedValues['en']!['reviewsPending']!;
  String get systemUptime => _localizedValues[locale.languageCode]?['systemUptime'] ?? _localizedValues['en']!['systemUptime']!;
  String get comingSoon => _localizedValues[locale.languageCode]?['comingSoon'] ?? _localizedValues['en']!['comingSoon']!;
  String get welcomeHospitalMessage => _localizedValues[locale.languageCode]?['welcomeHospitalMessage'] ?? _localizedValues['en']!['welcomeHospitalMessage']!;
  String get awwDashboard => _localizedValues[locale.languageCode]?['awwDashboard'] ?? _localizedValues['en']!['awwDashboard']!;
  String get reviewUploads => _localizedValues[locale.languageCode]?['reviewUploads'] ?? _localizedValues['en']!['reviewUploads']!;
  String get reviewPendingPhotos => _localizedValues[locale.languageCode]?['reviewPendingPhotos'] ?? _localizedValues['en']!['reviewPendingPhotos']!;
  String get pendingReviews => _localizedValues[locale.languageCode]?['pendingReviews'] ?? _localizedValues['en']!['pendingReviews']!;
  String get noPendingReviews => _localizedValues[locale.languageCode]?['noPendingReviews'] ?? _localizedValues['en']!['noPendingReviews']!;
  String get totalReviews => _localizedValues[locale.languageCode]?['totalReviews'] ?? _localizedValues['en']!['totalReviews']!;
  String get mothersList => _localizedValues[locale.languageCode]?['mothersList'] ?? _localizedValues['en']!['mothersList']!;
  String get viewAllMothersAWW => _localizedValues[locale.languageCode]?['viewAllMothersAWW'] ?? _localizedValues['en']!['viewAllMothersAWW']!;
  String get viewAndManageMothers => _localizedValues[locale.languageCode]?['viewAndManageMothers'] ?? _localizedValues['en']!['viewAndManageMothers']!;
  String get progressReports => _localizedValues[locale.languageCode]?['progressReports'] ?? _localizedValues['en']!['progressReports']!;
  String get generateProgressReports => _localizedValues[locale.languageCode]?['generateProgressReports'] ?? _localizedValues['en']!['generateProgressReports']!;
  String get exportDataAndReports => _localizedValues[locale.languageCode]?['exportDataAndReports'] ?? _localizedValues['en']!['exportDataAndReports']!;
  String get overview => _localizedValues[locale.languageCode]?['overview'] ?? _localizedValues['en']!['overview']!;
  String get reviewPhotosMessage => _localizedValues[locale.languageCode]?['reviewPhotosMessage'] ?? _localizedValues['en']!['reviewPhotosMessage']!;
  String get mothersListMessage => _localizedValues[locale.languageCode]?['mothersListMessage'] ?? _localizedValues['en']!['mothersListMessage']!;
  String get progressReportsMessage => _localizedValues[locale.languageCode]?['progressReportsMessage'] ?? _localizedValues['en']!['progressReportsMessage']!;
  String get enterValidPhone => _localizedValues[locale.languageCode]?['enterValidPhone'] ?? _localizedValues['en']!['enterValidPhone']!;
  String get enterCompleteOTP => _localizedValues[locale.languageCode]?['enterCompleteOTP'] ?? _localizedValues['en']!['enterCompleteOTP']!;
  String get invalidOTP => _localizedValues[locale.languageCode]?['invalidOTP'] ?? _localizedValues['en']!['invalidOTP']!;
  String get otpSentSuccessfully => _localizedValues[locale.languageCode]?['otpSentSuccessfully'] ?? _localizedValues['en']!['otpSentSuccessfully']!;
  String get failedToSendOTP => _localizedValues[locale.languageCode]?['failedToSendOTP'] ?? _localizedValues['en']!['failedToSendOTP']!;
  String get logoutConfirmation => _localizedValues[locale.languageCode]?['logoutConfirmation'] ?? _localizedValues['en']!['logoutConfirmation']!;
  String get motherRegistration => _localizedValues[locale.languageCode]?['motherRegistration'] ?? _localizedValues['en']!['motherRegistration']!;
  String get personalInformation => _localizedValues[locale.languageCode]?['personalInformation'] ?? _localizedValues['en']!['personalInformation']!;
  String get motherName => _localizedValues[locale.languageCode]?['motherName'] ?? _localizedValues['en']!['motherName']!;
  String get fatherHusbandName => _localizedValues[locale.languageCode]?['fatherHusbandName'] ?? _localizedValues['en']!['fatherHusbandName']!;
  String get mobileNumber => _localizedValues[locale.languageCode]?['mobileNumber'] ?? _localizedValues['en']!['mobileNumber']!;
  String get deliveryInformation => _localizedValues[locale.languageCode]?['deliveryInformation'] ?? _localizedValues['en']!['deliveryInformation']!;
  String get deliveryDate => _localizedValues[locale.languageCode]?['deliveryDate'] ?? _localizedValues['en']!['deliveryDate']!;
  String get deliveryType => _localizedValues[locale.languageCode]?['deliveryType'] ?? _localizedValues['en']!['deliveryType']!;
  String get bloodGroup => _localizedValues[locale.languageCode]?['bloodGroup'] ?? _localizedValues['en']!['bloodGroup']!;
  String get beneficiaryAddress => _localizedValues[locale.languageCode]?['beneficiaryAddress'] ?? _localizedValues['en']!['beneficiaryAddress']!;
  String get district => _localizedValues[locale.languageCode]?['district'] ?? _localizedValues['en']!['district']!;
  String get project => _localizedValues[locale.languageCode]?['project'] ?? _localizedValues['en']!['project']!;
  String get sector => _localizedValues[locale.languageCode]?['sector'] ?? _localizedValues['en']!['sector']!;
  String get anganwadiCenter => _localizedValues[locale.languageCode]?['anganwadiCenter'] ?? _localizedValues['en']!['anganwadiCenter']!;
  String get plantDistributionInfo => _localizedValues[locale.languageCode]?['plantDistributionInfo'] ?? _localizedValues['en']!['plantDistributionInfo']!;
  String get selectPlants => _localizedValues[locale.languageCode]?['selectPlants'] ?? _localizedValues['en']!['selectPlants']!;
  String get certificateUpload => _localizedValues[locale.languageCode]?['certificateUpload'] ?? _localizedValues['en']!['certificateUpload']!;
  String get photoUpload => _localizedValues[locale.languageCode]?['photoUpload'] ?? _localizedValues['en']!['photoUpload']!;
  String get submit => _localizedValues[locale.languageCode]?['submit'] ?? _localizedValues['en']!['submit']!;
  String get save => _localizedValues[locale.languageCode]?['save'] ?? _localizedValues['en']!['save']!;
  String get reset => _localizedValues[locale.languageCode]?['reset'] ?? _localizedValues['en']!['reset']!;
  String get selectDate => _localizedValues[locale.languageCode]?['selectDate'] ?? _localizedValues['en']!['selectDate']!;
  String get selectDeliveryType => _localizedValues[locale.languageCode]?['selectDeliveryType'] ?? _localizedValues['en']!['selectDeliveryType']!;
  String get selectBloodGroup => _localizedValues[locale.languageCode]?['selectBloodGroup'] ?? _localizedValues['en']!['selectBloodGroup']!;
  String get selectDistrict => _localizedValues[locale.languageCode]?['selectDistrict'] ?? _localizedValues['en']!['selectDistrict']!;
  String get selectProject => _localizedValues[locale.languageCode]?['selectProject'] ?? _localizedValues['en']!['selectProject']!;
  String get selectSector => _localizedValues[locale.languageCode]?['selectSector'] ?? _localizedValues['en']!['selectSector']!;
  String get selectAnganwadi => _localizedValues[locale.languageCode]?['selectAnganwadi'] ?? _localizedValues['en']!['selectAnganwadi']!;
  String get selectPlant => _localizedValues[locale.languageCode]?['selectPlant'] ?? _localizedValues['en']!['selectPlant']!;
  String get addPlant => _localizedValues[locale.languageCode]?['addPlant'] ?? _localizedValues['en']!['addPlant']!;
  String get removePlant => _localizedValues[locale.languageCode]?['removePlant'] ?? _localizedValues['en']!['removePlant']!;
  String get uploadCertificate => _localizedValues[locale.languageCode]?['uploadCertificate'] ?? _localizedValues['en']!['uploadCertificate']!;
  String get uploadPhoto => _localizedValues[locale.languageCode]?['uploadPhoto'] ?? _localizedValues['en']!['uploadPhoto']!;
  String get chooseFile => _localizedValues[locale.languageCode]?['chooseFile'] ?? _localizedValues['en']!['chooseFile']!;
  String get noFileSelected => _localizedValues[locale.languageCode]?['noFileSelected'] ?? _localizedValues['en']!['noFileSelected']!;
  String get registrationSuccess => _localizedValues[locale.languageCode]?['registrationSuccess'] ?? _localizedValues['en']!['registrationSuccess']!;
  String get registrationFailed => _localizedValues[locale.languageCode]?['registrationFailed'] ?? _localizedValues['en']!['registrationFailed']!;
  String get pleaseFillAllFields => _localizedValues[locale.languageCode]?['pleaseFillAllFields'] ?? _localizedValues['en']!['pleaseFillAllFields']!;
  String get invalidMobileNumber => _localizedValues[locale.languageCode]?['invalidMobileNumber'] ?? _localizedValues['en']!['invalidMobileNumber']!;
  String get invalidDate => _localizedValues[locale.languageCode]?['invalidDate'] ?? _localizedValues['en']!['invalidDate']!;
  String get pleaseSelectPlants => _localizedValues[locale.languageCode]?['pleaseSelectPlants'] ?? _localizedValues['en']!['pleaseSelectPlants']!;
  String get pleaseUploadCertificate => _localizedValues[locale.languageCode]?['pleaseUploadCertificate'] ?? _localizedValues['en']!['pleaseUploadCertificate']!;
  String get pleaseUploadPhoto => _localizedValues[locale.languageCode]?['pleaseUploadPhoto'] ?? _localizedValues['en']!['pleaseUploadPhoto']!;
  String get mango => _localizedValues[locale.languageCode]?['mango'] ?? _localizedValues['en']!['mango']!;
  String get guava => _localizedValues[locale.languageCode]?['guava'] ?? _localizedValues['en']!['guava']!;
  String get amla => _localizedValues[locale.languageCode]?['amla'] ?? _localizedValues['en']!['amla']!;
  String get papaya => _localizedValues[locale.languageCode]?['papaya'] ?? _localizedValues['en']!['papaya']!;
  String get moon => _localizedValues[locale.languageCode]?['moon'] ?? _localizedValues['en']!['moon']!;
  String get normalDelivery => _localizedValues[locale.languageCode]?['normalDelivery'] ?? _localizedValues['en']!['normalDelivery']!;
  String get cesareanDelivery => _localizedValues[locale.languageCode]?['cesareanDelivery'] ?? _localizedValues['en']!['cesareanDelivery']!;
  String get assistedDelivery => _localizedValues[locale.languageCode]?['assistedDelivery'] ?? _localizedValues['en']!['assistedDelivery']!;
  String get aPositive => _localizedValues[locale.languageCode]?['aPositive'] ?? _localizedValues['en']!['aPositive']!;
  String get aNegative => _localizedValues[locale.languageCode]?['aNegative'] ?? _localizedValues['en']!['aNegative']!;
  String get bPositive => _localizedValues[locale.languageCode]?['bPositive'] ?? _localizedValues['en']!['bPositive']!;
  String get bNegative => _localizedValues[locale.languageCode]?['bNegative'] ?? _localizedValues['en']!['bNegative']!;
  String get abPositive => _localizedValues[locale.languageCode]?['abPositive'] ?? _localizedValues['en']!['abPositive']!;
  String get abNegative => _localizedValues[locale.languageCode]?['abNegative'] ?? _localizedValues['en']!['abNegative']!;
  String get oPositive => _localizedValues[locale.languageCode]?['oPositive'] ?? _localizedValues['en']!['oPositive']!;
  String get oNegative => _localizedValues[locale.languageCode]?['oNegative'] ?? _localizedValues['en']!['oNegative']!;
  String get demoUpload => _localizedValues[locale.languageCode]?['demoUpload'] ?? _localizedValues['en']!['demoUpload']!;
  String get fileUploadDemo => _localizedValues[locale.languageCode]?['fileUploadDemo'] ?? _localizedValues['en']!['fileUploadDemo']!;
  String get demoFileSelected => _localizedValues[locale.languageCode]?['demoFileSelected'] ?? _localizedValues['en']!['demoFileSelected']!;
  String get certificateUploadHint => _localizedValues[locale.languageCode]?['certificateUploadHint'] ?? _localizedValues['en']!['certificateUploadHint']!;
  String get photoUploadHint => _localizedValues[locale.languageCode]?['photoUploadHint'] ?? _localizedValues['en']!['photoUploadHint']!;
  String get registeredMothers => _localizedValues[locale.languageCode]?['registeredMothers'] ?? _localizedValues['en']!['registeredMothers']!;
  String get noMothersRegistered => _localizedValues[locale.languageCode]?['noMothersRegistered'] ?? _localizedValues['en']!['noMothersRegistered']!;
  String get searchMothers => _localizedValues[locale.languageCode]?['searchMothers'] ?? _localizedValues['en']!['searchMothers']!;
  String get viewDetails => _localizedValues[locale.languageCode]?['viewDetails'] ?? _localizedValues['en']!['viewDetails']!;
  String get deleteRegistration => _localizedValues[locale.languageCode]?['deleteRegistration'] ?? _localizedValues['en']!['deleteRegistration']!;
  String get deleteConfirmation => _localizedValues[locale.languageCode]?['deleteConfirmation'] ?? _localizedValues['en']!['deleteConfirmation']!;
  String get registrationDeleted => _localizedValues[locale.languageCode]?['registrationDeleted'] ?? _localizedValues['en']!['registrationDeleted']!;
  String get registrationDate => _localizedValues[locale.languageCode]?['registrationDate'] ?? _localizedValues['en']!['registrationDate']!;
  String get selectedPlants => _localizedValues[locale.languageCode]?['selectedPlants'] ?? _localizedValues['en']!['selectedPlants']!;
  String get registrationDetails => _localizedValues[locale.languageCode]?['registrationDetails'] ?? _localizedValues['en']!['registrationDetails']!;
  String get plantMonitoring => _localizedValues[locale.languageCode]?['plantMonitoring'] ?? _localizedValues['en']!['plantMonitoring']!;
  String get plantDetails => _localizedValues[locale.languageCode]?['plantDetails'] ?? _localizedValues['en']!['plantDetails']!;
  String get monitoringStatus => _localizedValues[locale.languageCode]?['monitoringStatus'] ?? _localizedValues['en']!['monitoringStatus']!;
  String get addDescription => _localizedValues[locale.languageCode]?['addDescription'] ?? _localizedValues['en']!['addDescription']!;
  String get dueDate => _localizedValues[locale.languageCode]?['dueDate'] ?? _localizedValues['en']!['dueDate']!;
  String get uploadDate => _localizedValues[locale.languageCode]?['uploadDate'] ?? _localizedValues['en']!['uploadDate']!;
  String get uploaded => _localizedValues[locale.languageCode]?['uploaded'] ?? _localizedValues['en']!['uploaded']!;
  String get overdue => _localizedValues[locale.languageCode]?['overdue'] ?? _localizedValues['en']!['overdue']!;
  String get inProgress => _localizedValues[locale.languageCode]?['inProgress'] ?? _localizedValues['en']!['inProgress']!;
  String get completed => _localizedValues[locale.languageCode]?['completed'] ?? _localizedValues['en']!['completed']!;
  String get firstMonth => _localizedValues[locale.languageCode]?['firstMonth'] ?? _localizedValues['en']!['firstMonth']!;
  String get secondMonth => _localizedValues[locale.languageCode]?['secondMonth'] ?? _localizedValues['en']!['secondMonth']!;
  String get thirdMonth => _localizedValues[locale.languageCode]?['thirdMonth'] ?? _localizedValues['en']!['thirdMonth']!;
  String get firstWeek => _localizedValues[locale.languageCode]?['firstWeek'] ?? _localizedValues['en']!['firstWeek']!;
  String get secondWeek => _localizedValues[locale.languageCode]?['secondWeek'] ?? _localizedValues['en']!['secondWeek']!;
  String get thirdWeek => _localizedValues[locale.languageCode]?['thirdWeek'] ?? _localizedValues['en']!['thirdWeek']!;
  String get fourthWeek => _localizedValues[locale.languageCode]?['fourthWeek'] ?? _localizedValues['en']!['fourthWeek']!;
  String get firstHalf => _localizedValues[locale.languageCode]?['firstHalf'] ?? _localizedValues['en']!['firstHalf']!;
  String get secondHalf => _localizedValues[locale.languageCode]?['secondHalf'] ?? _localizedValues['en']!['secondHalf']!;
  String get uploadSuccess => _localizedValues[locale.languageCode]?['uploadSuccess'] ?? _localizedValues['en']!['uploadSuccess']!;
  String get uploadFailed => _localizedValues[locale.languageCode]?['uploadFailed'] ?? _localizedValues['en']!['uploadFailed']!;
  String get photoRequired => _localizedValues[locale.languageCode]?['photoRequired'] ?? _localizedValues['en']!['photoRequired']!;
  String get descriptionOptional => _localizedValues[locale.languageCode]?['descriptionOptional'] ?? _localizedValues['en']!['descriptionOptional']!;
  String get saveUpload => _localizedValues[locale.languageCode]?['saveUpload'] ?? _localizedValues['en']!['saveUpload']!;
  String get assignedDate => _localizedValues[locale.languageCode]?['assignedDate'] ?? _localizedValues['en']!['assignedDate']!;
  String get plantCareInstructions => _localizedValues[locale.languageCode]?['plantCareInstructions'] ?? _localizedValues['en']!['plantCareInstructions']!;
  String get wateringInstructions => _localizedValues[locale.languageCode]?['wateringInstructions'] ?? _localizedValues['en']!['wateringInstructions']!;
  String get fertilizerInstructions => _localizedValues[locale.languageCode]?['fertilizerInstructions'] ?? _localizedValues['en']!['fertilizerInstructions']!;
  String get pruningInstructions => _localizedValues[locale.languageCode]?['pruningInstructions'] ?? _localizedValues['en']!['pruningInstructions']!;
  String get pestControlInstructions => _localizedValues[locale.languageCode]?['pestControlInstructions'] ?? _localizedValues['en']!['pestControlInstructions']!;
  String get cancel => _localizedValues[locale.languageCode]?['cancel'] ?? _localizedValues['en']!['cancel']!;
  String get noPlantsAssigned => _localizedValues[locale.languageCode]?['noPlantsAssigned'] ?? _localizedValues['en']!['noPlantsAssigned']!;
  String get pending => _localizedValues[locale.languageCode]?['pending'] ?? _localizedValues['en']!['pending']!;
  String get overallStatistics => _localizedValues[locale.languageCode]?['overallStatistics'] ?? _localizedValues['en']!['overallStatistics']!;
  String get mothersWithPlants => _localizedValues[locale.languageCode]?['mothersWithPlants'] ?? _localizedValues['en']!['mothersWithPlants']!;
  String get totalPlants => _localizedValues[locale.languageCode]?['totalPlants'] ?? _localizedValues['en']!['totalPlants']!;
  String get completedUploads => _localizedValues[locale.languageCode]?['completedUploads'] ?? _localizedValues['en']!['completedUploads']!;
  String get pendingUploads => _localizedValues[locale.languageCode]?['pendingUploads'] ?? _localizedValues['en']!['pendingUploads']!;
  String get overdueUploads => _localizedValues[locale.languageCode]?['overdueUploads'] ?? _localizedValues['en']!['overdueUploads']!;
  String get noMothersFound => _localizedValues[locale.languageCode]?['noMothersFound'] ?? _localizedValues['en']!['noMothersFound']!;
  String get noResultsFound => _localizedValues[locale.languageCode]?['noResultsFound'] ?? _localizedValues['en']!['noResultsFound']!;
  String get noMothersRegisteredYet => _localizedValues[locale.languageCode]?['noMothersRegisteredYet'] ?? _localizedValues['en']!['noMothersRegisteredYet']!;
  String get noMothersForSearch => _localizedValues[locale.languageCode]?['noMothersForSearch'] ?? _localizedValues['en']!['noMothersForSearch']!;
  String get motherDetails => _localizedValues[locale.languageCode]?['motherDetails'] ?? _localizedValues['en']!['motherDetails']!;
  String get plantMonitoringDetails => _localizedValues[locale.languageCode]?['plantMonitoringDetails'] ?? _localizedValues['en']!['plantMonitoringDetails']!;

  // Helper method to get display text for enum values
  String getDisplayText(String value) {
    switch (value) {
      // Plant types
      case 'mango': return mango;
      case 'guava': return guava;
      case 'amla': return amla;
      case 'papaya': return papaya;
      case 'moon': return moon;
      
      // Delivery types
      case 'normal': return normalDelivery;
      case 'cesarean': return cesareanDelivery;
      case 'assisted': return assistedDelivery;
      
      // Blood groups - return the symbol directly since we're using symbols now
      case 'A+': return 'A+';
      case 'A-': return 'A-';
      case 'B+': return 'B+';
      case 'B-': return 'B-';
      case 'AB+': return 'AB+';
      case 'AB-': return 'AB-';
      case 'O+': return 'O+';
      case 'O-': return 'O-';
      
      default: return value;
    }
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'hi'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return Future.value(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
} 