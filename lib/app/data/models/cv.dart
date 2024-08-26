class CV {
  final String name;
  final String jobTitle;
  final String profileImagePath;
  final String about;
  final String phone;
  final String email;
  final String address;
  final List<String> languages;
  final List<String> skills;
  final List<Experience> experiences;
  final List<Education> education;
  final List<Project> projects;
  final Map<String, int> skillSummary;

  CV({
    required this.name,
    required this.jobTitle,
    required this.profileImagePath,
    required this.about,
    required this.phone,
    required this.email,
    required this.address,
    required this.languages,
    required this.skills,
    required this.experiences,
    required this.education,
    required this.projects,
    required this.skillSummary,
  });
}

class Experience {
  final String jobTitle;
  final String company;
  final String location;
  final String duration;
  final String description;

  Experience({
    required this.jobTitle,
    required this.company,
    required this.location,
    required this.duration,
    required this.description,
  });
}

class Education {
  final String degree;
  final String institution;
  final String duration;

  Education({
    required this.degree,
    required this.institution,
    required this.duration,
  });
}

class Project {
  final String name;
  final String description;
  final String duration;
  final List<String> technologies;
  final String link;


  Project({
    required this.name,
    required this.description,
    required this.duration,
    required this.technologies,
    required this.link,
  
  });
}
