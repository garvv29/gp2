import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/plant_monitoring.dart';

class PlantMonitoringService {
  static const String _plantMonitoringKey = 'plant_monitoring_data';
  static const String _nextIdKey = 'next_monitoring_id';

  // Generate monitoring schedule for a plant
  static PlantMonitoring generateMonitoringSchedule({
    required String plantId,
    required String motherId,
    required String plantName,
    required DateTime assignedDate,
  }) {
    final id = 'monitoring_${plantId}_${DateTime.now().millisecondsSinceEpoch}';
    
    // Generate 3 months of monitoring periods
    final monitoringPeriods = <MonitoringPeriod>[];
    
    for (int month = 1; month <= 3; month++) {
      final periodId = 'period_${id}_month_$month';
      final periodName = _getMonthName(month);
      
      List<MonitoringUpload> uploads = [];
      
      if (month == 1) {
        // First month: Weekly uploads (4 weeks)
        for (int week = 1; week <= 4; week++) {
          final uploadId = 'upload_${periodId}_week_$week';
          final dueDate = assignedDate.add(Duration(days: (month - 1) * 30 + (week - 1) * 7));
          
          uploads.add(MonitoringUpload(
            id: uploadId,
            uploadTitle: _getWeekName(week),
            dueDate: dueDate,
            status: 'pending',
          ));
        }
      } else {
        // Second and third months: Bi-weekly uploads (2 uploads per month)
        for (int half = 1; half <= 2; half++) {
          final uploadId = 'upload_${periodId}_half_$half';
          final dueDate = assignedDate.add(Duration(days: (month - 1) * 30 + (half - 1) * 15));
          
          uploads.add(MonitoringUpload(
            id: uploadId,
            uploadTitle: _getHalfName(half),
            dueDate: dueDate,
            status: 'pending',
          ));
        }
      }
      
      monitoringPeriods.add(MonitoringPeriod(
        id: periodId,
        monthNumber: month,
        periodName: periodName,
        uploads: uploads,
        status: 'pending',
      ));
    }
    
    return PlantMonitoring(
      id: id,
      plantId: plantId,
      motherId: motherId,
      plantName: plantName,
      assignedDate: assignedDate,
      monitoringPeriods: monitoringPeriods,
      status: 'active',
    );
  }

  // Save plant monitoring data
  static Future<bool> savePlantMonitoring(PlantMonitoring monitoring) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Get existing monitoring data
      List<PlantMonitoring> allMonitoring = await getAllPlantMonitoring();
      
      // Remove existing monitoring for this plant if exists
      allMonitoring.removeWhere((m) => m.plantId == monitoring.plantId);
      
      // Add new monitoring
      allMonitoring.add(monitoring);
      
      // Convert to JSON and save
      List<String> jsonList = allMonitoring.map((m) => jsonEncode(m.toJson())).toList();
      await prefs.setStringList(_plantMonitoringKey, jsonList);
      
      return true;
    } catch (e) {
      print('Error saving plant monitoring: $e');
      return false;
    }
  }

  // Get all plant monitoring data
  static Future<List<PlantMonitoring>> getAllPlantMonitoring() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String>? jsonList = prefs.getStringList(_plantMonitoringKey);
      
      if (jsonList == null || jsonList.isEmpty) {
        return [];
      }
      
      return jsonList.map((json) => PlantMonitoring.fromJson(jsonDecode(json))).toList();
    } catch (e) {
      print('Error getting plant monitoring: $e');
      return [];
    }
  }

  // Get monitoring data for a specific mother
  static Future<List<PlantMonitoring>> getMonitoringForMother(String motherId) async {
    try {
      List<PlantMonitoring> allMonitoring = await getAllPlantMonitoring();
      List<PlantMonitoring> motherMonitoring = allMonitoring.where((m) => m.motherId == motherId).toList();
      
      // Update overdue status for all monitoring data
      bool hasUpdates = false;
      for (var monitoring in motherMonitoring) {
        final updatedMonitoring = await _updateOverdueStatus(monitoring);
        if (updatedMonitoring != null && updatedMonitoring != monitoring) {
          // Replace the monitoring in the list
          final index = motherMonitoring.indexOf(monitoring);
          motherMonitoring[index] = updatedMonitoring;
          hasUpdates = true;
        }
      }
      
      // Save updates if any
      if (hasUpdates) {
        for (var monitoring in motherMonitoring) {
          await savePlantMonitoring(monitoring);
        }
      }
      
      return motherMonitoring;
    } catch (e) {
      return [];
    }
  }

  // Update overdue status for a monitoring
  static Future<PlantMonitoring?> _updateOverdueStatus(PlantMonitoring monitoring) async {
    try {
      final now = DateTime.now();
      bool hasChanges = false;
      
      List<MonitoringPeriod> updatedPeriods = [];
      
      for (var period in monitoring.monitoringPeriods) {
        List<MonitoringUpload> updatedUploads = [];
        
        for (var upload in period.uploads) {
          MonitoringUpload updatedUpload = upload;
          
          // Check if upload is overdue (due date has passed and status is still pending)
          if (upload.status == 'pending' && upload.dueDate.isBefore(now)) {
            updatedUpload = upload.copyWith(status: 'overdue');
            hasChanges = true;
          }
          
          updatedUploads.add(updatedUpload);
        }
        
        // Update period status based on uploads
        String periodStatus = period.status;
        if (updatedUploads.any((u) => u.status == 'overdue')) {
          periodStatus = 'in_progress';
        } else if (updatedUploads.every((u) => u.status == 'uploaded')) {
          periodStatus = 'completed';
        } else if (updatedUploads.any((u) => u.status == 'uploaded')) {
          periodStatus = 'in_progress';
        }
        
        if (periodStatus != period.status) {
          hasChanges = true;
        }
        
        updatedPeriods.add(MonitoringPeriod(
          id: period.id,
          monthNumber: period.monthNumber,
          periodName: period.periodName,
          uploads: updatedUploads,
          status: periodStatus,
        ));
      }
      
      if (hasChanges) {
        return monitoring.copyWith(monitoringPeriods: updatedPeriods);
      }
      
      return null;
    } catch (e) {
      print('Error updating overdue status: $e');
      return null;
    }
  }

  // Get monitoring data for a specific plant
  static Future<PlantMonitoring?> getMonitoringForPlant(String plantId) async {
    try {
      List<PlantMonitoring> allMonitoring = await getAllPlantMonitoring();
      return allMonitoring.firstWhere((m) => m.plantId == plantId);
    } catch (e) {
      return null;
    }
  }

  // Update monitoring upload
  static Future<bool> updateMonitoringUpload({
    required String plantId,
    required String uploadId,
    required String photoPath,
    String? description,
  }) async {
    try {
      final monitoring = await getMonitoringForPlant(plantId);
      if (monitoring == null) return false;
      
      // Find and update the upload
      for (var period in monitoring.monitoringPeriods) {
        for (var upload in period.uploads) {
          if (upload.id == uploadId) {
            final updatedUpload = upload.copyWith(
              photoPath: photoPath,
              description: description,
              uploadDate: DateTime.now(),
              status: 'uploaded',
            );
            
            // Update the upload in the period
            final uploadIndex = period.uploads.indexWhere((u) => u.id == uploadId);
            period.uploads[uploadIndex] = updatedUpload;
            
            // Update period status
            final allUploaded = period.uploads.every((u) => u.status == 'uploaded');
            final periodStatus = allUploaded ? 'completed' : 'in_progress';
            
            // Create updated monitoring
            final updatedMonitoring = monitoring.copyWith(
              monitoringPeriods: monitoring.monitoringPeriods.map((p) {
                if (p.id == period.id) {
                  return MonitoringPeriod(
                    id: p.id,
                    monthNumber: p.monthNumber,
                    periodName: p.periodName,
                    uploads: p.uploads,
                    status: periodStatus,
                  );
                }
                return p;
              }).toList(),
            );
            
            // Save updated monitoring
            return await savePlantMonitoring(updatedMonitoring);
          }
        }
      }
      
      return false;
    } catch (e) {
      print('Error updating monitoring upload: $e');
      return false;
    }
  }

  // Delete plant monitoring
  static Future<bool> deletePlantMonitoring(String plantId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<PlantMonitoring> allMonitoring = await getAllPlantMonitoring();
      
      // Remove the monitoring
      allMonitoring.removeWhere((m) => m.plantId == plantId);
      
      // Save updated list
      List<String> jsonList = allMonitoring.map((m) => jsonEncode(m.toJson())).toList();
      await prefs.setStringList(_plantMonitoringKey, jsonList);
      
      return true;
    } catch (e) {
      print('Error deleting plant monitoring: $e');
      return false;
    }
  }

  // Clear all monitoring data
  static Future<bool> clearAllMonitoring() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_plantMonitoringKey);
      return true;
    } catch (e) {
      print('Error clearing monitoring data: $e');
      return false;
    }
  }

  // Helper methods for Hindi names
  static String _getMonthName(int month) {
    switch (month) {
      case 1: return 'पहला महीना';
      case 2: return 'दूसरा महीना';
      case 3: return 'तीसरा महीना';
      default: return 'महीना $month';
    }
  }

  static String _getWeekName(int week) {
    switch (week) {
      case 1: return 'पहला सप्ताह';
      case 2: return 'दूसरा सप्ताह';
      case 3: return 'तीसरा सप्ताह';
      case 4: return 'चौथा सप्ताह';
      default: return 'सप्ताह $week';
    }
  }

  static String _getHalfName(int half) {
    switch (half) {
      case 1: return 'पहला पखवाड़ा';
      case 2: return 'दूसरा पखवाड़ा';
      default: return 'पखवाड़ा $half';
    }
  }

  // Get next ID
  static Future<String> getNextId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int nextId = prefs.getInt(_nextIdKey) ?? 1;
      
      // Increment and save
      await prefs.setInt(_nextIdKey, nextId + 1);
      
      return 'monitoring_$nextId';
    } catch (e) {
      return 'monitoring_${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  // Get real-time monitoring status for a mother (with overdue updates)
  static Future<List<PlantMonitoring>> getRealTimeMonitoringForMother(String motherId) async {
    try {
      List<PlantMonitoring> allMonitoring = await getAllPlantMonitoring();
      List<PlantMonitoring> motherMonitoring = allMonitoring.where((m) => m.motherId == motherId).toList();
      
      // Update overdue status for all monitoring data
      bool hasUpdates = false;
      for (int i = 0; i < motherMonitoring.length; i++) {
        final updatedMonitoring = await _updateOverdueStatus(motherMonitoring[i]);
        if (updatedMonitoring != null && updatedMonitoring != motherMonitoring[i]) {
          motherMonitoring[i] = updatedMonitoring;
          hasUpdates = true;
        }
      }
      
      // Save updates if any
      if (hasUpdates) {
        for (var monitoring in motherMonitoring) {
          await savePlantMonitoring(monitoring);
        }
      }
      
      return motherMonitoring;
    } catch (e) {
      print('Error getting real-time monitoring: $e');
      return [];
    }
  }
} 