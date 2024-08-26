import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf_maker/app/data/models/cv.dart';
import 'package:printing/printing.dart';
class CvPdfHelper {
  static Future<Uint8List> generate(CV cv) async {
    final pdf = pw.Document();

    final profileImage = await networkImage(cv.profileImagePath);

    pdf.addPage(
      pw.MultiPage(
        pageTheme: _buildTheme(),
        build: (context) => [
          _buildHeader(cv, profileImage),
          _buildAboutMe(cv),
          _buildExperienceSection(cv),
          _buildEducationSection(cv),
          _buildSkillsAndLanguagesSection(cv),
          _buildProjectsSection(cv),
        ],
      ),
    );

    return pdf.save();
  }

  static pw.PageTheme _buildTheme() {
    return pw.PageTheme(
      margin: const pw.EdgeInsets.all(32),
      theme: pw.ThemeData.withFont(
        base: pw.Font.helvetica(),
        bold: pw.Font.helveticaBold(),
      ),
    );
  }

  static pw.Widget _buildHeader(CV cv, pw.ImageProvider profileImage) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      color: PdfColors.grey900,
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.ClipOval(
            child: pw.Image(profileImage, width: 80, height: 80),
          ),
          pw.SizedBox(width: 16),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                cv.name.toUpperCase(),
                style: pw.TextStyle(
                  fontSize: 24,
                  color: PdfColors.white,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                cv.jobTitle,
                style: pw.TextStyle(
                  fontSize: 16,
                  color: PdfColors.white,
                  fontWeight: pw.FontWeight.normal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildAboutMe(CV cv) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 24),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('About Me', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          pw.Text(cv.about),
          pw.SizedBox(height: 16),
          pw.Text('Phone: ${cv.phone}'),
          pw.Text('Email: ${cv.email}'),
          pw.Text('Address: ${cv.address}'),
        ],
      ),
    );
  }

  static pw.Widget _buildExperienceSection(CV cv) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 24),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Experience', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          ...cv.experiences.map((exp) {
            return pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 12),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    exp.jobTitle,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text('${exp.company} - ${exp.location}'),
                  pw.Text(exp.duration),
                  pw.SizedBox(height: 4),
                  pw.Text(exp.description),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  static pw.Widget _buildEducationSection(CV cv) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 24),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Education', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          ...cv.education.map((edu) {
            return pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 12),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    edu.degree,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(edu.institution),
                  pw.Text(edu.duration),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  static pw.Widget _buildSkillsAndLanguagesSection(CV cv) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 24),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Skills', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          pw.Wrap(
            spacing: 8,
            runSpacing: 8,
            children: cv.skills.map((skill) => pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey),
                borderRadius: pw.BorderRadius.circular(4),
              ),
              child: pw.Text(skill),
            )).toList(),
          ),
          pw.SizedBox(height: 30),
          pw.Text('Languages', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: cv.languages.map((lang) => pw.Text(lang)).toList(),
          ),
          pw.SizedBox(height: 16),
          pw.Text('Skills Summary', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          ...cv.skillSummary.entries.map((entry) => pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(entry.key),
              pw.Row(
                children: [
                  pw.Container(
                    width: 150,
                    height: 10,
                    child: pw.LinearProgressIndicator(
                      value: entry.value / 100.0,
                      backgroundColor: PdfColors.grey200,
                    ),
                  ),
                  pw.SizedBox(width: 5),
                  pw.Text('${entry.value}%'),
                ],
              ),
            ],
          )),
        ],
      ),
    );
  }

  static pw.Widget _buildProjectsSection(CV cv) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 24),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Projects', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          ...cv.projects.map((proj) {
            return pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 12),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    proj.name,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(proj.description),
                  pw.SizedBox(height: 4),
                  pw.Text('Duration: ${proj.duration}'),
                  pw.Text('Technologies: ${proj.technologies.join(', ')}'),
                  pw.UrlLink(destination: proj.link, child: pw.Text(proj.link, style: const pw.TextStyle(color: PdfColors.blue))),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}