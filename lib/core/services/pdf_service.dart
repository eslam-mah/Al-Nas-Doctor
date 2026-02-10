import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

/// Service to handle PDF generation from images
class PdfService {
  /// Maximum file size allowed (5MB)
  static const int maxFileSizeBytes = 5 * 1024 * 1024;

  /// Validates the file size
  /// Returns true if the file is within the limit
  static Future<bool> validateFileSize(File file) async {
    final fileSize = await file.length();
    return fileSize <= maxFileSizeBytes;
  }

  /// Gets the file size in MB
  static Future<double> getFileSizeMB(File file) async {
    final fileSize = await file.length();
    return fileSize / (1024 * 1024);
  }

  /// Composes multiple images into a single PDF document
  /// Returns the PDF file or null if generation fails
  static Future<File?> composeImagesToPdf({
    required List<File> images,
    required String fileName,
  }) async {
    if (images.isEmpty) {
      return null;
    }

    try {
      final pdf = pw.Document();

      for (final imageFile in images) {
        final imageBytes = await imageFile.readAsBytes();
        final image = pw.MemoryImage(imageBytes);

        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(20),
            build: (pw.Context context) {
              return pw.Center(child: pw.Image(image, fit: pw.BoxFit.contain));
            },
          ),
        );
      }

      final output = await getTemporaryDirectory();
      final file = File('${output.path}/$fileName.pdf');
      await file.writeAsBytes(await pdf.save());

      return file;
    } catch (e) {
      debugPrint('Error generating PDF: $e');
      return null;
    }
  }

  /// Composes all document images into a single submission PDF
  /// This includes identity documents, parent ID, and medical reports
  static Future<File?> composeSubmissionPdf({
    File? identityDocument,
    File? parentIdFront,
    File? parentIdBack,
    List<File> medicalReports = const [],
    required String patientName,
  }) async {
    try {
      final pdf = pw.Document();

      // Add header page
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Text(
                    'Al-Nas Hospital',
                    style: pw.TextStyle(
                      fontSize: 28,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Center(
                  child: pw.Text(
                    'Patient Documents Submission',
                    style: const pw.TextStyle(fontSize: 20),
                  ),
                ),
                pw.SizedBox(height: 40),
                pw.Divider(),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Patient Name: $patientName',
                  style: const pw.TextStyle(fontSize: 16),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Submission Date: ${DateTime.now().toString().split('.').first}',
                  style: const pw.TextStyle(fontSize: 16),
                ),
                pw.SizedBox(height: 40),
                pw.Text(
                  'Documents Included:',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                if (identityDocument != null)
                  pw.Bullet(text: 'Identity Document'),
                if (parentIdFront != null)
                  pw.Bullet(text: 'Parent/Patient ID - Front'),
                if (parentIdBack != null)
                  pw.Bullet(text: 'Parent/Patient ID - Back'),
                if (medicalReports.isNotEmpty)
                  pw.Bullet(
                    text: 'Medical Reports (${medicalReports.length} files)',
                  ),
              ],
            );
          },
        ),
      );

      // Add identity document
      if (identityDocument != null) {
        await _addImagePage(
          pdf: pdf,
          imageFile: identityDocument,
          title: 'Identity Document',
        );
      }

      // Add parent ID front
      if (parentIdFront != null) {
        await _addImagePage(
          pdf: pdf,
          imageFile: parentIdFront,
          title: 'Parent/Patient ID - Front Side',
        );
      }

      // Add parent ID back
      if (parentIdBack != null) {
        await _addImagePage(
          pdf: pdf,
          imageFile: parentIdBack,
          title: 'Parent/Patient ID - Back Side',
        );
      }

      // Add medical reports
      for (int i = 0; i < medicalReports.length; i++) {
        await _addImagePage(
          pdf: pdf,
          imageFile: medicalReports[i],
          title: 'Medical Report ${i + 1}',
        );
      }

      // Save the PDF
      final output = await getTemporaryDirectory();
      final sanitizedName = patientName
          .replaceAll(RegExp(r'[^\w\s]'), '')
          .replaceAll(' ', '_');
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File(
        '${output.path}/submission_${sanitizedName}_$timestamp.pdf',
      );
      await file.writeAsBytes(await pdf.save());

      return file;
    } catch (e) {
      debugPrint('Error generating submission PDF: $e');
      return null;
    }
  }

  /// Adds an image page to the PDF with a title
  static Future<void> _addImagePage({
    required pw.Document pdf,
    required File imageFile,
    required String title,
  }) async {
    final imageBytes = await imageFile.readAsBytes();
    final image = pw.MemoryImage(imageBytes);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                title,
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Expanded(
                child: pw.Center(
                  child: pw.Image(image, fit: pw.BoxFit.contain),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Gets the size of the generated PDF in MB
  static Future<double?> getPdfSizeMB(File pdfFile) async {
    if (!await pdfFile.exists()) {
      return null;
    }
    final fileSize = await pdfFile.length();
    return fileSize / (1024 * 1024);
  }
}
