import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'logger.dart';

class ImageProcessor {

  static Future<String> processImage({
    required String imagePath,
    required double brightness,
    required double skinSmoothing,
    required double skinTone,
    required String backgroundColor,
    int? customColorValue,
    double backgroundThreshold = 50.0,
    double? width,
    double? height,
    String? unit,
    required String format,
    String? resolution,
  }) async {
    try {
      final originalImage = img.decodeImage(File(imagePath).readAsBytesSync());
      if (originalImage == null) {
        throw Exception('Failed to decode image');
      }

      var processedImage = originalImage;
      
      processedImage = _applyBrightness(processedImage, brightness);
      processedImage = _applySkinSmoothing(processedImage, skinSmoothing);
      processedImage = _applySkinTone(processedImage, skinTone);
      
      processedImage = await _applyBackground(processedImage, imagePath, backgroundColor, customColorValue, backgroundThreshold);

      if (width != null && height != null && unit != null && resolution != null) {
        final targetWidth = _convertToPixels(width, unit, resolution);
        final targetHeight = _convertToPixels(height, unit, resolution);

        img.Color bgColor;
        if (backgroundColor == 'custom' && customColorValue != null) {
          final color = Color(customColorValue);
          bgColor = img.ColorRgb8(color.red, color.green, color.blue);
        } else {
          switch (backgroundColor) {
            case 'white':
              bgColor = img.ColorRgb8(255, 255, 255);
              break;
            case 'blue':
              bgColor = img.ColorRgb8(59, 130, 246);
              break;
            case 'red':
              bgColor = img.ColorRgb8(239, 68, 68);
              break;
            default:
              bgColor = img.ColorRgb8(255, 255, 255);
          }
        }

        final canvas = img.Image(width: targetWidth, height: targetHeight);
        for (var y = 0; y < targetHeight; y++) {
          for (var x = 0; x < targetWidth; x++) {
            canvas.setPixel(x, y, bgColor);
          }
        }

        final imageAspectRatio = processedImage.width / processedImage.height;
        final canvasAspectRatio = targetWidth / targetHeight;
        
        int resizedWidth;
        int resizedHeight;
        
        if (imageAspectRatio > canvasAspectRatio) {
          resizedWidth = targetWidth;
          resizedHeight = (targetWidth / imageAspectRatio).round();
        } else {
          resizedHeight = targetHeight;
          resizedWidth = (targetHeight * imageAspectRatio).round();
        }

        final resizedImage = img.copyResize(
          processedImage,
          width: resizedWidth,
          height: resizedHeight,
          interpolation: img.Interpolation.cubic,
        );

        final offsetX = (targetWidth - resizedImage.width) ~/ 2;
        final offsetY = (targetHeight - resizedImage.height) ~/ 2;

        img.compositeImage(canvas, resizedImage, dstX: offsetX, dstY: offsetY);
        processedImage = canvas;
      }

      final outputPath = await _saveProcessedImage(processedImage, format);
      Logger.i('Image saved to: $outputPath, background: $backgroundColor');
      return outputPath;
    } catch (e) {
      Logger.e('Error processing image', e);
      rethrow;
    }
  }

  static img.Image _applyBrightness(img.Image image, double brightness) {
    if (brightness == 0) return image;
    
    final result = img.Image(width: image.width, height: image.height);
    final brightnessFactor = brightness / 100.0;
    
    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        final r = pixel.r.toInt();
        final g = pixel.g.toInt();
        final b = pixel.b.toInt();
        final a = pixel.a.toInt();
        
        double newR, newG, newB;
        if (brightnessFactor > 0) {
          newR = r + brightnessFactor * (255 - r);
          newG = g + brightnessFactor * (255 - g);
          newB = b + brightnessFactor * (255 - b);
        } else {
          newR = r * (1.0 + brightnessFactor);
          newG = g * (1.0 + brightnessFactor);
          newB = b * (1.0 + brightnessFactor);
        }
        
        result.setPixel(x, y, img.ColorRgba8(
          newR.clamp(0, 255).round(),
          newG.clamp(0, 255).round(),
          newB.clamp(0, 255).round(),
          a,
        ));
      }
    }
    
    return result;
  }

  static img.Image _applySkinSmoothing(img.Image image, double smoothing) {
    if (smoothing == 0) return image;
    
    final blurRadius = (smoothing / 100 * 3).round();
    if (blurRadius <= 0) return image;
    
    return img.gaussianBlur(image, radius: blurRadius);
  }

  static img.Image _applySkinTone(img.Image image, double tone) {
    if (tone == 0) return image;
    
    final result = img.Image(width: image.width, height: image.height);
    final saturationFactor = tone / 100.0;
    
    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        final r = pixel.r.toInt();
        final g = pixel.g.toInt();
        final b = pixel.b.toInt();
        final a = pixel.a.toInt();
        
        final gray = (r * 0.299 + g * 0.587 + b * 0.114).round();
        
        double newR = r + saturationFactor * (r - gray);
        double newG = g + saturationFactor * (g - gray);
        double newB = b + saturationFactor * (b - gray);
        
        result.setPixel(x, y, img.ColorRgba8(
          newR.clamp(0, 255).round(),
          newG.clamp(0, 255).round(),
          newB.clamp(0, 255).round(),
          a,
        ));
      }
    }
    
    return result;
  }

  static Future<img.Image> _applyBackground(img.Image image, String imagePath, String backgroundColor, int? customColorValue, double backgroundThreshold) async {
    Logger.i('Applying background: $backgroundColor, image size: ${image.width}x${image.height}');
    
    if (backgroundColor == 'transparent') {
      Logger.i('Background is transparent, returning original image');
      return image;
    }

    img.Color bgColor;
    if (backgroundColor == 'custom' && customColorValue != null) {
      final color = Color(customColorValue);
      bgColor = img.ColorRgb8(color.red, color.green, color.blue);
      Logger.i('Custom background color: R=${color.red}, G=${color.green}, B=${color.blue}');
    } else {
      switch (backgroundColor) {
        case 'white':
          bgColor = img.ColorRgb8(255, 255, 255);
          Logger.i('Background color: white (255, 255, 255)');
          break;
        case 'blue':
          bgColor = img.ColorRgb8(59, 130, 246);
          Logger.i('Background color: blue (59, 130, 246)');
          break;
        case 'red':
          bgColor = img.ColorRgb8(239, 68, 68);
          Logger.i('Background color: red (239, 68, 68)');
          break;
        default:
          bgColor = img.ColorRgb8(255, 255, 255);
          Logger.i('Background color: default white (255, 255, 255)');
      }
    }

    final result = img.Image(
      width: image.width,
      height: image.height,
    );
    
    
    Logger.i('Filling result image with background color: ${bgColor.r}, ${bgColor.g}, ${bgColor.b}');
    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        result.setPixel(x, y, bgColor);
      }
    }
    Logger.i('Background color filled, starting color-based processing');
    
    {
      final edgePixels = <img.Pixel>[];
      final edgeSize = 8;
      
      for (var x = 0; x < image.width; x++) {
        for (var i = 0; i < edgeSize; i++) {
          edgePixels.add(image.getPixel(x, i));
          edgePixels.add(image.getPixel(x, image.height - 1 - i));
        }
      }
      for (var y = 0; y < image.height; y++) {
        for (var i = 0; i < edgeSize; i++) {
          edgePixels.add(image.getPixel(i, y));
          edgePixels.add(image.getPixel(image.width - 1 - i, y));
        }
      }
      
      int totalR = 0, totalG = 0, totalB = 0;
      int validPixels = 0;
      for (final pixel in edgePixels) {
        final a = pixel.a.toInt();
        if (a > 200) {
          totalR += pixel.r.toInt();
          totalG += pixel.g.toInt();
          totalB += pixel.b.toInt();
          validPixels++;
        }
      }
      
      if (validPixels == 0) {
        for (var y = 0; y < image.height; y++) {
          for (var x = 0; x < image.width; x++) {
            result.setPixel(x, y, bgColor);
          }
        }
        Logger.w('No valid edge pixels found, filled entire image with background color');
        return result;
      }
      
      final avgR = totalR / validPixels;
      final avgG = totalG / validPixels;
      final avgB = totalB / validPixels;
      
      final isWhiteBackground = avgR > 240 && avgG > 240 && avgB > 240;
      
      final minThreshold = isWhiteBackground ? 20.0 : 30.0;
      final maxThreshold = isWhiteBackground ? 120.0 : 150.0;
      final baseThreshold = minThreshold + (backgroundThreshold / 100.0) * (maxThreshold - minThreshold);
      
      int replacedPixels = 0;
      int keptPixels = 0;
      
      final centerX = image.width / 2.0;
      final centerY = image.height / 2.0;
      final maxDistance = math.sqrt(centerX * centerX + centerY * centerY);
      
      final centerRegionWidth = image.width * 0.45;
      final centerRegionHeight = image.height * 0.55;
      final centerRegion = Rect.fromCenter(
        center: Offset(centerX, centerY),
        width: centerRegionWidth,
        height: centerRegionHeight,
      );
      
      for (var y = 0; y < image.height; y++) {
        for (var x = 0; x < image.width; x++) {
          final pixel = image.getPixel(x, y);
          final r = pixel.r.toInt();
          final g = pixel.g.toInt();
          final b = pixel.b.toInt();
          final a = pixel.a.toInt();
          
          if (a < 200) {
            result.setPixel(x, y, bgColor);
            replacedPixels++;
            continue;
          }
          
          final point = Offset(x.toDouble(), y.toDouble());
          final isInCenterRegion = centerRegion.contains(point);
          
          final distanceFromCenter = math.sqrt(
            math.pow(x - centerX, 2) + 
            math.pow(y - centerY, 2)
          );
          final normalizedDistance = distanceFromCenter / maxDistance;
          
          final centerProtection = isInCenterRegion 
              ? 0.2 + normalizedDistance * 0.5
              : 0.8 + normalizedDistance * 0.2;
          
          final colorDistance = _colorDistance(r, g, b, avgR.toInt(), avgG.toInt(), avgB.toInt());
          final threshold = baseThreshold * centerProtection;
          
          final brightness = (r + g + b) / 3.0;
          final backgroundBrightness = (avgR + avgG + avgB) / 3.0;
          final brightnessDiff = (brightness - backgroundBrightness).abs();
          
          final saturation = _calculateSaturation(r, g, b);
          
          bool isBackground = false;
          
          if (isInCenterRegion) {
            final strictThreshold = threshold * 0.95;
            final isColorMatch = colorDistance < strictThreshold;
            final isBrightnessMatch = brightnessDiff < 35;
            final isLowSaturation = saturation < 0.4;
            
            isBackground = (isColorMatch || (isBrightnessMatch && isLowSaturation)) && a > 200;
          } else {
            final isColorMatch = colorDistance < threshold;
            final isBrightnessMatch = brightnessDiff < 50;
            final isLowSaturation = saturation < 0.5;
            
            isBackground = (isColorMatch || (isBrightnessMatch && isLowSaturation)) && a > 200;
          }
          
          if (isBackground) {
            result.setPixel(x, y, bgColor);
            replacedPixels++;
          } else {
            result.setPixel(x, y, pixel);
            keptPixels++;
          }
        }
      }
      
      final replacedRatio = (replacedPixels / (replacedPixels + keptPixels) * 100).toStringAsFixed(1);
      Logger.i('✅ Background replaced using color-based method');
      Logger.i('📊 Result: Replaced pixels=$replacedPixels ($replacedRatio%), Kept pixels=$keptPixels');
      Logger.i('📊 Color analysis: Avg R=${avgR.toStringAsFixed(1)}, G=${avgG.toStringAsFixed(1)}, B=${avgB.toStringAsFixed(1)}, BaseThreshold=$baseThreshold, IsWhite=$isWhiteBackground');
    }
    
    return result;
  }
  
  
  static double _colorDistance(int r1, int g1, int b1, int r2, int g2, int b2) {
    final dr = r1 - r2;
    final dg = g1 - g2;
    final db = b1 - b2;
    return math.sqrt(dr * dr + dg * dg + db * db);
  }
  
  static double _calculateSaturation(int r, int g, int b) {
    final max = math.max(math.max(r, g), b);
    final min = math.min(math.min(r, g), b);
    if (max == 0) return 0;
    return (max - min) / max;
  }

  static int _convertToPixels(double size, String unit, String resolution) {
    final dpi = resolution == 'hd' ? 300 : 150;
    final mmToInch = 0.0393701;
    
    double inches;
    if (unit == 'mm') {
      inches = size * mmToInch;
    } else {
      inches = size;
    }
    
    return (inches * dpi).round();
  }

  static Future<String> _saveProcessedImage(img.Image image, String format) async {
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final extension = format == 'png' ? 'png' : 'jpg';
    final filePath = '${directory.path}/processed_$timestamp.$extension';
    
    final file = File(filePath);
    final bytes = format == 'png' 
        ? img.encodePng(image)
        : img.encodeJpg(image, quality: 90);
    await file.writeAsBytes(bytes);
    
    Logger.i('Saved processed image: $filePath, size: ${bytes.length} bytes, dimensions: ${image.width}x${image.height}');
    
    return filePath;
  }

  static Future<String> saveToGallery(String imagePath) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) {
        throw Exception('Image file not found');
      }

      final directory = await getApplicationDocumentsDirectory();
      final galleryPath = '${directory.path}/gallery';
      final galleryDir = Directory(galleryPath);
      if (!await galleryDir.exists()) {
        await galleryDir.create(recursive: true);
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = imagePath.split('.').last;
      final newPath = '$galleryPath/id_photo_$timestamp.$extension';
      
      await file.copy(newPath);
      Logger.i('Image saved to gallery: $newPath');
      return newPath;
    } catch (e) {
      Logger.e('Error saving to gallery', e);
      rethrow;
    }
  }
  
  static Future<String> createThumbnail(String imagePath) async {
    try {
      final originalImage = img.decodeImage(File(imagePath).readAsBytesSync());
      if (originalImage == null) {
        return imagePath;
      }
      
      final thumbnail = img.copyResize(
        originalImage,
        width: 200,
        height: 200,
        interpolation: img.Interpolation.cubic,
      );
      
      final thumbnailPath = imagePath.replaceAll(RegExp(r'\.[^.]+$'), '_thumb.jpg');
      await File(thumbnailPath).writeAsBytes(img.encodeJpg(thumbnail, quality: 80));
      
      return thumbnailPath;
    } catch (e) {
      Logger.e('Error creating thumbnail', e);
      return imagePath;
    }
  }

  static Future<String> createA4Layout({
    required List<String> imagePaths,
    required double imageWidth,
    required double imageHeight,
    required String unit,
  }) async {
    try {
      const a4WidthMm = 210.0;
      const a4HeightMm = 297.0;
      const dpi = 300;
      const mmToInch = 0.0393701;
      
      final a4WidthPx = (a4WidthMm * mmToInch * dpi).round();
      final a4HeightPx = (a4HeightMm * mmToInch * dpi).round();
      
      final imageWidthPx = _convertToPixels(imageWidth, unit, 'hd');
      final imageHeightPx = _convertToPixels(imageHeight, unit, 'hd');
      
      final imagesPerRow = (a4WidthPx / imageWidthPx).floor();
      final imagesPerCol = (a4HeightPx / imageHeightPx).floor();
      final maxImages = imagesPerRow * imagesPerCol;
      
      final layoutImage = img.Image(
        width: a4WidthPx,
        height: a4HeightPx,
      );
      img.fill(layoutImage, color: img.ColorRgb8(255, 255, 255));
      
      for (int i = 0; i < imagePaths.length && i < maxImages; i++) {
        final row = i ~/ imagesPerRow;
        final col = i % imagesPerRow;
        
        final x = col * imageWidthPx;
        final y = row * imageHeightPx;
        
        final imageFile = File(imagePaths[i]);
        if (await imageFile.exists()) {
          final image = img.decodeImage(await imageFile.readAsBytes());
          if (image != null) {
            final resizedImage = img.copyResize(
              image,
              width: imageWidthPx,
              height: imageHeightPx,
            );
            img.compositeImage(layoutImage, resizedImage, dstX: x, dstY: y);
          }
        }
      }
      
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${directory.path}/a4_layout_$timestamp.png';
      
      final file = File(filePath);
      await file.writeAsBytes(img.encodePng(layoutImage));
      
      Logger.i('A4 layout created: $filePath');
      return filePath;
    } catch (e) {
      Logger.e('Error creating A4 layout', e);
      rethrow;
    }
  }
}
