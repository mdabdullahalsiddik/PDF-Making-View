import 'package:get/get.dart';
import 'package:pdf_maker/app/data/models/cv.dart';

class CvController extends GetxController {
  var cv = CV(
    name: 'Richard Sanchez',
    jobTitle: 'Product Designer',
    profileImagePath: 'assets/profile.jpg',
    about: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
    phone: '+123-456-7890',
    email: 'hello@reallygreatsite.com',
    address: '123 Anywhere St., Any City',
    languages: ['English', 'German (basic)', 'Spanish (basic)'],
    skills: [
      'Management Skills',
      'Creativity',
      'Digital Marketing',
      'Negotiation',
      'Critical Thinking',
      'Leadership'
    ],
    experiences: [
      Experience(
        jobTitle: 'Studio Showde',
        company: 'Canberra - Australia',
        location: '2020 - 2022',
        duration: 'Lorem ipsum dolor sit amet...',
        description: 'Lorem ipsum dolor sit amet...',
      ),
    ],
    education: [
      Education(
        degree: 'Bachelor of Business Management',
        institution: 'Borcell University',
        duration: '2014-2023',
      ),
      Education(
        degree: 'Master of Business Management',
        institution: 'Borcell University',
        duration: '2014-2018',
      ),
    ],
    projects: [
      Project(
        name: 'Awesome Project',
        description: 'Built an awesome project using Flutter.',
        duration: '2020 - 2021',
        technologies: ['Flutter', 'Firebase'],
        link: 'https://github.com/johndoe/awesome-project',
      ),
    ],
    skillSummary: {
      'Design Process': 78,
      'Project Management': 81,
    },
  ).obs;
}
