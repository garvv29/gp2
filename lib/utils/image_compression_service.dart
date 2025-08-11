import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageCompressionService {
  static const int maxWidth = 1024;
  static const int maxHeight = 1024;
  static const int quality = 85;
  static const int maxFileSizeKB = 500; // 500KB max

  /// Compress image file and return compressed file path
  static Future<File?> compressImage(File imageFile) async {
    try {
      // Get file info
      final int originalSize = await imageFile.length();
      print('📸 Original image size: ${(originalSize / 1024).round()} KB');

      // If file is already small enough, return original
      if (originalSize <= maxFileSizeKB * 1024) {
        print('✅ Image already optimized, skipping compression');
        return imageFile;
      }

      // Get temporary directory
      final Directory tempDir = await getTemporaryDirectory();
      final String fileName = path.basenameWithoutExtension(imageFile.path);
      final String extension = path.extension(imageFile.path).toLowerCase();
      
      // Generate output path
      final String outputPath = path.join(
        tempDir.path,
        '${fileName}_compressed_${DateTime.now().millisecondsSinceEpoch}${extension.isEmpty ? '.jpg' : extension}'
      );

      // Compress image
      final XFile? compressedFile = await FlutterImageCompress.compressAndGetFile(
        imageFile.absolute.path,
        outputPath,
        quality: quality,
        minWidth: 300,
        minHeight: 300,
        format: extension == '.png' ? CompressFormat.png : CompressFormat.jpeg,
        autoCorrectionAngle: true,
        keepExif: false, // Remove EXIF data to reduce size
      );

      if (compressedFile != null) {
        final File compressed = File(compressedFile.path);
        final int compressedSize = await compressed.length();
        final double compressionRatio = ((originalSize - compressedSize) / originalSize * 100);
        
        print('✅ Image compressed successfully:');
        print('   Original: ${(originalSize / 1024).round()} KB');
        print('   Compressed: ${(compressedSize / 1024).round()} KB');
        print('   Reduction: ${compressionRatio.toStringAsFixed(1)}%');
        
        return compressed;
      } else {
        print('❌ Image compression failed');
        return imageFile; // Return original if compression fails
      }
    } catch (e) {
      print('❌ Error compressing image: $e');
      return imageFile; // Return original if error occurs
    }
  }

  /// Compress image from Uint8List bytes
  static Future<Uint8List?> compressImageBytes(
    Uint8List bytes, {
    int? customQuality,
    int? customMaxWidth,
    int? customMaxHeight,
  }) async {
    try {
      print('📸 Compressing image bytes, original size: ${(bytes.length / 1024).round()} KB');

      final Uint8List? compressedBytes = await FlutterImageCompress.compressWithList(
        bytes,
        quality: customQuality ?? quality,
        minWidth: 300,
        minHeight: 300,
        format: CompressFormat.jpeg,
        autoCorrectionAngle: true,
        keepExif: false,
      );

      if (compressedBytes != null) {
        final double compressionRatio = ((bytes.length - compressedBytes.length) / bytes.length * 100);
        
        print('✅ Bytes compressed successfully:');
        print('   Original: ${(bytes.length / 1024).round()} KB');
        print('   Compressed: ${(compressedBytes.length / 1024).round()} KB');
        print('   Reduction: ${compressionRatio.toStringAsFixed(1)}%');
        
        return compressedBytes;
      }

      return bytes; // Return original if compression fails
    } catch (e) {
      print('❌ Error compressing image bytes: $e');
      return bytes; // Return original if error occurs
    }
  }

  /// Get image file size in KB
  static Future<double> getImageSizeKB(File imageFile) async {
    try {
      final int sizeInBytes = await imageFile.length();
      return sizeInBytes / 1024;
    } catch (e) {
      print('❌ Error getting image size: $e');
      return 0.0;
    }
  }

  /// Check if image needs compression
  static Future<bool> needsCompression(File imageFile) async {
    final double sizeKB = await getImageSizeKB(imageFile);
    return sizeKB > maxFileSizeKB;
  }

  /// Clean up temporary compressed files
  static Future<void> cleanupTempFiles() async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      final List<FileSystemEntity> files = tempDir.listSync();
      
      for (final file in files) {
        if (file is File && file.path.contains('_compressed_')) {
          await file.delete();
        }
      }
      
      print('🧹 Temporary compressed files cleaned up');
    } catch (e) {
      print('❌ Error cleaning up temp files: $e');
    }
  }
}
