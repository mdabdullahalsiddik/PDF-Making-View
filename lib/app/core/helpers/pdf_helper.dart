import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf_maker/app/data/models/cv.dart';

class CvPdfHelper {
  static Future<Uint8List> generate(CV cv) async {
    final pdf = pw.Document();

    pw.ImageProvider profileImage;
    try {
      final imageData = await rootBundle.load(cv.profileImagePath);
      profileImage = pw.MemoryImage(imageData.buffer.asUint8List());
    } catch (e) {
      profileImage = pw.MemoryImage(Uint8List(0));
    }

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            buildHeader(cv, profileImage),
            pw.SizedBox(height: 5),
            buildExperienceSection(cv),
            pw.SizedBox(height: 5),
            buildEducationSection(cv),
            pw.SizedBox(height: 5),
            buildSkillsSection(cv),
            pw.SizedBox(height: 10),
            buildLanguagesSection(cv),
            pw.SizedBox(height: 10),
            buildProjectsSection(cv),
            pw.SizedBox(height: 5),
          ],
        ),
      ),
    );

    return pdf.save();
  }

  static pw.Widget buildHeader(CV cv, pw.ImageProvider profileImage) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          width: 100,
          height: 100,
          child: pw.ClipRRect(
            child: pw.Image(profileImage, fit: pw.BoxFit.cover),
          ),
        ),
        pw.SizedBox(width: 20),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              cv.name,
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              cv.jobTitle,
              style:
                  pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.normal),
            ),
            pw.SizedBox(height: 10),
            pw.Text(cv.about),
            pw.SizedBox(height: 10),
            pw.Text('Phone: ${cv.phone}'),
            pw.Text('Email: ${cv.email}'),
            pw.Text('Address: ${cv.address}'),
          ],
        ),
      ],
    );
  }

  static pw.Widget buildExperienceSection(CV cv) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'EXPERIENCE',
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        ...cv.experiences.map((exp) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                '${exp.jobTitle} at ${exp.company}',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(exp.location),
              pw.Text(exp.duration),
              pw.SizedBox(height: 5),
              pw.Text(exp.description),
              pw.SizedBox(height: 10),
            ],
          );
        }),
      ],
    );
  }

  static pw.Widget buildEducationSection(CV cv) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'EDUCATION',
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        ...cv.education.map((edu) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                edu.degree,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(edu.institution),
              pw.Text(edu.duration),
              pw.SizedBox(height: 10),
            ],
          );
        }),
      ],
    );
  }

  static pw.Widget buildSkillsSection(CV cv) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'SKILLS',
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        pw.Wrap(
          spacing: 10,
          runSpacing: 10,
          children: cv.skills.map((skill) {
            return pw.Container(
              padding: const pw.EdgeInsets.all(5),
              decoration: pw.BoxDecoration(
                borderRadius: pw.BorderRadius.circular(5),
                border: pw.Border.all(color: PdfColors.black),
              ),
              child: pw.Text(skill),
            );
          }).toList(),
        ),
      ],
    );
  }

  static pw.Widget buildLanguagesSection(CV cv) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'LANGUAGES',
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        pw.Wrap(
          spacing: 10,
          runSpacing: 10,
          children: cv.languages.map((language) {
            return pw.Container(
              padding: const pw.EdgeInsets.all(5),
              decoration: pw.BoxDecoration(
                borderRadius: pw.BorderRadius.circular(5),
                border: pw.Border.all(color: PdfColors.black),
              ),
              child: pw.Text(language),
            );
          }).toList(),
        ),
      ],
    );
  }

  static pw.Widget buildProjectsSection(CV cv) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'PROJECTS',
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        ...cv.projects.map((project) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                project.name,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 5),
              pw.Text(project.description),
              pw.SizedBox(height: 5),
              pw.Text('Duration: ${project.duration}'),
              pw.SizedBox(height: 5),
              pw.Text('Technologies: ${project.technologies.join(', ')}'),
              pw.SizedBox(height: 5),
              pw.Text('Link: ${project.link}'),
              pw.SizedBox(height: 10),
            ],
          );
        }),
      ],
    );
  }
}
